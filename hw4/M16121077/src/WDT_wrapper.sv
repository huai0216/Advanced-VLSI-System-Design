
module WDT_wrapper(
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

	output logic WTO

);
logic WDEN, WDLIVE;
logic [31:0] WTOCNT;
logic [31:0] waddr_reg;
enum logic [2:0] {s_WAIT = 3'b001, s_SEND_DATA = 3'b010, s_SEND_RESPONSE = 3'b100} WRITE_CS, WRITE_NS;
logic [`AXI_IDS_BITS-1:0] BID_reg;
logic [31:0] cnt;


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
				if(WVALID_S && WREADY_S && WLAST_S) WRITE_NS = s_SEND_RESPONSE;
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
				WREADY_S = 1'b1;
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
			
			waddr_reg <= 32'd0;
			BID_reg <= 8'd0;
			WDEN <= 1'b0;
			WDLIVE <= 1'b0;
			WTOCNT <= 32'd0;
			
		end else begin
			if(AWVALID_S && AWREADY_S)begin
				waddr_reg <= AWADDR_S;
				BID_reg <= AWID_S;
			end
			case(WRITE_CS)
				s_SEND_DATA : begin
					if(WVALID_S && WREADY_S)begin
						
						case(waddr_reg[15:0])
							16'h0100 : begin
								WDEN <= WDATA_S[0];
							end
							16'h0200 : begin
								WDLIVE <= WDATA_S[0];
							end
							16'h0300 : begin
								WTOCNT <= WDATA_S;
							end
							default : begin
								WDEN <= WDEN;
								WDLIVE <= WDLIVE;
								WTOCNT <= WTOCNT;
							end
						endcase
						
					end
					
				end
				
			endcase
			
		end
	end

	always_ff@(posedge ACLK )begin
		if(!ARESETn)begin
			cnt <= 32'd0;
			WTO <= 1'b0;
		end else begin
			if(WDEN && (cnt == WTOCNT))begin
				cnt <= 32'd0;
				WTO <= 1'b1;
			end else if(WDLIVE)begin
				cnt <= 32'd0;
				WTO <= 1'b0;
			end else if(WDEN)begin
				cnt <= cnt + 32'd1;
				WTO <= 1'b0;
			end
		end
	end







endmodule
