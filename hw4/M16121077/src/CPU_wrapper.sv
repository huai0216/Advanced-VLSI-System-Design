
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
	output logic RREADY_M1,	

	input interrupt_dma,
	input interrupt_time

);

enum logic [3:0] {s_wait=4'b0001, s_addr = 4'b0010 , s_data = 4'b0100, s_response = 4'b1000} CS_0, NS_0, CS_1, NS_1, CS_write1, NS_write1;

logic [31:0] iaddr, daddr, cpu_iaddr, cpu_daddr, D_daddr;
logic [31:0] inst, ddata, cpu_inst, cpu_ddata;
logic [31:0] datawrite;
logic read_now, write_now, read_now0, write_now0;
logic write_dm, read_dm, cpu_read_dm, cpu_write_dm;
logic stall_im, stall, reading_dm, writing_dm, cpu_stall_im;
logic read_im, write_im, cpu_read_im;
logic [31:0] iaddr_reg;
logic lock_dm;
logic [31:0] bit_enable;
logic allow_read_dm;
logic core_req;
logic I_wait;
logic [31:0] I_addr;
logic [31:0] I_out;
logic d_wait, d_req, d_write;
logic core_wait;
logic inst_stall, data_stall;
logic writing_dm_delay;



	CPU cpu(
		.clk(ACLK), 
		.rst(~ARESETn), 
		.stall(cpu_stall_im),
		.inst(cpu_inst), 
		.ddata(cpu_ddata), 
		.iaddr(cpu_iaddr), 
		.read_im(cpu_read_im),
		.memread(cpu_read_dm),
		.memwrite(cpu_write_dm),
		.daddr(daddr), 
		.datawrite(datawrite),
		.bit_enable(bit_enable),
		.interrupt_dma(interrupt_dma),
 		.interrupt_time(interrupt_time)
	);

	L1C_inst L1C_inst(
  		.clk(ACLK),
  		.rst(~ARESETn),
  		// Core to CPU wrapper
 		.core_addr(cpu_iaddr),
  		.core_req(cpu_read_im),	// im_OE
  		.I_out(inst), //data from CPU wrapper
  		.I_wait(stall_im),
  		.rvalid_m0_i(RVALID_M0),	
  		.core_wait_CD_i(data_stall),
  		// CPU wrapper to core
  		.core_out(cpu_inst),	// im_DO
  		.core_wait(inst_stall),	// ON when L1CI_state is not IDLE
		.BWEB(bit_enable),
  		// CPU wrapper to Mem
  		.I_req(read_im),	// ON when L1CI_state is READ_MISS, like im_OE
  		.I_addr(iaddr) // when L1CI_state is READ_MISS, send to wrapper
	);

	always_comb begin
		core_req = cpu_read_dm | cpu_write_dm;
		//read_dm = d_req & (!d_write);
		d_wait = writing_dm | reading_dm; // | l1c_stall
		cpu_stall_im = inst_stall | data_stall;
		write_dm = d_req && d_write;
		//I_wait = stall_im;
		//I_wait = writing_dm | stall_im | core_wait;
	end
	always_ff@(posedge ACLK)begin
		if(!ARESETn)begin
			writing_dm_delay <= 1'b0;
		end else begin
			writing_dm_delay <= writing_dm;
		end
	end

	L1C_data L1C_data(
  		  .clk(ACLK),
		  .rst(~ARESETn),
		  // Core to CPU wrapper
		  .core_addr(daddr),
		  .core_req(core_req),
		  .core_write(cpu_write_dm),	// DM_wen from CPU
		  .core_in(datawrite),
		  //.core_type({&bit_enable[31:24],&bit_enable[23:16],&bit_enable[15:8],&bit_enable[7:0]}),
		  // Mem to CPU wrapper
		  .D_out(ddata),
		  .D_wait(d_wait), // unused
		  .rvalid_m1_i(RVALID_M1),	
		  .core_wait_CI_i(inst_stall),
		  // CPU wrapper to core
		  .core_out(cpu_ddata), // data to CPU
		  .core_wait(data_stall),
		  // CPU wrapper to Mem
		  .D_req(d_req),
		  //.D_addr(D_addr),
		  .D_write(d_write)
	);
	
	


	always_comb begin
		read_dm = d_req && (!cpu_write_dm);
		allow_read_dm = read_dm && (!lock_dm);
	end
	always_ff@(posedge ACLK )begin
		if(!ARESETn)begin
			
			read_now <= 1'b0;
			write_now <= 1'b0;
			read_now0 <= 1'b0;
			write_now0 <= 1'b0;
			iaddr_reg <= 32'd0;
			inst <= 32'd0;
			ddata <= 32'd0;
		end else begin
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
					if(RVALID_M1 && RREADY_M1)
						ddata <= RDATA_M1;
						//ddata_reg <= RDATA_M1;
				end
				s_response : begin
					if(RVALID_M1 && RREADY_M1)
						ddata <= RDATA_M1;
				end
			endcase
			case(CS_0)
				s_wait : begin
					iaddr_reg <= iaddr;
					read_now0 <= read_im;
					write_now0 <= 1'b0;
				end
				s_data : begin
					if(RVALID_M0 && RREADY_M0)begin // && (!write_dm)
						inst <= RDATA_M0;
					end
					
				end
			endcase
		end
	end
	
	always_ff@(posedge ACLK )begin
		if(!ARESETn)begin
			lock_dm <= 1'b0;
		end else begin
			if(ARVALID_M0 && ARVALID_M1)begin
				lock_dm <= 1'b1;
			end else if (CS_0 == s_data && CS_1 == s_wait)begin
				lock_dm <= 1'b0;
			end else begin
				lock_dm <= lock_dm;
			end 
			
		end
	end		

	always_ff@(posedge ACLK )begin : fsm
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
				if(RVALID_M0 && RREADY_M0 && RLAST_M0 ) NS_0 = s_wait; //&&(!write_dm)
				//else if(RVALID_M0 && RREADY_M0 && RLAST_M0) NS_0 = s_response;
				else NS_0 = s_data;
			end
			s_response : begin
				//if(!writing_dm) NS_0 = s_wait;
				NS_0 = s_response;
			end
			default : begin
				NS_0 = CS_0;
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
				if(!writing_dm) NS_1 = s_wait;
				else NS_1 = s_response;
			end
			default :begin
				NS_1 = CS_1;
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
			default : begin
				NS_write1 = CS_write1;
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
				ARLEN_M0 = 32'd4;
				ARSIZE_M0 = 3'b010;
				ARBURST_M0 = 2'b01;
				// cpu
				stall_im = read_im;
				
			end
			s_addr : begin
				ARID_M0 = 4'd0;
				ARLEN_M0 = 32'd4;
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
				ARLEN_M0 = 32'd0;
				ARSIZE_M0 = 3'b010;
				ARBURST_M0 = 2'b10;
				stall_im = ~(RVALID_M0 && RREADY_M0 && RLAST_M0);
				
				
			end
			s_response : begin
				ARID_M0 = 4'd0;
				ARVALID_M0 = 1'b0;
				ARADDR_M0 = 32'd0;
				RREADY_M0 = 1'b0;
				ARLEN_M0 = 32'd0;
				ARSIZE_M0 = 3'b010;
				ARBURST_M0 = 2'b10;
				stall_im = writing_dm;
			end
			default : begin
				ARID_M0 = 4'd0;
				ARVALID_M0 = 1'b0;
				ARADDR_M0 = 32'd0;
				RREADY_M0 = 1'b0;
				ARLEN_M0 = 32'd0;
				ARSIZE_M0 = 3'b010;
				ARBURST_M0 = 2'b10;
				stall_im = 1'b0;
			end
		endcase
	end
	always_comb begin
		case(CS_1)
			s_wait : begin
				//read
				ARID_M1 = 4'd0;
				ARVALID_M1 = 1'b0;
				RREADY_M1 = 1'b0;
				ARLEN_M1 = 32'd4;
				ARSIZE_M1 = 3'b010;
				ARBURST_M1 = 2'b01;
				reading_dm = allow_read_dm;
				ARVALID_M1 = allow_read_dm;
				if(allow_read_dm)begin
					ARADDR_M1 = {daddr[31:4],4'd0};
				end else begin
					ARADDR_M1 = 32'd0;
				end
			end
			s_addr : begin
				//read
				ARID_M1 = 4'd0;
				ARVALID_M1 = read_now;
				ARADDR_M1 = {daddr[31:4],4'd0};
				RREADY_M1 = 1'b0;
				ARLEN_M1 = 32'd4;
				ARSIZE_M1 = 3'b010;
				ARBURST_M1 = 2'b01;
				reading_dm = 1'b1;
				
			end
			s_data : begin
				ARID_M1 = 4'd0;
				ARVALID_M1 = 1'b0;
				ARADDR_M1 = 32'd0;
				RREADY_M1 = 1'b1;
				ARLEN_M1 = 32'd4;
				ARSIZE_M1 = 3'b010;
				ARBURST_M1 = 2'b01;
				reading_dm = ~(RVALID_M1 && RREADY_M1 && RLAST_M1 && (!write_dm));
			end
			s_response : begin
				ARID_M1 = 4'd0;
				ARVALID_M1 = 1'b0;
				ARADDR_M1 = 32'd0;
				RREADY_M1 = 1'b0;
				ARLEN_M1 = 32'd4;
				ARSIZE_M1 = 3'b010;
				ARBURST_M1 = 2'b01;
				reading_dm = 1'b0;
			end
			default : begin
				ARID_M1 = 4'd0;
				ARVALID_M1 = 1'b0;
				ARADDR_M1 = 32'd0;
				RREADY_M1 = 1'b0;
				ARLEN_M1 = 32'd4;
				ARSIZE_M1 = 3'b010;
				ARBURST_M1 = 2'b01;
				reading_dm = 1'b0;
			end
		endcase
	end 
	always_comb begin
		case(CS_write1)
			s_wait : begin
				//write
				AWVALID_M1 = write_dm;
				AWID_M1 = 4'd0;
				AWADDR_M1 = daddr;
				AWLEN_M1 = 32'd0;
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
				AWLEN_M1 = 32'd0;
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
				AWLEN_M1 = 32'd0;
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
				writing_dm = ~BVALID_M1;
				//write
				AWVALID_M1 = 1'b0;
				AWADDR_M1 = 32'd0;
				AWID_M1 = 4'd0;
				AWLEN_M1 = 32'd0;
				AWSIZE_M1 = 3'b010;
				AWBURST_M1 = 2'b01;
				WDATA_M1 = 32'd0;
				WSTRB_M1 = 4'd0;
				WLAST_M1 = 1'b0;
				WVALID_M1 = 1'b0;
				//response
				BREADY_M1 = 1'b1;
				//writing_dm = 1'b0;
			end
			default : begin
				writing_dm = 1'b0;
				//write
				AWVALID_M1 = 1'b0;
				AWADDR_M1 = 32'd0;
				AWID_M1 = 4'd0;
				AWLEN_M1 = 32'd0;
				AWSIZE_M1 = 3'b010;
				AWBURST_M1 = 2'b01;
				WDATA_M1 = 32'd0;
				WSTRB_M1 = 4'd0;
				WLAST_M1 = 1'b0;
				WVALID_M1 = 1'b0;
				//response
				BREADY_M1 = 1'b0;
			end
		endcase
	end
	always_comb begin
		stall = (stall_im||writing_dm||reading_dm);
		
	end



endmodule
