`include "AXI_define.svh"
module SRAM_wrapper (
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
	input RREADY_S

);
// read
logic [`AXI_LEN_BITS-1:0] ARLEN_INCR;
logic [1:0] READ_CS, READ_NS;
logic [1:0] WRITE_CS, WRITE_NS;
localparam [1:0] s_WAIT = 2'd0, s_SEND_DATA = 2'd1, s_SEND_RESPONSE = 2'd2;
logic [31:0] A, A_reg, A_write, A_read;
logic [31:0] DI, BWEB;
logic WEB, CEB;
logic [31:0] DO_reg;
logic [31:0] DO;

//write
logic [31:0] waddr_reg;
logic [`AXI_IDS_BITS-1:0] BID_reg;
logic write_sel;
logic writenow, readnow;

  TS1N16ADFPCLLLVTA512X45M4SWSHOD i_SRAM (
    .SLP(1'b0),
    .DSLP(1'b0),
    .SD(1'b0),
    .PUDELAY(),
    .CLK(ACLK),
	.CEB(CEB),
	.WEB(WEB),
    .A(A[15:2]),
	.D(DI),
    .BWEB(BWEB),
    .RTSEL(2'b01),
    .WTSEL(2'b01),
    .Q(DO)
);
	always_comb begin
		write_sel = (WVALID_S && WREADY_S);
		WEB = ~(WVALID_S && WREADY_S);
		A = (write_sel)?A_write : A_read;
	end
	always_ff@(posedge ACLK or negedge ARESETn)begin : write_fsm
		if(!ARESETn)begin
			WRITE_CS <= s_WAIT;
		end else begin
			WRITE_CS <= WRITE_NS;
		end
	end
	always_comb begin : write_next_state_logic
		case(WRITE_CS)
			s_WAIT : begin
				if(AWVALID_S && AWREADY_S) WRITE_NS = s_SEND_DATA;
				else WRITE_NS = s_WAIT;
			end
			s_SEND_DATA : begin
				if(WLAST_S && WVALID_S && WREADY_S) WRITE_NS = s_SEND_RESPONSE;
				else WRITE_NS = s_SEND_DATA;
			end
			s_SEND_RESPONSE : begin
				if(BVALID_S && BREADY_S) WRITE_NS = s_WAIT;
				else WRITE_NS = s_SEND_RESPONSE;
			end
			default : WRITE_NS = WRITE_CS;
		endcase
	end
	always_comb begin : write_output_logic
		case(WRITE_CS)
			s_WAIT : begin
				BWEB = 32'hffff_ffff;
				BVALID_S = 1'b0;
				BRESP_S = 2'b11;
				A_write = 32'd0;
				DI = 32'd0;
				BID_S = 8'd0;
				WREADY_S = 1'b0;
				AWREADY_S = ~readnow;
				writenow = 1'b0;
			end
			s_SEND_DATA : begin
				BWEB = 32'h0000_0000;
				BVALID_S = 1'b0;
				BRESP_S = 2'b11;
				BID_S = 8'd0;
				DI = WDATA_S;
				WREADY_S = 1'b1;
				AWREADY_S = 1'b0;
				writenow = 1'b1;
				if(WVALID_S && WREADY_S)begin
					A_write = waddr_reg;
					BWEB = ~{{8{WSTRB_S[3]}},{8{WSTRB_S[2]}}, {8{WSTRB_S[1]}}, {8{WSTRB_S[0]}}};
				end else begin
					A_write = 32'd0;
					BWEB = 32'h0000_0000;
					
				end
			end
			s_SEND_RESPONSE : begin
				writenow = 1'b1;
				BWEB = 32'hffff_ffff;
				BVALID_S = 1'b1;
				BRESP_S = 2'b00;
				BID_S = BID_reg;
				A_write = 32'd0;
				DI = 32'd0;
				WREADY_S = 1'b0;
				AWREADY_S = 1'b0;
			end
			default : begin
				writenow = 1'b0;
				BWEB = 32'hffff_ffff;
				BID_S = 8'd0;
				BVALID_S = 1'b0;
				BRESP_S = 2'b11;
				A_write = 32'd0;
				DI = 32'd0;
				WREADY_S = 1'b0;
				AWREADY_S = 1'b0;
			end
		endcase
	end

	always_ff@(posedge ACLK or negedge ARESETn)begin
		if(!ARESETn)begin
			waddr_reg <= 32'd0;
			BID_reg <= 8'd0;
		end else begin
			case(WRITE_CS)
				s_WAIT : begin
					if(AWVALID_S && AWREADY_S) begin
						waddr_reg <= AWADDR_S;
						BID_reg <= AWID_S;
					end
				end
				
			endcase
		end
	end

	always_ff@(posedge ACLK or negedge ARESETn)begin : fsm
		if(!ARESETn)begin
			READ_CS <= s_WAIT;
		end else begin
			READ_CS <= READ_NS;
		end
	end
	always_comb begin : next_state_logic
		case(READ_CS)
			s_WAIT : begin
				if(ARVALID_S && ARREADY_S) READ_NS = s_SEND_DATA;
				else READ_NS = s_WAIT;
			end 
			
			s_SEND_DATA : begin
				if(RLAST_S && RREADY_S && RVALID_S) READ_NS = s_WAIT;
				else READ_NS = s_SEND_RESPONSE;
			end
			s_SEND_RESPONSE : begin
				if(RLAST_S && RREADY_S && RVALID_S) READ_NS = s_WAIT;
				else READ_NS = s_SEND_RESPONSE;
			end
			default : begin
				READ_NS = READ_CS;
			end
		endcase
	end
	always_comb begin : read_output_logic
		CEB = 1'b0;
		case(READ_CS)
			
			s_WAIT : begin
				RRESP_S = 2'b11;
				ARREADY_S = ~writenow;
				if(ARVALID_S && ARREADY_S)begin
					A_read = ARADDR_S;
				end else begin
					A_read = 32'd0;
				end
				RVALID_S = 1'b0;
				RDATA_S = 32'd0;
				RLAST_S = 1'b1;	
				readnow = 1'b0;
			end
			s_SEND_DATA : begin
				ARREADY_S = 1'b0;
				A_read = A_reg;
				RDATA_S = DO;
				RRESP_S = 2'b00;
				RVALID_S = 1'b1;
				RLAST_S = (ARLEN_INCR == 4'd1);
				readnow = 1'b1;
			end
			s_SEND_RESPONSE : begin
				ARREADY_S = 1'b0;
				A_read = A_reg;
				RDATA_S = DO_reg;
				RRESP_S = 2'b00;
				RVALID_S = 1'b1;
				RLAST_S = (ARLEN_INCR == 4'd1);
				readnow = 1'b1;
			end
			default : begin
				RVALID_S = 1'b0;
				RRESP_S = 2'b11;
				ARREADY_S = 1'b0;
				RDATA_S = 32'd0;
				RLAST_S = 1'b1;
				A_read = 32'd0;
				readnow = 1'b0;
			end
		endcase
	end
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
	
endmodule
