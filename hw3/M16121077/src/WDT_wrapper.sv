`include "../include/AXI_define.svh"
`include "synchronizer.sv"
//`include "synchronizer2.sv"
`include "WDT.sv"

module WDT_wrapper(
	input ACLK,
	input ACLK2,
	input ARESETn,
	input ARESETn2,
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

	output logic WTO

);
logic WDLIVE_reg, WDEN_reg, WDEN_valid, WDLIVE_valid, WTOCNT_valid, WDEN, WDLIVE, WDEN_out, WDLIVE_out, WDLIVE_en, WDEN_en, WTOCNT_en;
logic [31:0] WTOCNT_reg, WTOCNT, WTOCNT_out;
logic en_valid, wto_valid;
logic [31:0] waddr_reg;
enum logic [2:0] {s_WAIT = 3'b001, s_SEND_DATA = 3'b010, s_SEND_RESPONSE = 3'b100} WRITE_CS, WRITE_NS;
logic [`AXI_IDS_BITS-1:0] BID_reg;
logic start_cdc, start_cnt;
logic [5:0] cnt;
logic WDEN_cdc, WDLIVE_cdc;
logic WTOCNT_cdc, wto_cdc;
logic WLAST_reg;

	always_comb begin
		en_valid = WVALID_S && WREADY_S && (waddr_reg[15:0] == 16'h0100);
		
	end


	always_ff@(posedge ACLK )begin : write_fsm
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
				if(WLAST_reg && start_cnt && (cnt == 6'd0)) WRITE_NS = s_SEND_RESPONSE;
				else if(start_cnt && (cnt == 6'd0)) WRITE_NS = s_SEND_DATA;
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
				BVALID_S = 1'b0;
				BRESP_S = 2'b11;
				BID_S = 8'd0;
				WREADY_S = 1'b0;
				AWREADY_S = 1'b1;
			end
			s_SEND_DATA : begin
				BVALID_S = 1'b0;
				BRESP_S = 2'b11;
				BID_S = 8'd0;
				WREADY_S = (cnt == 6'd0);
				AWREADY_S = 1'b0;
			end
			s_SEND_RESPONSE : begin
				BVALID_S = 1'b1;
				BRESP_S = 2'b00;
				BID_S = BID_reg;
				WREADY_S = 1'b0;
				AWREADY_S = 1'b0;
			end
			default : begin
				BID_S = 8'd0;
				BVALID_S = 1'b0;
				BRESP_S = 2'b11;
				WREADY_S = 1'b0;
				AWREADY_S = 1'b0;
			end
		endcase
	end

	always_ff@(posedge ACLK )begin
		if(!ARESETn)begin
			WLAST_reg <= 1'b0;
			waddr_reg <= 32'd0;
			BID_reg <= 8'd0;
			WDEN_reg <= 1'b0;
			WDEN <= 1'b0;
			WDLIVE <= 1'b0;
			WTOCNT <= 32'd0;
			WDLIVE_reg <= 1'b0;
			WTOCNT_reg <= 32'd0;
			WDEN_valid <= 1'b0;
			WDEN_en <= 1'b0;
			WDLIVE_en <= 1'b0;
			WTOCNT_en <= 1'b0;
			WDLIVE_valid <= 1'b0;
			WTOCNT_valid <= 1'b0;
			start_cdc <= 1'b0;
			start_cnt <= 1'd0;
			cnt <= 6'd0;
			WTO <= 1'b0;
		end else begin
			if(AWVALID_S && AWREADY_S)begin
				waddr_reg <= AWADDR_S;
				BID_reg <= AWID_S;
			end
			case(WRITE_CS)
				s_SEND_DATA : begin
					if(WVALID_S && WREADY_S)begin
						start_cnt <= 1'b1;
						cnt <= 6'd50;
						WLAST_reg <= WLAST_S;
						case(waddr_reg[15:0])
							16'h0100 : begin
								WDEN_valid <= 1'b1;
								WDEN <= WDATA_S[0];
							end
							16'h0200 : begin
								WDLIVE_valid <= 1'b1;
								WDLIVE <= WDATA_S[0];
							end
							16'h0300 : begin
								WTOCNT_valid <= 1'b1;
								WTOCNT <= WDATA_S;
							end
							default : begin
								WDEN_valid <= WDEN_valid;
								WDLIVE_valid <= WDLIVE_valid;	
								WTOCNT_valid <= WTOCNT_valid;
								
							end
						endcase
						
					end
					if(start_cnt && cnt == 6'd0)begin
						cnt <= 6'd0;
						start_cnt <= 1'b0;
					end else if(start_cnt)begin
						cnt <= cnt - 6'd1;
					end
					if(cnt==6'd50)begin
						WDEN_reg <= WDEN;
						WDLIVE_reg <= WDLIVE;
						WTOCNT_reg <= WTOCNT;
					end
				end
				
			endcase
			/*
			if((cnt == 6'd0) && WVALID_S && WREADY_S)begin
				WDEN_reg <= WDEN;
				WDLIVE_reg <= WDLIVE;
				WTOCNT_reg <= WTOCNT;
			end
			*/
			
			if(wto_cdc)begin
				WTO <= 1'b1;
			end else begin
				WTO <= 1'b0;
			end
		end
	end

	always_ff@(posedge ACLK2)begin
		if(!ARESETn2)begin
			WDEN_out <= 1'b0;
		end else begin
			if(WDEN_cdc)begin
				WDEN_out <= WDEN_reg;
			end
		end
	end
	always_ff@(posedge ACLK2)begin
		if(!ARESETn2)begin
			WDLIVE_out <= 1'b0;
		end else begin
			if(WDLIVE_cdc)begin
				WDLIVE_out <= WDLIVE_reg;
			end
		end
	end
	always_ff@(posedge ACLK2)begin
		if(!ARESETn2)begin
			WTOCNT_out <= 32'd0;
		end else begin
			if(WTOCNT_cdc)begin
				WTOCNT_out <= WTOCNT_reg;
			end
		end
	end
	

synchronizer sync_en(
	.clk(ACLK2),
	.rst_n(ARESETn2),
	.D(WDEN_valid),
	.Q(WDEN_cdc)
);

synchronizer sync_live(
	.clk(ACLK2),
	.rst_n(ARESETn2),
	.D(WDLIVE_valid),
	.Q(WDLIVE_cdc)
);

synchronizer sync_cnt(
	.clk(ACLK2),
	.rst_n(ARESETn2),
	.D(WTOCNT_valid),
	.Q(WTOCNT_cdc)
);




WDT WDT(
	.clk(ACLK2), 
	.rst(ARESETn2), 
	.WDEN(WDEN_out),
	.WDLIVE(WDLIVE_out),
	.WTOCNT(WTOCNT_out),
	.WTO(wto_valid) 
);

synchronizer wto_sync(
	.clk(ACLK),
	.rst_n(ARESETn),
	.D(wto_valid),
	.Q(wto_cdc)
);

endmodule
