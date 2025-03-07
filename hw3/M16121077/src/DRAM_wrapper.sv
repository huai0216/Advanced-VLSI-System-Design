`include "../include/AXI_define.svh"
module DRAM_wrapper (
	input ACLK,
	input ARESETn,

	//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
	input [`AXI_IDS_BITS-1:0] AWID_S,
	input [`AXI_ADDR_BITS-1:0] AWADDR_S,
	input [`AXI_LEN_BITS-1:0] AWLEN_S,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_S,
	input [1:0] AWBURST_S,
	input AWVALID_S,
	output logic AWREADY_S,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_S,
	input [`AXI_STRB_BITS-1:0] WSTRB_S,
	input WLAST_S,
	input WVALID_S,
	output logic WREADY_S,
	
	//WRITE RESPONSE
	output logic [`AXI_IDS_BITS-1:0] BID_S,
	output logic [1:0] BRESP_S,
	output logic BVALID_S,
	input BREADY_S,

	//READ ADDRESS0
	input [`AXI_IDS_BITS-1:0] ARID_S,
	input [`AXI_ADDR_BITS-1:0] ARADDR_S,
	input [`AXI_LEN_BITS-1:0] ARLEN_S,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_S,
	input [1:0] ARBURST_S,
	input ARVALID_S,
	output logic ARREADY_S,
	
	//READ DATA0
	output logic [`AXI_IDS_BITS-1:0] RID_S,
	output logic [`AXI_DATA_BITS-1:0] RDATA_S,
	output logic [1:0] RRESP_S,
	output logic RLAST_S,
	output logic RVALID_S,
	input RREADY_S,

	output logic CSn,
	output logic [3:0] WEn,
	output logic RASn,
	output logic CASn,
	output logic [10:0] A,
	output logic [31:0] D,
	input [31:0] Q,
	input valid

);
// read
logic [`AXI_LEN_BITS-1:0] ARLEN_INCR;
//localparam [4:0] s_WAIT = 5'b00001, s_PRE = 5'b00010, s_ACT = 5'b00100, s_WAIT_DRAM = 5'b01000, s_SEND_DATA = 5'b10000;
enum logic [4:0] {s_WAIT = 5'b00001, s_PRE = 5'b00010, s_ACT = 5'b00100, s_WAIT_DRAM = 5'b01000, s_SEND_DATA = 5'b10000}WRITE_CS, WRITE_NS, READ_CS, READ_NS ;
logic [31:0] addr_reg;

logic [2:0] cnt;

//write
//logic [4:0] WRITE_CS, WRITE_NS, READ_CS, READ_NS;
logic [`AXI_IDS_BITS-1:0] BID_reg;
logic write_sel;
logic writenow, readnow;
logic [31:0] data_reg;
logic [2:0] wcnt;
logic [31:0] waddr_reg;
logic read_now;

logic CASn_r, CASn_w;
logic RASn_r, RASn_w;
logic [3:0] WEn_r, WEn_w;
logic [31:0] length_reg;
logic [10:0] A_r, A_w;
logic first;
logic [31:0] wdata_reg;
logic [3:0] wstrb_reg;
logic [10:0] row_addr;
logic change_row;

	always_ff@(posedge ACLK )begin
		if(!ARESETn)begin
			addr_reg <= 32'd0;
			first <= 1'b0;
			wdata_reg <= 32'd0;
			row_addr <= 11'd0;
			change_row <= 1'b0;
			wstrb_reg <= 4'd0;
		end else begin
			if(AWVALID_S && AWREADY_S)begin
				addr_reg <= AWADDR_S;
				first <= 1'b1;
			end else if(ARVALID_S && ARREADY_S) begin
				addr_reg <= ARADDR_S;
				first <= 1'b1;
			end else if(RVALID_S && RREADY_S)begin
				addr_reg <= addr_reg + 32'd4;
			end
			if(WVALID_S && WREADY_S)begin
				wdata_reg <= WDATA_S;
				wstrb_reg <= WSTRB_S;
			end
			if((AWVALID_S && AWREADY_S))
				row_addr <= AWADDR_S[22:12];
			else if(ARVALID_S && ARREADY_S)
				row_addr <= ARADDR_S[22:12];
			else if(change_row)
				row_addr <= addr_reg[22:12];

			if((row_addr != addr_reg[22:12]) && (READ_CS == s_ACT))
				change_row <= 1'b1;
			else
				change_row <= 1'b0;
		end
	end

	always_comb begin
		if(read_now)begin
			A = A_r;
			CASn = CASn_r;
			RASn = RASn_r;
			WEn = WEn_r;
		end else begin
			A = A_w;
			CASn = CASn_w;
			RASn = RASn_w;
			WEn = WEn_w;
		end
		
	end

	

	always_ff@(posedge ACLK)begin : write_fsm
		if(!ARESETn)begin
			WRITE_CS <= s_WAIT;
		end else begin
			WRITE_CS <= WRITE_NS;
		end
	end

	always_comb begin : write_next_state_logic
		case(WRITE_CS)
			s_WAIT : begin
				if(AWVALID_S && ((AWADDR_S[22:12] == addr_reg[22:12]) || (!first))) WRITE_NS = s_ACT;
				else if (AWVALID_S) WRITE_NS = s_PRE;
				else WRITE_NS = s_WAIT;
			end
			s_PRE : begin
				if(wcnt == 3'd4) WRITE_NS = s_ACT;
				else WRITE_NS = s_PRE;
			end
			s_ACT : begin
				if(wcnt == 3'd4 && WVALID_S) WRITE_NS = s_WAIT_DRAM;
				else WRITE_NS = s_ACT;
			end
			s_WAIT_DRAM : begin
				if(BREADY_S) WRITE_NS = s_WAIT;
				else WRITE_NS = s_WAIT_DRAM;
			end
			
			default : begin
				WRITE_NS = WRITE_CS;
			end
		endcase
	end
	
	always_comb begin
		CSn = 1'b0;
		case(WRITE_CS)
			s_WAIT : begin
				AWREADY_S = ~read_now;
				WREADY_S = 1'b0;
				BID_S = 8'd0;
				BRESP_S = 2'd0;
				BVALID_S = 1'b0;
				if(AWVALID_S && ((AWADDR_S[22:12] != addr_reg[22:12]) || (!first)))begin
					RASn_w = 1'b0;
				end else begin
					RASn_w = 1'b1;
				end
				if(AWVALID_S && (first) && (AWADDR_S[22:12] != addr_reg[22:12]))begin
					WEn_w = 4'h0;
				end else begin
					WEn_w = 4'hf;
				end
				if(AWVALID_S && (!first)) A_w = AWADDR_S[22:12];
				else A_w = addr_reg[22:12];
				CASn_w = 1'b1;
				//WEn_w = 4'hf;
				D = wdata_reg;
			end
			s_PRE : begin
				AWREADY_S = 1'b0;
				WREADY_S = 1'b0;
				BID_S = 8'b0;
				BRESP_S = 2'd0;
				BVALID_S = 1'b0;
				A_w = addr_reg[22:12];
				RASn_w = ~(wcnt == 3'd4);
				CASn_w = 1'b1;
				WEn_w = 4'hf;
				D = wdata_reg;
			end
			s_ACT : begin	
				AWREADY_S = 1'b0;
				WREADY_S = (wcnt == 3'd4);
				BID_S = 8'b0;
				BRESP_S = 2'd0;
				BVALID_S = 1'b0;
				if(WVALID_S && (wcnt == 3'd4)) begin
					CASn_w = 1'b0;
					D = WDATA_S;
					WEn_w = ~WSTRB_S;
					A_w = addr_reg[12:2];
				end else begin
					CASn_w = 1'b1;
					D = wdata_reg;
					WEn_w = 4'hf;
					A_w = addr_reg[12:2];
				end
				RASn_w = 1'b1;
				
				
			end
			s_WAIT_DRAM : begin
				AWREADY_S = 1'b1;
				WREADY_S = 1'b0;
				BID_S = 8'b0;
				BRESP_S = 2'd0;
				BVALID_S = 1'b1;
				CASn_w = 1'b1;
				RASn_w = 1'b1;
				WEn_w = 4'hf;
				A_w = addr_reg[12:2];
				D = wdata_reg;
			end
			default : begin
				AWREADY_S = 1'b0;
				WREADY_S = 1'b0;
				BID_S = 8'b0;
				BRESP_S = 2'd0;
				BVALID_S = 1'b0;
				CASn_w = 1'b1;
				RASn_w = 1'b1;
				WEn_w = 4'hf;
				A_w = addr_reg[22:12];
				D = wdata_reg;
			end
		endcase
	end
	always_ff@(posedge ACLK )begin
		if(!ARESETn)begin
			wcnt <= 3'd0;
		end else begin
			case(WRITE_CS)
				s_WAIT : begin
					wcnt <= 3'd0;
					
				end
				s_PRE : begin
					if(wcnt == 3'd4) wcnt <= 3'd0;
					else wcnt <= wcnt + 3'd1;
				end
				s_ACT : begin
					if(wcnt == 3'd4 && WVALID_S) wcnt <= 3'd0;
					else if (wcnt == 3'd4) wcnt <= wcnt;
					else wcnt <= wcnt + 3'd1;
				end
				s_WAIT_DRAM : begin
					wcnt <= 3'd0;
				end
			endcase
		end
	end

	// read
	
	always_ff@(posedge ACLK )begin : fsm
		if(!ARESETn)begin
			READ_CS <= s_WAIT;
		end else begin
			READ_CS <= READ_NS;
		end
	end
	always_comb begin : next_state_logic
		case(READ_CS)
			s_WAIT : begin
				if(ARVALID_S && (ARADDR_S[22:12] == addr_reg[22:12])) READ_NS = s_ACT;
				else if(ARVALID_S || change_row) READ_NS = s_PRE;
				else READ_NS = s_WAIT;
			end 
			s_PRE : begin
				if(cnt == 3'd4) READ_NS = s_ACT;
				else READ_NS = s_PRE;
			end
			s_ACT : begin
				if(row_addr != addr_reg[22:12]) READ_NS = s_WAIT;
				else if(cnt == 3'd4 && RREADY_S) READ_NS = s_WAIT_DRAM;
				else READ_NS = s_ACT;
			end
			s_WAIT_DRAM : begin
				if(valid && RREADY_S && RLAST_S) READ_NS = s_WAIT;
				else if(valid && RREADY_S) READ_NS = s_ACT;
				else if(valid) READ_NS = s_SEND_DATA;
				else READ_NS = s_WAIT_DRAM;
			end
			s_SEND_DATA : begin
				if(RREADY_S && RLAST_S) READ_NS = s_WAIT;
				else if (RREADY_S) READ_NS = s_ACT;
				else READ_NS = s_SEND_DATA;
			end
			
			default : begin
				READ_NS = READ_CS;
			end
		endcase
	end

	always_comb begin : read_output_logic
		case(READ_CS)
			
			s_WAIT : begin
				ARREADY_S = 1'b1;
				RVALID_S = 1'b0;
				RDATA_S = 32'd0;
				RLAST_S = 1'b0;
				if((ARVALID_S && (ARADDR_S[22:12] != addr_reg[22:12])) || change_row) begin // || change_row
					RASn_r = 1'b0;
					WEn_r = 4'h0;
				end else begin
					RASn_r = 1'b1;
					WEn_r = 4'hf;
				end 
				if(ARVALID_S || change_row)begin // || change_row
					read_now = 1'b1;
				end else begin
					read_now = 1'b0;
				end
				//WEn_r = 4'hf;
				if(ARVALID_S && (!first)) A_r = ARADDR_S[22:12];
				else if (change_row) A_r = row_addr;
				else A_r = addr_reg[22:12];
				CASn_r = 1'b1;
				RRESP_S = 2'b11;
			end
			s_PRE : begin
				ARREADY_S = 1'b0;
				RVALID_S = 1'b0;
				RDATA_S = 32'd0;
				RLAST_S = 1'b0;
				CASn_r = 1'b1;
				RASn_r = ~(cnt == 3'd4);
				WEn_r = 4'hf;
				A_r = addr_reg[22:12];
				RRESP_S = 2'b11;
				read_now = 1'b1;
			end
			s_ACT : begin
				RASn_r = 1'b1;
				if(cnt == 3'd4 && RREADY_S)begin
					CASn_r = 1'b0;
					A_r = addr_reg[12:2];
				end else begin
					CASn_r = 1'b1;
					A_r = addr_reg[22:12];
				end
				RVALID_S = 1'b0;
				WEn_r = 4'hf;
				ARREADY_S = 1'b0;
				RDATA_S = 32'd0;
				RLAST_S = 1'b0;
				RRESP_S = 2'b11;
				read_now = 1'b1;
			end
			s_WAIT_DRAM : begin //tCL
				ARREADY_S = 1'b0;
				CASn_r = 1'b1;
				RASn_r = 1'b1;
				WEn_r = 4'hf;
				A_r = addr_reg[12:2];
				if(valid) begin
					RVALID_S = 1'b1;
					RLAST_S = (length_reg == 32'd0);
					RDATA_S = Q;
				end else begin
					RVALID_S = 1'b0;
					RLAST_S = 1'b0;
					RDATA_S = 32'd0;
				end
				RRESP_S = 2'b11;
				read_now = 1'b1;
			end
			s_SEND_DATA : begin
				ARREADY_S = 1'b0;
				CASn_r = 1'b1;
				RASn_r = 1'b1;
				WEn_r = 4'hf;
				A_r = addr_reg[12:2];
				RVALID_S = 1'b1;
				RLAST_S = (length_reg == 32'd0);
				RDATA_S = data_reg;
				RRESP_S = 2'b11;
				read_now = 1'b1;
			end
			default : begin
				CASn_r = 1'b1;
				RASn_r = 1'b1;
				WEn_r = 4'hf;
				RVALID_S = 1'b0;
				RRESP_S = 2'b11;
				ARREADY_S = 1'b0;
				RDATA_S = 32'd0;
				RLAST_S = 1'b1;
				read_now = 1'b0;
				A_r = 11'd0;
			end
		endcase
	end

	always_ff@(posedge ACLK)begin
		if(!ARESETn)begin
			cnt <= 3'd0;
			data_reg <= 32'd0;
			length_reg <= 32'd0;
		end else begin
			case(READ_CS)
				s_WAIT : begin
					cnt <= 3'd0;
					if(ARVALID_S) length_reg <= ARLEN_S;
				end
				s_PRE : begin
					if(cnt == 3'd4)begin
						cnt <= 3'd0;
					end else begin
						cnt <= cnt + 3'd1;
					end
				end
				s_ACT : begin
					if(cnt == 3'd4 && RVALID_S) begin
						cnt <= 3'd0;
					end else if (cnt == 3'd4) begin
						cnt <= 3'd4;
					end else begin
						cnt <= cnt + 3'd1;
					end
				end
				s_WAIT_DRAM : begin
					if(valid) begin
						cnt <= 3'd0;
						data_reg <= Q;
					end else begin
						cnt <= cnt; 
						data_reg <= data_reg;
					end
				end
			endcase
			if(RVALID_S && RREADY_S) begin
				length_reg <= length_reg - 32'd1;
			end
		end
	end

	
	/*
	always_ff@(posedge ACLK or negedge ARESETn)begin : read_datapath
		if(!ARESETn)begin
			RID_S <= 8'd0;
			ARLEN_INCR <= 4'd0;
			A_reg <= 32'd0;
			DO_reg <= 32'd0;
		end else begin
			case(READ_CS)
				s_WAIT : begin 
					if(ARVALID_S && ARREADY_S)begin
						A_reg <= A_read;
					end
					RID_S <= ARID_S;
					ARLEN_INCR <= ARLEN_S + 4'd1;
				end
				s_SEND_DATA : begin
					if(RREADY_S && RVALID_S) begin
						ARLEN_INCR <= ARLEN_INCR - 4'd1;
					end else begin
						ARLEN_INCR <= ARLEN_INCR;
					end
					DO_reg <= DO;
				end
				s_SEND_RESPONSE : begin
					if(RREADY_S && RVALID_S)begin
						ARLEN_INCR <= ARLEN_INCR - 4'd1;
					end else begin
						ARLEN_INCR <= ARLEN_INCR;
					end
				end
			endcase
		end
	end
	*/
	
endmodule
