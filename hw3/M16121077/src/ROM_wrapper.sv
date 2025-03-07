`include "../include/AXI_define.svh"
module ROM_wrapper (
	input ACLK,
	input ARESETn,

	//SLAVE INTERFACE FOR MASTERS

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

	//ROM
	input [31:0] ROM_out,
	output logic ROM_read,
	output logic ROM_enable,
	output logic [11:0] ROM_address

);

logic [`AXI_LEN_BITS-1:0] ARLEN_INCR;
logic [1:0] READ_CS, READ_NS;
localparam [1:0] s_WAIT = 2'b01, s_SEND_DATA = 2'b10;
logic [11:0] address_reg;


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
				if(ARVALID_S) READ_NS = s_SEND_DATA;
				else READ_NS = s_WAIT;
			end 
			
			s_SEND_DATA : begin
				if(RLAST_S && RREADY_S) READ_NS = s_WAIT;
				else READ_NS = s_SEND_DATA;
			end
			default : begin
				READ_NS = READ_CS;
			end
		endcase
	end

	always_comb begin : read_output_logic
		ROM_read = 1'b1;
		ROM_enable = 1'b1;
		case(READ_CS)
			s_WAIT : begin
				RRESP_S = 2'b11;
				ARREADY_S = 1'b1;
				if(ARVALID_S && ARREADY_S)begin
					ROM_address = ARADDR_S[13:2];
				end else begin
					ROM_address = 12'd0;
				end
				RVALID_S = 1'b0;
				RDATA_S = 32'd0;
				RLAST_S = 1'b1;	
			end
			s_SEND_DATA : begin
				ARREADY_S = 1'b0;
				ROM_address = address_reg;
				RDATA_S = ROM_out;
				RRESP_S = 2'b00;
				RVALID_S = 1'b1;
				RLAST_S = (ARLEN_INCR == 32'd1);
			end
			default : begin
				RVALID_S = 1'b0;
				RRESP_S = 2'b11;
				ARREADY_S = 1'b0;
				RDATA_S = 32'd0;
				RLAST_S = 1'b1;
				ROM_address = 12'd0;
			end
		endcase
	end
	always_ff@(posedge ACLK )begin : read_datapath
		if(!ARESETn)begin
			RID_S <= 8'd0;
			ARLEN_INCR <= 32'd0;
			address_reg <= 12'd0;
		end else begin
			case(READ_CS)
				s_WAIT : begin 
					if(ARVALID_S)begin
						address_reg <= ARADDR_S[13:2];
						ARLEN_INCR <= ARLEN_S + 32'd1;
						RID_S <= ARID_S;
					end
				end
				s_SEND_DATA : begin
					if(RREADY_S) begin
						ARLEN_INCR <= ARLEN_INCR - 32'd1;
					end else begin
						ARLEN_INCR <= ARLEN_INCR;
					end
					
				end
			endcase
		end
	end



endmodule








