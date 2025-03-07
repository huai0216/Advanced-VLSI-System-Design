`include "AXI_define.svh"
`include "CPU.sv"
module CPU_wrapper(
	input ACLK,
	input ARESETn,

	
	//WRITE ADDRESS1
	output logic [`AXI_ID_BITS-1:0] AWID_M1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_M1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	output logic [1:0] AWBURST_M1,
	output logic AWVALID_M1,
	input AWREADY_M1,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_M1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_M1,
	output logic WLAST_M1,
	output logic WVALID_M1,
	input WREADY_M1,
	
	//WRITE RESPONSE1
	input [`AXI_ID_BITS-1:0] BID_M1,
	input [1:0] BRESP_M1,
	input BVALID_M1,
	output logic BREADY_M1,
	
	//READ ADDRESS0
	output logic [`AXI_ID_BITS-1:0] ARID_M0,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_M0,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	output logic [1:0] ARBURST_M0,
	output logic ARVALID_M0,
	input ARREADY_M0,
	
	//READ DATA0
	input [`AXI_ID_BITS-1:0] RID_M0,
	input [`AXI_DATA_BITS-1:0] RDATA_M0,
	input [1:0] RRESP_M0,
	input RLAST_M0,
	input RVALID_M0,
	output logic RREADY_M0,
	
	//READ ADDRESS1
	output logic [`AXI_ID_BITS-1:0] ARID_M1,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_M1,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	output logic [1:0] ARBURST_M1,
	output logic ARVALID_M1,
	input ARREADY_M1,
	
	//READ DATA1
	input [`AXI_ID_BITS-1:0] RID_M1,
	input [`AXI_DATA_BITS-1:0] RDATA_M1,
	input [1:0] RRESP_M1,
	input RLAST_M1,
	input RVALID_M1,
	output logic RREADY_M1	


);

