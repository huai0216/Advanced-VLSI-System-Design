
module DMA_wrapper (
	input ACLK,
	input ARESETn,

	//WRITE ADDRESS1
	output logic [`AXI_ID_BITS-1:0] AWID_dma,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_dma,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_dma,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_dma,
	output logic [1:0] AWBURST_dma,
	output logic AWVALID_dma,
	input AWREADY_dma,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_dma,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_dma,
	output logic WLAST_dma,
	output logic WVALID_dma,
	input WREADY_dma,
	
	//WRITE RESPONSE1
	input [`AXI_ID_BITS-1:0] BID_dma,
	input [1:0] BRESP_dma,
	input BVALID_dma,
	output logic BREADY_dma,

	//READ ADDRESS0
	output logic [`AXI_ID_BITS-1:0] ARID_dma,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_dma,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_dma,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_dma,
	output logic [1:0] ARBURST_dma,
	output logic ARVALID_dma,
	input ARREADY_dma,
	
	//READ DATA0
	input [`AXI_ID_BITS-1:0] RID_dma,
	input [`AXI_DATA_BITS-1:0] RDATA_dma,
	input [1:0] RRESP_dma,
	input RLAST_dma,
	input RVALID_dma,
	output logic RREADY_dma,

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
	//
	output logic DMA_interrupt
);

logic DMAEN;
logic[31:0] DMASRC;
logic[31:0] DMADST;
logic[31:0] DMALEN;
//slave write
logic [31:0] waddr_reg;
logic [`AXI_IDS_BITS-1:0] BID_reg;
logic write_sel;
logic writenow, readnow;
//slave read
logic [`AXI_LEN_BITS-1:0] ARLEN_INCR;
logic [31:0] A, A_reg, A_read;

//write master


enum logic [3:0] {s_wait = 4'b0001, s_address = 4'b0010, s_data = 4'b0100, s_response = 4'b1000} READ_CS, READ_NS, WRITE_CS, WRITE_NS, wmaster_cs, wmaster_ns, rmaster_cs, rmaster_ns;

logic full;
logic [31:0] length_reg;
logic [31:0] data_buffer;
logic [31:0] dmasrc_reg;
logic [31:0] dmadst_reg;
logic read_done;
logic write_done;



	always_ff@(posedge ACLK)begin
		if(!ARESETn)begin
			length_reg <= 32'd0;
			full <= 1'b0;
			data_buffer <= 32'd0;
			dmasrc_reg <= 32'd0;
			DMA_interrupt <= 1'b0;
			read_done <= 1'b0;
			write_done <= 1'b0;
			dmadst_reg <= 32'd0;
		end else begin
			if(!DMAEN)begin
				length_reg <= DMALEN;
				dmasrc_reg <= DMASRC;
				dmadst_reg <= DMADST;
			end else if((full) && WVALID_dma && WREADY_dma) begin
				length_reg <= length_reg - 32'd1;
				dmasrc_reg <= dmasrc_reg + 32'd1;
				dmadst_reg <= dmadst_reg + 32'd1;
			end
			if((!full) && RVALID_dma && RREADY_dma)begin
				full <= ~full;
				data_buffer <= RDATA_dma; 
			end else if(full && WVALID_dma && WREADY_dma)begin
				full <= ~full;
			end
			if(BVALID_dma && BREADY_dma)begin
				DMA_interrupt <= 1'b1;
			end else begin
				DMA_interrupt <= 1'b0;
			end	
			if(RVALID_dma && RREADY_dma && RLAST_dma)begin
				read_done <= 1'b1;
			end else if(!DMAEN)begin
				read_done <= 1'b0;
			end
			if(BVALID_dma && BREADY_dma)begin
				write_done <= 1'b1;
			end else if (!DMAEN)begin
				write_done <= 1'b0;
			end
			
		end
	end

	// Master Read
	always_ff@(posedge ACLK )begin
		if(!ARESETn)begin
			rmaster_cs <= s_wait;
		end else begin
			rmaster_cs <= rmaster_ns;
		end
	end

	always_comb begin
		case(rmaster_cs)
			s_wait : begin
				if(DMAEN && (length_reg != 32'd0) && (!read_done))begin
					rmaster_ns = s_address;
				end else begin
					rmaster_ns = s_wait;
				end
			end
			s_address : begin
				if(ARREADY_dma)begin
					rmaster_ns = s_data;
				end else begin
					rmaster_ns = s_address;
				end
			end
			s_data : begin
				if((!full) && RREADY_dma && RLAST_dma && RVALID_dma) begin
					rmaster_ns = s_wait;
				end else if((!full) && RREADY_dma && RVALID_dma) begin
					rmaster_ns = s_data;
				end else begin
					rmaster_ns = s_data;
				end
			end
			default : begin
				rmaster_ns = rmaster_cs;
			end
		endcase
	end

	always_comb begin
		case(rmaster_cs)
			s_wait : begin
				ARID_dma = 4'd0;
				ARADDR_dma = 32'd0;
				ARLEN_dma = 32'd0;
				ARSIZE_dma = 3'd0;
				ARBURST_dma = 2'd0;
				ARVALID_dma = 1'b0;
				RREADY_dma = 1'b0;
			end
			s_address : begin
				ARID_dma = 4'd0;
				ARADDR_dma = dmasrc_reg;
				ARLEN_dma = length_reg;
				ARSIZE_dma = 3'b011;
				ARBURST_dma = 2'b01;
				ARVALID_dma = 1'b1;
				RREADY_dma = 1'b0;
			end
			s_data : begin
				ARID_dma = 4'd0;
				ARADDR_dma = 32'd0;
				ARLEN_dma = 32'd0;
				ARSIZE_dma = 3'b011;
				ARBURST_dma = 2'b01;
				ARVALID_dma = 1'b0;
				RREADY_dma = (full) ? 1'b0 : 1'b1;
			end
			default : begin
				ARID_dma = 4'd0;
				ARADDR_dma = 32'd0;
				ARLEN_dma = 32'd0;
				ARSIZE_dma = 3'd0;
				ARBURST_dma = 2'd0;
				ARVALID_dma = 1'b0;
				RREADY_dma = 1'b0;
			end
		endcase
	end

	

	// Master Write
	always_ff@(posedge ACLK )begin
		if(!ARESETn)begin
			wmaster_cs <= s_wait;
		end else begin
			wmaster_cs <= wmaster_ns;
		end
	end
	always_comb begin
		case(wmaster_cs)
			s_wait : begin
				if(DMAEN && (length_reg != 32'd0) && (!write_done)) wmaster_ns = s_address;
				else wmaster_ns = s_wait;
			end
			s_address : begin
				if(AWREADY_dma)begin
					wmaster_ns = s_data;
				end else begin
					wmaster_ns = s_address;
				end
			end
			s_data : begin
				if(full && WREADY_dma && WLAST_dma)begin
					wmaster_ns = s_response;
				end else begin
					wmaster_ns = s_data;
				end
			end
			s_response : begin
				if(BVALID_dma)begin
					wmaster_ns = s_wait;
				end else begin
					wmaster_ns = s_response;
				end	
			end
			default : begin
				wmaster_ns = wmaster_cs;
			end
		endcase
	end

	always_comb begin
		case(wmaster_cs)
			s_wait : begin
				AWID_dma = 4'd0;
				AWADDR_dma = 32'd0;
				AWLEN_dma = 32'd0;
				AWSIZE_dma = 3'b011;
				AWBURST_dma = 2'b01;
				AWVALID_dma = 1'b0;
				WDATA_dma = 32'd0;
				WSTRB_dma = 4'd0;
				WLAST_dma = 1'b0;
				WVALID_dma = 1'b0;
				BREADY_dma = 1'b0;
			end
			s_address : begin
				AWID_dma = 4'd0;
				AWADDR_dma = dmadst_reg;
				AWLEN_dma = length_reg;
				AWSIZE_dma = 3'b011;
				AWBURST_dma = 2'b01;
				AWVALID_dma = 1'b1;
				WDATA_dma = 32'd0;
				WSTRB_dma = 4'd0;
				WLAST_dma = 1'b0;
				WVALID_dma = 1'b0;
				BREADY_dma = 1'b0;
			end
			s_data : begin
				AWID_dma = 4'd0;
				AWADDR_dma = 32'd0;
				AWLEN_dma = 32'd0;
				AWSIZE_dma = 3'd0;
				AWBURST_dma = 2'b01;
				AWVALID_dma = 1'b0;
				WDATA_dma = data_buffer;
				WSTRB_dma = 4'hf;
				WLAST_dma = (length_reg == 32'd1);
				WVALID_dma = full;
				BREADY_dma = 1'b0;
			end
			s_response : begin
				AWID_dma = 4'd0;
				AWADDR_dma = 32'd0;
				AWLEN_dma = 32'd0;
				AWSIZE_dma = 3'd0;
				AWBURST_dma = 2'b01;
				AWVALID_dma = 1'b0;
				WDATA_dma = 32'd0;
				WSTRB_dma = 4'd0;
				WLAST_dma = (length_reg == 32'd1);
				WVALID_dma = 1'b0;
				BREADY_dma = 1'b1;
			end
			default : begin
				AWID_dma = 4'd0;
				AWADDR_dma = 32'd0;
				AWLEN_dma = 32'd0;
				AWSIZE_dma = 3'd0;
				AWBURST_dma = 2'b01;
				AWVALID_dma = 1'b0;
				WDATA_dma = 32'd0;
				WSTRB_dma = 4'd0;
				WLAST_dma = 1'b0;
				WVALID_dma = 1'b0;
				BREADY_dma = 1'b0;
			end
		endcase
	end

	// slave
	always_comb begin
		write_sel = (WVALID_S && WREADY_S);
	end
	always_ff@(posedge ACLK )begin : write_fsm
		if(!ARESETn)begin
			WRITE_CS <= s_wait;
		end else begin
			WRITE_CS <= WRITE_NS;
		end
	end
	always_comb begin : write_next_state_logic
		case(WRITE_CS)
			s_wait : begin
				if(AWVALID_S && AWREADY_S) WRITE_NS = s_address;
				else WRITE_NS = s_wait;
			end
			s_address : begin
				if(WLAST_S && WVALID_S && WREADY_S) WRITE_NS = s_data;
				else WRITE_NS = s_address;
			end
			s_data : begin
				if(BVALID_S && BREADY_S) WRITE_NS = s_wait;
				else WRITE_NS = s_data;
			end
			default : WRITE_NS = WRITE_CS;
		endcase
	end
	always_comb begin : write_output_logic
		case(WRITE_CS)
			s_wait : begin
				BVALID_S = 1'b0;
				BRESP_S = 2'b11;
				BID_S = 8'd0;
				WREADY_S = 1'b0;
				AWREADY_S = ~readnow;
				writenow = 1'b0;
			end
			s_address : begin
				BVALID_S = 1'b0;
				BRESP_S = 2'b11;
				BID_S = 8'd0;
				WREADY_S = 1'b1;
				AWREADY_S = 1'b0;
				writenow = 1'b1;
			end
			s_data : begin
				writenow = 1'b1;
				BVALID_S = 1'b1;
				BRESP_S = 2'b00;
				BID_S = BID_reg;
				WREADY_S = 1'b0;
				AWREADY_S = 1'b0;
			end
			default : begin
				writenow = 1'b0;
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
			DMAEN <= 1'd0;
			DMASRC <= 32'd0;
			DMADST <= 32'd0;
			DMALEN <= 32'd0;
		end else begin
			case(WRITE_CS)
				s_wait : begin
					if(AWVALID_S && AWREADY_S) begin
						waddr_reg <= AWADDR_S;
						BID_reg <= AWID_S;
					end
				end
				s_address : begin
					if(WVALID_S)begin
						case(waddr_reg)
							32'h1002_0100 : begin
								DMAEN <= WDATA_S[0];
							end
							32'h1002_0200 : begin
								DMASRC <= WDATA_S;
							end
							32'h1002_0300 : begin
								DMADST <= WDATA_S;
							end
							32'h1002_0400 : begin
								DMALEN <= WDATA_S;
							end
							default : begin
								DMAEN <= 1'b0;
								DMASRC <= 32'd0;
								DMALEN <= 32'd0;
								DMADST <= 32'd0;
							end
						endcase
					end
				end
			endcase
		end
	end

	always_ff@(posedge ACLK)begin : fsm
		if(!ARESETn)begin
			READ_CS <= s_wait;
		end else begin
			READ_CS <= READ_NS;
		end
	end
	always_comb begin : next_state_logic
		case(READ_CS)
			s_wait : begin
				if(ARVALID_S && ARREADY_S) READ_NS = s_address;
				else READ_NS = s_wait;
			end 
			
			s_address : begin
				if(RLAST_S && RREADY_S && RVALID_S) READ_NS = s_wait;
				else READ_NS = s_address;
			end
			
			default : begin
				READ_NS = READ_CS;
			end
		endcase
	end
	always_comb begin : read_output_logic
		case(READ_CS)
			
			s_wait : begin
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
			s_address : begin
				ARREADY_S = 1'b0;
				case(A_reg)
					32'h1002_0100 : begin
						RDATA_S = {31'd0,DMAEN};
					end
					32'h1002_0200 : begin
						RDATA_S = DMASRC;
					end
					32'h1002_0300 : begin
						RDATA_S = DMADST;
					end
					32'h1002_0400 : begin
						RDATA_S = DMALEN;
					end
					default : RDATA_S = 32'd0;
				endcase
				RRESP_S = 2'b00;
				RVALID_S = 1'b1;
				RLAST_S = (ARLEN_INCR == 32'd1);
				readnow = 1'b1;
				A_read = A_reg;
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
	always_ff@(posedge ACLK )begin : read_datapath
		if(!ARESETn)begin
			RID_S <= 8'd0;
			ARLEN_INCR <= 32'd0;
			A_reg <= 32'd0;
		end else begin
			case(READ_CS)
				s_wait : begin 
					if(ARVALID_S && ARREADY_S)begin
						A_reg <= A_read;
					end
					RID_S <= ARID_S;
					ARLEN_INCR <= ARLEN_S ;
				end
				s_address : begin
					if(RREADY_S && RVALID_S) begin
						ARLEN_INCR <= ARLEN_INCR - 32'd1;
					end else begin
						ARLEN_INCR <= ARLEN_INCR;
					end
				end
				
			endcase
		end
	end




endmodule