logic [1:0] CS_0, NS_0, CS_1, NS_1, CS_write1, NS_write1;
localparam [1:0] s_wait = 2'd0, s_addr = 2'd1, s_data = 2'd2, s_response = 2'd3;
logic [31:0] iaddr, daddr;
logic [31:0] inst, ddata;
logic [31:0] datawrite;
logic read_now, write_now, read_now0, write_now0;
logic write_dm, read_dm;
logic stall_im, stall, reading_dm, writing_dm;
logic read_im, write_im;
logic [31:0] iaddr_reg, inst_reg;
logic lock_dm;
logic [31:0] ddata_reg;
logic [31:0] bit_enable;
logic allow_read_dm;

	CPU cpu(
		.clk(ACLK), 
		.rst(~ARESETn), 
		.stall(stall),
		.inst(inst), 
		.ddata(ddata), 
		.iaddr(iaddr), 
		.memread(read_dm),
		.memwrite(write_dm),
		.daddr(daddr), 
		.datawrite(datawrite),
		.bit_enable(bit_enable)
	);

	always_comb begin
		allow_read_dm = read_dm && (!lock_dm);
	end
	always_ff@(posedge ACLK or negedge ARESETn)begin
		if(!ARESETn)begin
			read_im <= 1'b0;
			read_now <= 1'b0;
			write_now <= 1'b0;
			read_now0 <= 1'b0;
			write_now0 <= 1'b0;
			iaddr_reg <= 32'd0;
			inst <= 32'd0;
			ddata_reg <= 32'd0;
			ddata <= 32'd0;
			inst_reg <= 32'd0;
		end else begin
			read_im <= 1'b1;
			case(CS_write1)
				s_wait : begin
					write_now <= write_dm;
				end
				
			endcase
			case(CS_1)	
				s_wait : begin
					read_now <= allow_read_dm;
				end
				s_data : begin
					if(RVALID_M1 && RREADY_M1 && RLAST_M1)
						ddata_reg <= RDATA_M1;
				end
				
			endcase
			case(CS_0)
				s_wait : begin
					iaddr_reg <= iaddr;
					read_now0 <= read_im;
					write_now0 <= 1'b0;
				end
				s_data : begin
					if(RVALID_M0 && RREADY_M0 && RLAST_M0 && (!write_dm))begin
						inst <= RDATA_M0;
						ddata <= ddata_reg;
					end else 
					if(RVALID_M0 && RREADY_M0 && RLAST_M0)begin
						inst_reg <= RDATA_M0;
					end
					
				end
				s_response : begin
					ddata <= ddata_reg;
					inst <= inst_reg;
				end
			endcase
		end
	end
	
	always_ff@(posedge ACLK or negedge ARESETn)begin
		if(!ARESETn)begin
			lock_dm <= 1'b0;
		end else begin
			if(ARVALID_M0 && ARVALID_M1)begin
				lock_dm <= 1'b1;
			end else if (CS_0 == 2'd2 && CS_1 == 2'd0)begin
				lock_dm <= 1'b0;
			end else begin
				lock_dm <= lock_dm;
			end 
			
		end
	end		

	always_ff@(posedge ACLK or negedge ARESETn)begin : fsm
		if(!ARESETn)begin
			CS_0 <= s_wait;
			CS_1 <= s_wait;
			CS_write1 <= s_wait;
		end else begin
			CS_0 <= NS_0;
			CS_1 <= NS_1;
			CS_write1 <= NS_write1;
		end		
	end
	always_comb begin : next_state_logic_m0
		case(CS_0)
			s_wait : begin
				if(read_im && ARVALID_M0 && ARREADY_M0)begin
					NS_0 = s_data;
				end else if(read_im)begin
					NS_0 = s_addr;
				end else begin
					NS_0 = s_wait;
				end
			end
			s_addr : begin
				if((ARVALID_M0 && ARREADY_M0 && read_now0) ) NS_0 = s_data;
				else NS_0 = s_addr;
			end
			s_data : begin
				if(RVALID_M0 && RREADY_M0 && RLAST_M0 && (!write_dm)) NS_0 = s_wait;
				else if(RVALID_M0 && RREADY_M0 && RLAST_M0) NS_0 = s_response;
				else NS_0 = s_data;
			end
			s_response : begin
				NS_0 = s_wait;
			end
			
		endcase
		case(CS_1)
			s_wait : begin
				if(ARVALID_M1 && ARREADY_M1 && allow_read_dm)begin
					NS_1 = s_data;
				end else if (allow_read_dm)begin
					NS_1 = s_addr;
				end else begin
					NS_1 = s_wait;
				end
			end
			s_addr : begin
				if((ARVALID_M1 && ARREADY_M1 && read_now)) NS_1 = s_data;
				else NS_1 = s_addr;
			end
			s_data : begin
				if(RVALID_M1 && RREADY_M1 && RLAST_M1) 
					NS_1 = (write_dm) ? s_response : s_wait;
				else 
					NS_1 = s_data;
			end
			s_response : begin
				NS_1 = s_wait;
			end
		endcase
		case(CS_write1)
			s_wait : begin
				if(write_dm && (AWVALID_M1 && AWREADY_M1))begin
					NS_write1 = s_data;
				end else if(write_dm)begin
					NS_write1 = s_addr;
				end else begin
					NS_write1 = s_wait;
				end
			end
			s_addr : begin
				if((AWVALID_M1 && AWREADY_M1)) NS_write1 = s_data;
				else NS_write1 = s_addr;
			end
			s_data : begin
				if(WVALID_M1 && WREADY_M1 && WLAST_M1) NS_write1 = s_response;
				else NS_write1 = s_data;
			end
			s_response : begin
				if(BVALID_M1 && BREADY_M1) NS_write1 = s_wait;
				else NS_write1 = s_response;
			end
		endcase
	end
	always_comb begin
		case(CS_0)
			s_wait : begin
				//read
				ARID_M0 = 4'd0;
				ARVALID_M0 = read_im;
				ARADDR_M0 = iaddr;
				RREADY_M0 = 1'b0;
				ARLEN_M0 = 4'd0;
				ARSIZE_M0 = 3'b010;
				ARBURST_M0 = 2'b01;
				// cpu
				stall_im = read_im;
				
			end
			s_addr : begin
				ARID_M0 = 4'd0;
				ARLEN_M0 = 4'd0;
				ARVALID_M0 = read_now0;
				ARADDR_M0 = iaddr_reg;
				RREADY_M0 = 1'b0;
				ARSIZE_M0 = 3'b010;
				ARBURST_M0 = 2'b01;
				//response
				stall_im = 1'b1;
			end
			s_data : begin
				//read
				ARID_M0 = 4'd0;
				ARVALID_M0 = 1'b0;
				ARADDR_M0 = 32'd0;
				RREADY_M0 = read_now0;
				ARLEN_M0 = 4'd0;
				ARSIZE_M0 = 3'b010;
				ARBURST_M0 = 2'b10;
				stall_im = ~(RVALID_M0 && RREADY_M0 && RLAST_M0 && (!write_dm));
				
				
			end
			s_response : begin
				ARID_M0 = 4'd0;
				ARVALID_M0 = 1'b0;
				ARADDR_M0 = 32'd0;
				RREADY_M0 = 1'b0;
				ARLEN_M0 = 4'd0;
				ARSIZE_M0 = 3'b010;
				ARBURST_M0 = 2'b10;
				stall_im = 1'b0;
			end
		endcase
		case(CS_1)
			s_wait : begin
				//read
				ARID_M1 = 4'd0;
				ARVALID_M1 = 1'b0;
				RREADY_M1 = 1'b0;
				ARLEN_M1 = 4'd0;
				ARSIZE_M1 = 3'b010;
				ARBURST_M1 = 2'b01;
				reading_dm = allow_read_dm;
				ARVALID_M1 = allow_read_dm;
				if(allow_read_dm)begin
					ARADDR_M1 = daddr;
				end else begin
					ARADDR_M1 = 32'd0;
				end
			end
			s_addr : begin
				//read
				ARID_M1 = 4'd0;
				ARVALID_M1 = read_now;
				ARADDR_M1 = daddr;
				RREADY_M1 = 1'b0;
				ARLEN_M1 = 4'd0;
				ARSIZE_M1 = 3'b010;
				ARBURST_M1 = 2'b01;
				reading_dm = 1'b1;
				
			end
			s_data : begin
				ARID_M1 = 4'd0;
				ARVALID_M1 = 1'b0;
				ARADDR_M1 = 32'd0;
				RREADY_M1 = 1'b1;
				ARLEN_M1 = 4'd0;
				ARSIZE_M1 = 3'b010;
				ARBURST_M1 = 2'b01;
				reading_dm = ~(RVALID_M0 && RREADY_M0 && RLAST_M0 && (!write_dm));
			end
			s_response : begin
				ARID_M1 = 4'd0;
				ARVALID_M1 = 1'b0;
				ARADDR_M1 = 32'd0;
				RREADY_M1 = 1'b0;
				ARLEN_M1 = 4'd0;
				ARSIZE_M1 = 3'b010;
				ARBURST_M1 = 2'b01;
				reading_dm = 1'b0;
			end
		endcase
		case(CS_write1)
			s_wait : begin
				//write
				AWVALID_M1 = write_dm;
				AWID_M1 = 4'd0;
				AWADDR_M1 = daddr;
				AWLEN_M1 = 4'd0;
				AWSIZE_M1 = 3'b010;
				AWBURST_M1 = 2'b01;
				WDATA_M1 = 32'd0;
				WSTRB_M1 = 4'd0;
				WLAST_M1 = 1'b0;
				WVALID_M1 = 1'b0;
				BREADY_M1 = 1'b0;
				writing_dm = write_dm;
			end
			s_addr : begin
				
				//write
				AWVALID_M1 = 1'b1;
				AWADDR_M1 = daddr;
				AWID_M1 = 4'd0;
				AWLEN_M1 = 4'd0;
				AWSIZE_M1 = 3'b010;
				AWBURST_M1 = 2'b01;
				WDATA_M1 = 32'd0;
				WSTRB_M1 = 4'd0;
				WLAST_M1 = 1'b0;
				WVALID_M1 = 1'b0;
				BREADY_M1 = 1'b0;
				writing_dm = 1'b1;
			end
			s_data : begin
				
				//write
				AWVALID_M1 = 1'b0;
				AWADDR_M1 = 32'd0;
				AWID_M1 = 4'd0;
				AWLEN_M1 = 4'd0;
				AWSIZE_M1 = 3'b010;
				AWBURST_M1 = 2'b01;
				WDATA_M1 = datawrite;
				WSTRB_M1 = ~{(|bit_enable[31:24]), (|bit_enable[23:16]), (|bit_enable[15:8]), (|bit_enable[7:0])};
				WLAST_M1 = 1'b1;
				BREADY_M1 = 1'b0;
				WVALID_M1 = write_now;
				writing_dm = 1'b1;
			end
			s_response:begin
				writing_dm = BVALID_M1;
				//write
				AWVALID_M1 = 1'b0;
				AWADDR_M1 = 32'd0;
				AWID_M1 = 4'd0;
				AWLEN_M1 = 4'd0;
				AWSIZE_M1 = 3'b010;
				AWBURST_M1 = 2'b01;
				WDATA_M1 = 32'd0;
				WSTRB_M1 = 4'd0;
				WLAST_M1 = 1'b0;
				WVALID_M1 = 1'b0;
				//response
				BREADY_M1 = 1'b1;
				writing_dm = 1'b0;
			end
		endcase
	end
	always_comb begin
		stall = (stall_im||writing_dm||reading_dm);
		
	end



endmodule
