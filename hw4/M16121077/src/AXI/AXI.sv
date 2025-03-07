//////////////////////////////////////////////////////////////////////
//          ██╗       ██████╗   ██╗  ██╗    ██████╗            		//
//          ██║       ██╔══█║   ██║  ██║    ██╔══█║            		//
//          ██║       ██████║   ███████║    ██████║            		//
//          ██║       ██╔═══╝   ██╔══██║    ██╔═══╝            		//
//          ███████╗  ██║  	    ██║  ██║    ██║  	           		//
//          ╚══════╝  ╚═╝  	    ╚═╝  ╚═╝    ╚═╝  	           		//
//                                                             		//
// 	2024 Advanced VLSI System Design, advisor: Lih-Yih, Chiou		//
//                                                             		//
//////////////////////////////////////////////////////////////////////
//                                                             		//
// 	Autor: 			TZUNG-JIN, TSAI (Leo)				  	   		//
//	Filename:		 AXI.sv			                            	//
//	Description:	Top module of AXI	 							//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////


module AXI(

	input axi_clk,
	input axi_rstn,


	//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS dma
	input [`AXI_ID_BITS-1:0] AWID_dma,
	input [`AXI_ADDR_BITS-1:0] AWADDR_dma,
	input [`AXI_LEN_BITS-1:0] AWLEN_dma,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_dma,
	input [1:0] AWBURST_dma,
	input AWVALID_dma,
	output logic AWREADY_dma,
	
	//WRITE DATA dma
	input [`AXI_DATA_BITS-1:0] WDATA_dma,
	input [`AXI_STRB_BITS-1:0] WSTRB_dma,
	input WLAST_dma,
	input WVALID_dma,
	output logic WREADY_dma,
	
	//WRITE RESPONSE dma
	output logic [`AXI_ID_BITS-1:0] BID_dma,
	output logic [1:0] BRESP_dma,
	output logic BVALID_dma,
	input BREADY_dma,

	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output logic AWREADY_M1,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic WREADY_M1,
	
	//WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M1,
	output logic [1:0] BRESP_M1,
	output logic BVALID_M1,
	input BREADY_M1,

	//READ ADDRESS dma
	input [`AXI_ID_BITS-1:0] ARID_dma,
	input [`AXI_ADDR_BITS-1:0] ARADDR_dma,
	input [`AXI_LEN_BITS-1:0] ARLEN_dma,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_dma,
	input [1:0] ARBURST_dma,
	input ARVALID_dma,
	output logic ARREADY_dma,
	
	//READ DATA dma
	output logic [`AXI_ID_BITS-1:0] RID_dma,
	output logic [`AXI_DATA_BITS-1:0] RDATA_dma,
	output logic [1:0] RRESP_dma,
	output logic RLAST_dma,
	output logic RVALID_dma,
	input RREADY_dma,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output logic ARREADY_M0,
	
	//READ DATA0
	output logic [`AXI_ID_BITS-1:0] RID_M0,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
	output logic [1:0] RRESP_M0,
	output logic RLAST_M0,
	output logic RVALID_M0,
	input RREADY_M0,
	
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output logic ARREADY_M1,
	
	//READ DATA1
	output logic [`AXI_ID_BITS-1:0] RID_M1,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
	output logic [1:0] RRESP_M1,
	output logic RLAST_M1,
	output logic RVALID_M1,
	input RREADY_M1,

	//MASTER INTERFACE FOR SLAVES
	
	//WRITE ADDRESS  IM
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,
	
	//WRITE DATA IM
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,
	
	//WRITE RESPONSE IM
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1,

	//WRITE ADDRESS  DM
	output logic [`AXI_IDS_BITS-1:0] AWID_S2,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2,
	output logic [1:0] AWBURST_S2,
	output logic AWVALID_S2,
	input AWREADY_S2,
	
	//WRITE DATA DM
	output logic [`AXI_DATA_BITS-1:0] WDATA_S2,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2,
	output logic WLAST_S2,
	output logic WVALID_S2,
	input WREADY_S2,
	
	//WRITE RESPONSE DM
	input [`AXI_IDS_BITS-1:0] BID_S2,
	input [1:0] BRESP_S2,
	input BVALID_S2,
	output logic BREADY_S2,

	//WRITE ADDRESS  DMA
	output logic [`AXI_IDS_BITS-1:0] AWID_S3,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S3,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3,
	output logic [1:0] AWBURST_S3,
	output logic AWVALID_S3,
	input AWREADY_S3,
	
	//WRITE DATA DMA
	output logic [`AXI_DATA_BITS-1:0] WDATA_S3,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3,
	output logic WLAST_S3,
	output logic WVALID_S3,
	input WREADY_S3,
	
	//WRITE RESPONSE DMA
	input [`AXI_IDS_BITS-1:0] BID_S3,
	input [1:0] BRESP_S3,
	input BVALID_S3,
	output logic BREADY_S3,

	//WRITE ADDRESS  WDT
	output logic [`AXI_IDS_BITS-1:0] AWID_S4,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S4,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4,
	output logic [1:0] AWBURST_S4,
	output logic AWVALID_S4,
	input AWREADY_S4,
	
	//WRITE DATA WDT
	output logic [`AXI_DATA_BITS-1:0] WDATA_S4,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4,
	output logic WLAST_S4,
	output logic WVALID_S4,
	input WREADY_S4,
	
	//WRITE RESPONSE WDT
	input [`AXI_IDS_BITS-1:0] BID_S4,
	input [1:0] BRESP_S4,
	input BVALID_S4,
	output logic BREADY_S4,

	//WRITE ADDRESS  DRAM
	output logic [`AXI_IDS_BITS-1:0] AWID_S5,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S5,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5,
	output logic [1:0] AWBURST_S5,
	output logic AWVALID_S5,
	input AWREADY_S5,
	
	//WRITE DATA DRAM
	output logic [`AXI_DATA_BITS-1:0] WDATA_S5,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5,
	output logic WLAST_S5,
	output logic WVALID_S5,
	input WREADY_S5,
	
	//WRITE RESPONSE DRAM
	input [`AXI_IDS_BITS-1:0] BID_S5,
	input [1:0] BRESP_S5,
	input BVALID_S5,
	output logic BREADY_S5,

	
	//READ ADDRESS0 ROM
	output logic [`AXI_IDS_BITS-1:0] ARID_S0,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output logic [1:0] ARBURST_S0,
	output logic ARVALID_S0,
	input ARREADY_S0,
	
	//READ DATA0 ROM
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic RREADY_S0,
	
	//READ ADDRESS IM
	output logic [`AXI_IDS_BITS-1:0] ARID_S1,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output logic [1:0] ARBURST_S1,
	output logic ARVALID_S1,
	input ARREADY_S1,
	
	//READ DATA IM
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic RREADY_S1,

	//READ ADDRESS DM
	output logic [`AXI_IDS_BITS-1:0] ARID_S2,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2,
	output logic [1:0] ARBURST_S2,
	output logic ARVALID_S2,
	input ARREADY_S2,
	
	//READ DATA DM
	input [`AXI_IDS_BITS-1:0] RID_S2,
	input [`AXI_DATA_BITS-1:0] RDATA_S2,
	input [1:0] RRESP_S2,
	input RLAST_S2,
	input RVALID_S2,
	output logic RREADY_S2,

	//READ ADDRESS DMA
	output logic [`AXI_IDS_BITS-1:0] ARID_S3,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S3,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3,
	output logic [1:0] ARBURST_S3,
	output logic ARVALID_S3,
	input ARREADY_S3,
	
	//READ DATA DMA
	input [`AXI_IDS_BITS-1:0] RID_S3,
	input [`AXI_DATA_BITS-1:0] RDATA_S3,
	input [1:0] RRESP_S3,
	input RLAST_S3,
	input RVALID_S3,
	output logic RREADY_S3,

	//READ ADDRESS DRAM
	output logic [`AXI_IDS_BITS-1:0] ARID_S5,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S5,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5,
	output logic [1:0] ARBURST_S5,
	output logic ARVALID_S5,
	input ARREADY_S5,
	
	//READ DATA DRAM
	input [`AXI_IDS_BITS-1:0] RID_S5,
	input [`AXI_DATA_BITS-1:0] RDATA_S5,
	input [1:0] RRESP_S5,
	input RLAST_S5,
	input RVALID_S5,
	output logic RREADY_S5

);
    //---------- you should put your design here ----------//

logic [1:0] pre_rmaster_r, rmaster_sel, rmaster_dat_sel;
logic [1:0] rslave_sel, rslave_dat_sel;
logic wmaster_sel, wmaster_dat_sel;
logic cs, ns, cs_w, ns_w, cs_0, cs_1, ns_0, ns_1;
logic [2:0] wslave_sel, wslave_dat_sel;
logic [`AXI_ID_BITS-1:0] ARID_M0_reg;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M0_reg;
logic [`AXI_LEN_BITS-1:0] ARLEN_M0_reg;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0_reg;
logic [1:0] ARBURST_M0_reg;
logic ARVALID_M0_reg;
logic ARREADY_S0_reg, ARREADY_S1_reg;
logic [`AXI_ID_BITS-1:0] ARID_M1_reg;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M1_reg;
logic [`AXI_LEN_BITS-1:0] ARLEN_M1_reg;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1_reg;
logic [1:0] ARBURST_M1_reg;
logic ARVALID_M1_reg;
logic [15:0] araddr_reg;

//READ ADDRESS bus
logic [`AXI_ID_BITS-1:0] ARID_bus;
logic [`AXI_ADDR_BITS-1:0] ARADDR_bus;
logic [`AXI_LEN_BITS-1:0] ARLEN_bus;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_bus;
logic [1:0] ARBURST_bus;
logic ARVALID_bus;
logic ARREADY_bus;

//READ ADDRESS bus
logic [`AXI_IDS_BITS-1:0] RID_bus;
logic [`AXI_DATA_BITS-1:0] RDATA_bus;
logic [1:0] RRESP_bus;
logic RLAST_bus;
logic RVALID_bus;
logic RREADY_bus;

//WRITE ADDR bus
logic [`AXI_ID_BITS-1:0] AWID_bus;
logic [`AXI_ADDR_BITS-1:0] AWADDR_bus;
logic [`AXI_LEN_BITS-1:0] AWLEN_bus;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_bus;
logic [1:0] AWBURST_bus;
logic AWVALID_bus;
logic AWREADY_bus;

//WRITE DATA bus
logic [`AXI_DATA_BITS-1:0] WDATA_bus;
logic [`AXI_STRB_BITS-1:0] WSTRB_bus;
logic WLAST_bus;
logic WVALID_bus;
logic WREADY_bus;

//WRITE RESPONSE bus
logic [`AXI_IDS_BITS-1:0] BID_bus;
logic [1:0] BRESP_bus;
logic BVALID_bus;
logic BREADY_bus;

logic [15:0] m1addr_reg;




	

	

	always_ff@(posedge axi_clk )begin
		if(!axi_rstn)begin
			cs <= 1'b0;
			cs_w <= 1'b0;
		end else begin
			cs <= ns;
			cs_w <= ns_w;
		end
	end
	always_comb begin
		case(cs)
			1'b0 : begin	
				ns = (ARVALID_bus);
			end
			1'b1 : begin
				ns = ~(RREADY_bus && RVALID_bus && RLAST_bus);		
			end
		endcase
		case(cs_w)
			1'b0 : begin
				ns_w = (AWVALID_bus && AWREADY_bus);
			end 
			1'b1 : begin
				ns_w = ~(BREADY_bus && BVALID_bus);
			end
		endcase
		
	end
	
	always_comb begin : master_select
		case(cs)
			1'b0 : begin
				case({ARVALID_M0, ARVALID_M1, ARVALID_dma})
					3'b110 : rmaster_sel = {1'b0,~pre_rmaster_r[0]};
					3'b100 : rmaster_sel = 2'd0;
					3'b010 : rmaster_sel = 2'd1;
					3'b001 : rmaster_sel = 2'd2;
					default : rmaster_sel = pre_rmaster_r;
				endcase
			end 
			1'b1 : begin
				rmaster_sel = pre_rmaster_r;
			end 
		endcase

		if(AWVALID_M1) wmaster_sel = 1'b0;
		else if(AWVALID_dma) wmaster_sel = 1'b1;
		else wmaster_sel = 1'b0;
	end
	always_comb begin
		case(cs)
			1'b0 : begin			
				if(((rmaster_sel==2'd1) && ARVALID_M1) && (ARADDR_M1[31:16] == 16'h0000 || ARADDR_M1[31:16] == 16'h0001)) begin
					rslave_sel = ARADDR_M1[17:16];
				end else if((rmaster_sel==2'd0) && (ARVALID_M0) && (ARADDR_M0[31:16] == 16'h0000 || ARADDR_M0[31:16] == 16'h0001))begin
					rslave_sel = ARADDR_M0[17:16];
				end else begin
					rslave_sel = 2'd2;
				end
			end
			1'b1 : begin
				if(((rmaster_dat_sel==2'd1) && ARVALID_M1) && (ARADDR_M1[31:16] == 16'h0000 || ARADDR_M1[31:16] == 16'h0001)) begin
					rslave_sel = ARADDR_M1[17:16];
				
				end else if(((rmaster_dat_sel==2'd0) && ARVALID_M0) && (ARADDR_M0[31:16] == 16'h0000 || ARADDR_M0[31:16] == 16'h0001))begin
					rslave_sel = ARADDR_M0[17:16];
				end else begin
					rslave_sel = 2'd2;
				end
				
			end
		endcase
		
		
		
		if(AWVALID_M1) begin
			case(AWADDR_M1[31:16])
				16'h0001 : wslave_sel = 3'd1;
				16'h0002 : wslave_sel = 3'd2;
				16'h1002 : wslave_sel = 3'd3;
				16'h1001 : wslave_sel = 3'd4;
				default : wslave_sel = 3'd5;
			endcase
		end else if(AWVALID_dma)begin
			case(AWADDR_dma[31:16])
				16'h0001 : wslave_sel = 3'd1;
				16'h0002 : wslave_sel = 3'd2;
				16'h1002 : wslave_sel = 3'd3;
				16'h1001 : wslave_sel = 3'd4;
				
				default : wslave_sel = 3'd5;
			endcase
		end else begin
			wslave_sel = 3'd0;
		end
	end

	always_ff@(posedge axi_clk )begin
		if(!axi_rstn)begin
			pre_rmaster_r <= 2'd0;
			rslave_dat_sel <= 2'd0;
			rmaster_dat_sel <= 2'b0;
			wslave_dat_sel <= 3'd0;	
			araddr_reg <= 16'd0;
			m1addr_reg <= 16'd0;
			wmaster_dat_sel <= 1'd0;
		end else begin
			
			case(cs)
				1'b0 :begin
					if(ARVALID_M0 || ARVALID_M1 || ARVALID_dma)begin
						araddr_reg <= ARADDR_bus[31:16];
						rslave_dat_sel <= rslave_sel;
						rmaster_dat_sel <= rmaster_sel;
						pre_rmaster_r <= rmaster_sel;
					end 
					
				end
				1'b1 : begin
					pre_rmaster_r <= rmaster_sel;
				end
			endcase
			
			if(AWVALID_bus && AWREADY_bus) begin
				wmaster_dat_sel <= wmaster_sel;
				wslave_dat_sel <= wslave_sel;
			end
			
			
		end
	end


	always_comb begin : bus_for_master
		case(cs)
			1'b0 : begin
				case(rmaster_sel)
					2'd0 : begin					
						ARID_bus = ARID_M0;
						ARADDR_bus = ARADDR_M0;
						ARLEN_bus = ARLEN_M0;
						ARSIZE_bus = ARSIZE_M0;
						ARBURST_bus = ARBURST_M0;
						ARVALID_bus = ARVALID_M0;
						ARREADY_M0 = ARREADY_bus;
						ARREADY_M1 = 1'b0;
						ARREADY_dma = 1'b0;
					end
					2'd1 : begin
						ARID_bus = ARID_M1;
						ARADDR_bus = ARADDR_M1;
						ARLEN_bus = ARLEN_M1;
						ARSIZE_bus = ARSIZE_M1;
						ARBURST_bus = ARBURST_M1;
						ARVALID_bus = ARVALID_M1;
						ARREADY_M0 = 1'b0;
						ARREADY_M1 = ARREADY_bus;
						ARREADY_dma = 1'b0;
					end
					2'd2 : begin
						ARID_bus = ARID_dma;
						ARADDR_bus = ARADDR_dma;
						ARLEN_bus = ARLEN_dma;
						ARSIZE_bus = ARSIZE_dma;
						ARBURST_bus = ARBURST_dma;
						ARVALID_bus = ARVALID_dma;
						ARREADY_M0 = 1'b0;
						ARREADY_M1 = 1'b0;
						ARREADY_dma = ARREADY_bus;
					end
					default : begin
						ARID_bus = 4'd0;
						ARADDR_bus = 32'd0;
						ARLEN_bus = 32'd0;
						ARSIZE_bus = 3'd0;
						ARBURST_bus = 2'd0;
						ARVALID_bus = 1'b0;
						ARREADY_M0 = 1'b0;
						ARREADY_M1 = 1'b0;
						ARREADY_dma = 1'b0;
					end
				endcase
				
				RDATA_M0 = 32'd0;
				RRESP_M0 = 2'd0;
				RLAST_M0 = 1'b0;
				RVALID_M0 = 1'b0;
				
				RID_M1 = 4'd0;
				RDATA_M1 = 32'd0;
				RRESP_M1 = 2'd0;
				RLAST_M1 = 1'b0;
				RVALID_M1 = 1'b0;

				RREADY_bus = 1'b0;
				RID_dma = 4'd0;
				RID_M0 = 4'd0;

				RDATA_dma = 32'd0;
				RRESP_dma = 2'd0;
				RLAST_dma = 1'b0;
				RVALID_dma = 1'b0;
			end
			1'b1 : begin
				case(rmaster_dat_sel)
					2'd0 : begin					
						ARID_bus =  ARID_M0;
						ARADDR_bus = ARADDR_M0;
						ARLEN_bus = ARLEN_M0;
						ARSIZE_bus = ARSIZE_M0;
						ARBURST_bus = ARBURST_M0;
						ARVALID_bus = ARVALID_M0;
						ARREADY_M0 = ARREADY_bus;
						ARREADY_M1 = 1'b0;
						ARREADY_dma = 1'b0;
						RREADY_bus = RREADY_M0;
						RID_M0 = RID_bus[3:0];
						RDATA_M0 = RDATA_bus;
						RRESP_M0 = RRESP_bus;
						RLAST_M0 = RLAST_bus;
						RVALID_M0 = RVALID_bus;
						RID_M1 = 4'd0;
						RDATA_M1 = 32'd0;
						RRESP_M1 = 2'd0;
						RLAST_M1 = 1'b0;
						RVALID_M1 = 1'b0;
						RID_dma = 4'd0;
						RDATA_dma = 32'd0;
						RRESP_dma = 2'd0;
						RLAST_dma = 1'b0;
						RVALID_dma = 1'b0;
					end
					2'd1 : begin
						ARID_bus =  ARID_M1;
						ARADDR_bus = ARADDR_M1;
						ARLEN_bus = ARLEN_M1;
						ARSIZE_bus = ARSIZE_M1;
						ARBURST_bus = ARBURST_M1;
						ARVALID_bus = ARVALID_M1;
						ARREADY_M0 = 1'b0;
						ARREADY_M1 = ARREADY_bus;
						ARREADY_dma = 1'b0;
						RREADY_bus = RREADY_M1;
						RID_M1 = RID_bus[3:0];
						RDATA_M1 = RDATA_bus;
						RRESP_M1 = RRESP_bus;
						RLAST_M1 = RLAST_bus;
						RVALID_M1 = RVALID_bus;
						RID_M0 = 4'd0;
						RDATA_M0 = 32'd0;
						RRESP_M0 = 2'd0;
						RLAST_M0 = 1'b0;
						RVALID_M0 = 1'b0;
						RID_dma = 4'd0;
						RDATA_dma = 32'd0;
						RRESP_dma = 2'd0;
						RLAST_dma = 1'b0;
						RVALID_dma = 1'b0;
					end
					2'd2 : begin
						ARID_bus = ARID_dma;
						ARADDR_bus = ARADDR_dma;
						ARLEN_bus = ARLEN_dma;
						ARSIZE_bus = ARSIZE_dma;
						ARBURST_bus = ARBURST_dma;
						ARVALID_bus = ARVALID_dma;
						ARREADY_M0 = 1'b0;
						ARREADY_M1 = 1'b0;
						ARREADY_dma = ARREADY_bus;
						RREADY_bus = RREADY_dma;	
						RID_dma = RID_bus[3:0];
						RDATA_dma = RDATA_bus;
						RRESP_dma = RRESP_bus;
						RLAST_dma = RLAST_bus;
						RVALID_dma = RVALID_bus;
						RID_M0 = 4'd0;
						RDATA_M0 = 32'd0;
						RRESP_M0 = 2'd0;
						RLAST_M0 = 1'b0;
						RVALID_M0 = 1'b0;
						RID_M1 = 4'd0;
						RDATA_M1 = 32'd0;
						RRESP_M1 = 2'd0;
						RLAST_M1 = 1'b0;
						RVALID_M1 = 1'b0;
						
					end
					default : begin
						ARID_bus = 4'd0;
						ARADDR_bus = 32'd0;
						ARLEN_bus = 32'd0;
						ARSIZE_bus = 3'd0;
						ARBURST_bus = 2'd0;
						ARVALID_bus = 1'b0;
						ARREADY_M0 = 1'b0;
						ARREADY_M1 = 1'b0;
						ARREADY_dma = 1'b0;
						RREADY_bus = 1'b0;
						RID_M0 = 4'd0;
						RDATA_M0 = 32'd0;
						RRESP_M0 = 2'd0;
						RLAST_M0 = 1'b0;
						RVALID_M0 = 1'b0;
						RID_M1 = 4'd0;
						RDATA_M1 = 32'd0;
						RRESP_M1 = 2'd0;
						RLAST_M1 = 1'b0;
						RVALID_M1 = 1'b0;
						RID_dma = 4'd0;
						RDATA_dma = 32'd0;
						RRESP_dma = 2'd0;
						RLAST_dma = 1'b0;
						RVALID_dma = 1'b0;
					end
				endcase
				
				
			end
		endcase 
	end
	always_comb begin
		case(cs)
			1'b0 : begin
				case(ARADDR_bus[31:16])
					16'h0000 : begin
						ARREADY_bus = ARREADY_S0;
						ARID_S0 = {4'd0, ARID_bus};
						ARADDR_S0 = ARADDR_bus;
						ARLEN_S0 = ARLEN_bus;
						ARSIZE_S0 = ARSIZE_bus;
						ARBURST_S0 = ARBURST_bus;
						ARVALID_S0 = ARVALID_bus;							

						ARID_S1 = 8'd0;
						ARADDR_S1 = 32'd0;
						ARLEN_S1 = 32'd0;
						ARSIZE_S1 = 3'd0;
						ARBURST_S1 = 2'd0;
						ARVALID_S1 = 1'b0;

						ARID_S2 = 8'd0;
						ARADDR_S2 = 32'd0;
						ARLEN_S2 = 32'd0;
						ARSIZE_S2 = 3'd0;
						ARBURST_S2 = 2'd0;
						ARVALID_S2 = 1'b0;

						ARID_S3 = 8'd0;
						ARADDR_S3 = 32'd0;
						ARLEN_S3 = 32'd0;
						ARSIZE_S3 = 3'd0;
						ARBURST_S3 = 2'd0;
						ARVALID_S3 = 1'b0;
						
						ARID_S5 = 8'd0;
						ARADDR_S5 = 32'd0;
						ARLEN_S5 = 32'd0;
						ARSIZE_S5 = 3'd0;
						ARBURST_S5 = 2'd0;
						ARVALID_S5 = 1'b0;
					end
					16'h0001 : begin
						ARREADY_bus = ARREADY_S1;
						ARID_S0 = 8'd0;
						ARADDR_S0 = 32'd0;
						ARLEN_S0 = 32'd0;
						ARSIZE_S0 = 3'd0;
						ARBURST_S0 = 2'd0;
						ARVALID_S0 = 1'b0;

						ARID_S1 = {4'd0, ARID_bus};
						ARADDR_S1 = ARADDR_bus;
						ARLEN_S1 = ARLEN_bus;
						ARSIZE_S1 = ARSIZE_bus;
						ARBURST_S1 = ARBURST_bus;
						ARVALID_S1 = ARVALID_bus;

						ARID_S2 = 8'd0;
						ARADDR_S2 = 32'd0;
						ARLEN_S2 = 32'd0;
						ARSIZE_S2 = 3'd0;
						ARBURST_S2 = 2'd0;
						ARVALID_S2 = 1'b0;

						ARID_S3 = 8'd0;
						ARADDR_S3 = 32'd0;
						ARLEN_S3 = 32'd0;
						ARSIZE_S3 = 3'd0;
						ARBURST_S3 = 2'd0;
						ARVALID_S3 = 1'b0;
						
						ARID_S5 = 8'd0;
						ARADDR_S5 = 32'd0;
						ARLEN_S5 = 32'd0;
						ARSIZE_S5 = 3'd0;
						ARBURST_S5 = 2'd0;
						ARVALID_S5 = 1'b0;
					end
					16'h0002 : begin // slave 2 DM
						ARREADY_bus = ARREADY_S2;
						ARID_S2 = {4'd0, ARID_bus};
						ARADDR_S2 = ARADDR_bus;
						ARLEN_S2 = ARLEN_bus;
						ARSIZE_S2 = ARSIZE_bus;
						ARBURST_S2 = ARBURST_bus;
						ARVALID_S2 = ARVALID_bus;

						ARID_S0 = 8'd0;
						ARADDR_S0 = 32'd0;
						ARLEN_S0 = 32'd0;
						ARSIZE_S0 = 3'd0;
						ARBURST_S0 = 2'd0;
						ARVALID_S0 = 1'b0;

						ARID_S1 = 8'd0;
						ARADDR_S1 = 32'd0;
						ARLEN_S1 = 32'd0;
						ARSIZE_S1 = 3'd0;
						ARBURST_S1 = 2'd0;
						ARVALID_S1 = 1'b0;

						ARID_S3 = 8'd0;
						ARADDR_S3 = 32'd0;
						ARLEN_S3 = 32'd0;
						ARSIZE_S3 = 3'd0;
						ARBURST_S3 = 2'd0;
						ARVALID_S3 = 1'b0;
						
						ARID_S5 = 8'd0;
						ARADDR_S5 = 32'd0;
						ARLEN_S5 = 32'd0;
						ARSIZE_S5 = 3'd0;
						ARBURST_S5 = 2'd0;
						ARVALID_S5 = 1'b0;
					end
					16'h1002 : begin // slave 3 DMA
						ARREADY_bus = ARREADY_S3;
						ARID_S3 = {4'd0, ARID_bus};
						ARADDR_S3 = ARADDR_bus;
						ARLEN_S3 = ARLEN_bus;
						ARSIZE_S3 = ARSIZE_bus;
						ARBURST_S3 = ARBURST_bus;
						ARVALID_S3 = ARVALID_bus;
		
						ARID_S0 = 8'd0;
						ARADDR_S0 = 32'd0;
						ARLEN_S0 = 32'd0;
						ARSIZE_S0 = 3'd0;
						ARBURST_S0 = 2'd0;
						ARVALID_S0 = 1'b0;

						ARID_S1 = 8'd0;
						ARADDR_S1 = 32'd0;
						ARLEN_S1 = 32'd0;
						ARSIZE_S1 = 3'd0;
						ARBURST_S1 = 2'd0;
						ARVALID_S1 = 1'b0;

						ARID_S2 = 8'd0;
						ARADDR_S2 = 32'd0;
						ARLEN_S2 = 32'd0;
						ARSIZE_S2 = 3'd0;
						ARBURST_S2 = 2'd0;
						ARVALID_S2 = 1'b0;
						
						ARID_S5 = 8'd0;
						ARADDR_S5 = 32'd0;
						ARLEN_S5 = 32'd0;
						ARSIZE_S5 = 3'd0;
						ARBURST_S5 = 2'd0;
						ARVALID_S5 = 1'b0;
					end
					
					default : begin // slave 5 DRAM
						ARREADY_bus = ARREADY_S5;
						ARID_S5 = {4'd0, ARID_bus};
						ARADDR_S5 = ARADDR_bus;
						ARLEN_S5 = ARLEN_bus;
						ARSIZE_S5 = ARSIZE_bus;
						ARBURST_S5 = ARBURST_bus;
						ARVALID_S5 = ARVALID_bus;

						ARID_S0 = 8'd0;
						ARADDR_S0 = 32'd0;
						ARLEN_S0 = 32'd0;
						ARSIZE_S0 = 3'd0;
						ARBURST_S0 = 2'd0;
						ARVALID_S0 = 1'b0;

						ARID_S1 = 8'd0;
						ARADDR_S1 = 32'd0;
						ARLEN_S1 = 32'd0;
						ARSIZE_S1 = 3'd0;
						ARBURST_S1 = 2'd0;
						ARVALID_S1 = 1'b0;

						ARID_S2 = 8'd0;
						ARADDR_S2 = 32'd0;
						ARLEN_S2 = 32'd0;
						ARSIZE_S2 = 3'd0;
						ARBURST_S2 = 2'd0;
						ARVALID_S2 = 1'b0;
						
						ARID_S3 = 8'd0;
						ARADDR_S3 = 32'd0;
						ARLEN_S3 = 32'd0;
						ARSIZE_S3 = 3'd0;
						ARBURST_S3 = 2'd0;
						ARVALID_S3 = 1'b0;
												
					end
					
					
				endcase
				RVALID_bus = 1'b0;
				RLAST_bus = 1'b0;
				RRESP_bus = 2'd0;
				RDATA_bus = 32'd0;
				RID_bus = 8'd0;
				RREADY_S0 = 1'b0;
				RREADY_S1 = 1'b0;
				RREADY_S2 = 1'b0;
				RREADY_S3 = 1'b0;
				RREADY_S5 = 1'b0;
			end
			1'b1 : begin
				case(araddr_reg)
					16'h0000 : begin
						ARREADY_bus = ARREADY_S0;
						ARID_S0 = {4'd0, ARID_bus};
						ARADDR_S0 = ARADDR_bus;
						ARLEN_S0 = ARLEN_bus;
						ARSIZE_S0 = ARSIZE_bus;
						ARBURST_S0 = ARBURST_bus;
						ARVALID_S0 = ARVALID_bus;							

						ARID_S1 = 8'd0;
						ARADDR_S1 = 32'd0;
						ARLEN_S1 = 32'd0;
						ARSIZE_S1 = 3'd0;
						ARBURST_S1 = 2'd0;
						ARVALID_S1 = 1'b0;

						ARID_S2 = 8'd0;
						ARADDR_S2 = 32'd0;
						ARLEN_S2 = 32'd0;
						ARSIZE_S2 = 3'd0;
						ARBURST_S2 = 2'd0;
						ARVALID_S2 = 1'b0;

						ARID_S3 = 8'd0;
						ARADDR_S3 = 32'd0;
						ARLEN_S3 = 32'd0;
						ARSIZE_S3 = 3'd0;
						ARBURST_S3 = 2'd0;
						ARVALID_S3 = 1'b0;

						ARID_S5 = 8'd0;
						ARADDR_S5 = 32'd0;
						ARLEN_S5 = 32'd0;
						ARSIZE_S5 = 3'd0;
						ARBURST_S5 = 2'd0;
						ARVALID_S5 = 1'b0;
						
						RREADY_S0 = RREADY_bus;
						RREADY_S1 = 1'b0;
						RREADY_S2 = 1'b0;
						RREADY_S3 = 1'b0;
						RREADY_S5 = 1'b0;
						RID_bus = RID_S0;
						RDATA_bus = RDATA_S0;
						RRESP_bus = RRESP_S0;
						RLAST_bus = RLAST_S0;
						RVALID_bus = RVALID_S0;
						
					end
					16'h0001 : begin
						ARREADY_bus = ARREADY_S1;
						ARID_S0 = 8'd0;
						ARADDR_S0 = 32'd0;
						ARLEN_S0 = 32'd0;
						ARSIZE_S0 = 3'd0;
						ARBURST_S0 = 2'd0;
						ARVALID_S0 = 1'b0;

						ARID_S1 =  {4'd0, ARID_bus};
						ARADDR_S1 = ARADDR_bus;
						ARLEN_S1 = ARLEN_bus;
						ARSIZE_S1 = ARSIZE_bus;
						ARBURST_S1 = ARBURST_bus;
						ARVALID_S1 = ARVALID_bus;

						ARID_S2 = 8'd0;
						ARADDR_S2 = 32'd0;
						ARLEN_S2 = 32'd0;
						ARSIZE_S2 = 3'd0;
						ARBURST_S2 = 2'd0;
						ARVALID_S2 = 1'b0;

						ARID_S3 = 8'd0;
						ARADDR_S3 = 32'd0;
						ARLEN_S3 = 32'd0;
						ARSIZE_S3 = 3'd0;
						ARBURST_S3 = 2'd0;
						ARVALID_S3 = 1'b0;
						ARID_S5 = 8'd0;
						ARADDR_S5 = 32'd0;
						ARLEN_S5 = 32'd0;
						ARSIZE_S5 = 3'd0;
						ARBURST_S5 = 2'd0;
						ARVALID_S5 = 1'b0;

						RREADY_S0 = 1'b0;
						RREADY_S1 = RREADY_bus;
						RREADY_S2 = 1'b0;
						RREADY_S3 = 1'b0;
						RREADY_S5 = 1'b0;
						RID_bus = RID_S1;
						RDATA_bus = RDATA_S1;
						RRESP_bus = RRESP_S1;
						RLAST_bus = RLAST_S1;
						RVALID_bus = RVALID_S1;
					end
					16'h0002 : begin // slave 2 DM
						ARREADY_bus = ARREADY_S2;
						ARID_S2 =  {4'd0, ARID_bus};
						ARADDR_S2 = ARADDR_bus;
						ARLEN_S2 = ARLEN_bus;
						ARSIZE_S2 = ARSIZE_bus;
						ARBURST_S2 = ARBURST_bus;
						ARVALID_S2 = ARVALID_bus;

						ARID_S0 = 8'd0;
						ARADDR_S0 = 32'd0;
						ARLEN_S0 = 32'd0;
						ARSIZE_S0 = 3'd0;
						ARBURST_S0 = 2'd0;
						ARVALID_S0 = 1'b0;

						ARID_S1 = 8'd0;
						ARADDR_S1 = 32'd0;
						ARLEN_S1 = 32'd0;
						ARSIZE_S1 = 3'd0;
						ARBURST_S1 = 2'd0;
						ARVALID_S1 = 1'b0;

						ARID_S3 = 8'd0;
						ARADDR_S3 = 32'd0;
						ARLEN_S3 = 32'd0;
						ARSIZE_S3 = 3'd0;
						ARBURST_S3 = 2'd0;
						ARVALID_S3 = 1'b0;
						ARID_S5 = 8'd0;
						ARADDR_S5 = 32'd0;
						ARLEN_S5 = 32'd0;
						ARSIZE_S5 = 3'd0;
						ARBURST_S5 = 2'd0;
						ARVALID_S5 = 1'b0;

						RREADY_S0 = 1'b0;
						RREADY_S1 = 1'b0;
						RREADY_S2 = RREADY_bus;
						RREADY_S3 = 1'b0;
						//RREADY_S4 = 1'b0;
						RREADY_S5 = 1'b0;
						RID_bus = RID_S2;
						RDATA_bus = RDATA_S2;
						RRESP_bus = RRESP_S2;
						RLAST_bus = RLAST_S2;
						RVALID_bus = RVALID_S2;
					end
					16'h1002 : begin // slave 3 DMA
						ARREADY_bus = ARREADY_S3;
						ARID_S3 =  {4'd0, ARID_bus};
						ARADDR_S3 = ARADDR_bus;
						ARLEN_S3 = ARLEN_bus;
						ARSIZE_S3 = ARSIZE_bus;
						ARBURST_S3 = ARBURST_bus;
						ARVALID_S3 = ARVALID_bus;
		
						ARID_S0 = 8'd0;
						ARADDR_S0 = 32'd0;
						ARLEN_S0 = 32'd0;
						ARSIZE_S0 = 3'd0;
						ARBURST_S0 = 2'd0;
						ARVALID_S0 = 1'b0;

						ARID_S1 = 8'd0;
						ARADDR_S1 = 32'd0;
						ARLEN_S1 = 32'd0;
						ARSIZE_S1 = 3'd0;
						ARBURST_S1 = 2'd0;
						ARVALID_S1 = 1'b0;

						ARID_S2 = 8'd0;
						ARADDR_S2 = 32'd0;
						ARLEN_S2 = 32'd0;
						ARSIZE_S2 = 3'd0;
						ARBURST_S2 = 2'd0;
						ARVALID_S2 = 1'b0;
						ARID_S5 = 8'd0;
						ARADDR_S5 = 32'd0;
						ARLEN_S5 = 32'd0;
						ARSIZE_S5 = 3'd0;
						ARBURST_S5 = 2'd0;
						ARVALID_S5 = 1'b0;

						RREADY_S0 = 1'b0;
						RREADY_S1 = 1'b0;
						RREADY_S2 = 1'b0;
						RREADY_S3 = RREADY_bus;
						//RREADY_S4 = 1'b0;
						RREADY_S5 = 1'b0;
						RID_bus = RID_S3;
						RDATA_bus = RDATA_S3;
						RRESP_bus = RRESP_S3;
						RLAST_bus = RLAST_S3;
						RVALID_bus = RVALID_S3;
					end
					
					default : begin // slave 5 DRAM
						ARREADY_bus = ARREADY_S5;
						ARID_S5 =  {4'd0, ARID_bus};
						ARADDR_S5 = ARADDR_bus;
						ARLEN_S5 = ARLEN_bus;
						ARSIZE_S5 = ARSIZE_bus;
						ARBURST_S5 = ARBURST_bus;
						ARVALID_S5 = ARVALID_bus;

						ARID_S0 = 8'd0;
						ARADDR_S0 = 32'd0;
						ARLEN_S0 = 32'd0;
						ARSIZE_S0 = 3'd0;
						ARBURST_S0 = 2'd0;
						ARVALID_S0 = 1'b0;

						ARID_S1 = 8'd0;
						ARADDR_S1 = 32'd0;
						ARLEN_S1 = 32'd0;
						ARSIZE_S1 = 3'd0;
						ARBURST_S1 = 2'd0;
						ARVALID_S1 = 1'b0;

						ARID_S2 = 8'd0;
						ARADDR_S2 = 32'd0;
						ARLEN_S2 = 32'd0;
						ARSIZE_S2 = 3'd0;
						ARBURST_S2 = 2'd0;
						ARVALID_S2 = 1'b0;
						
						ARID_S3 = 8'd0;
						ARADDR_S3 = 32'd0;
						ARLEN_S3 = 32'd0;
						ARSIZE_S3 = 3'd0;
						ARBURST_S3 = 2'd0;
						ARVALID_S3 = 1'b0; 

						RREADY_S0 = 1'b0;
						RREADY_S1 = 1'b0;
						RREADY_S2 = 1'b0;
						RREADY_S3 = 1'b0;
						
						RREADY_S5 = RREADY_bus;
						RID_bus = RID_S5;
						RDATA_bus = RDATA_S5;
						RRESP_bus = RRESP_S5;
						RLAST_bus = RLAST_S5;
						RVALID_bus = RVALID_S5;
					end
					
				endcase
			end
		endcase
	end

	always_comb begin
		case(cs_w)
			1'b0 : begin
				case(wmaster_sel)
					1'b0 : begin
						AWID_bus = AWID_M1;
						AWADDR_bus = AWADDR_M1;
						AWLEN_bus = AWLEN_M1;
						AWSIZE_bus = AWSIZE_M1;
						AWBURST_bus = AWBURST_M1;
						AWVALID_bus = AWVALID_M1;
						AWREADY_M1 = AWREADY_bus;
						AWREADY_dma = 1'b0;
					end
					1'b1 : begin
						AWID_bus = AWID_dma;
						AWADDR_bus = AWADDR_dma;
						AWLEN_bus = AWLEN_dma;
						AWSIZE_bus = AWSIZE_dma;
						AWBURST_bus = AWBURST_dma;
						AWVALID_bus = AWVALID_dma;
						AWREADY_M1 = 1'b0;
						AWREADY_dma = AWREADY_bus;
					end
				endcase
				if(AWVALID_bus && AWREADY_bus)begin
					if(wmaster_sel)begin
						WREADY_M1 = 1'b0;
						WREADY_dma = WREADY_bus;
						WDATA_bus = WDATA_dma;
						WLAST_bus = WLAST_dma;
						WVALID_bus = WVALID_dma;
						WSTRB_bus = WSTRB_dma;
					end else begin
						WREADY_M1 = WREADY_bus;
						WREADY_dma = 1'b0;
						WDATA_bus = WDATA_M1;
						WLAST_bus = WLAST_M1;
						WVALID_bus = WVALID_M1;
						WSTRB_bus = WSTRB_M1;
					end
				end else begin
					WREADY_M1 = 1'b0;
					WREADY_dma = 1'b0;
					WDATA_bus = 32'd0;
					WLAST_bus = 1'b0;
					WVALID_bus = 1'b0;
					WSTRB_bus = 4'd0;
				end

				BID_M1 = 4'd0;
				BRESP_M1 = 2'd0;
				BVALID_M1 = 1'b0;

				BID_dma = 4'd0;
				BRESP_dma = 2'd0;
				BVALID_dma = 1'b0;
				BREADY_bus = 1'b0;
			end
			1'b1 : begin
				case(wmaster_dat_sel)
					1'b0 : begin
						AWID_bus =  AWID_M1;
						AWADDR_bus = AWADDR_M1;
						AWLEN_bus = AWLEN_M1;
						AWSIZE_bus = AWSIZE_M1;
						AWBURST_bus = AWBURST_M1;
						AWVALID_bus = AWVALID_M1;

						AWREADY_M1 = AWREADY_bus;
						AWREADY_dma = 1'b0;

						WREADY_M1 = WREADY_bus;
						WREADY_dma = 1'b0;
						WDATA_bus = WDATA_M1;
						WLAST_bus = WLAST_M1;
						WVALID_bus = WVALID_M1;
						WSTRB_bus = WSTRB_M1;
						
						BID_M1 = BID_bus[3:0];
						BRESP_M1 = BRESP_bus;
						BVALID_M1 = BVALID_bus;

						BID_dma = 4'd0;
						BRESP_dma = 2'd0;
						BVALID_dma = 1'b0;
						BREADY_bus = BREADY_M1;
					end
					1'b1 : begin
						AWID_bus = AWID_dma;
						AWADDR_bus = AWADDR_dma;
						AWLEN_bus = AWLEN_dma;
						AWSIZE_bus = AWSIZE_dma;
						AWBURST_bus = AWBURST_dma;
						AWVALID_bus = AWVALID_dma;

						AWREADY_M1 = 1'b0;
						AWREADY_dma = AWREADY_bus;

						WREADY_M1 = 1'b0;
						WREADY_dma = WREADY_bus;
						WDATA_bus = WDATA_dma;
						WLAST_bus = WLAST_dma;
						WVALID_bus = WVALID_dma;
						WSTRB_bus = WSTRB_dma;

						BID_M1 = 4'd0;
						BRESP_M1 = 2'd0;
						BVALID_M1 = 1'b0;

						BID_dma = BID_bus[3:0];
						BRESP_dma = BRESP_bus;
						BVALID_dma = BVALID_bus;
						BREADY_bus = BREADY_dma;
					end
				endcase
			end
		endcase
	end
	always_comb begin
		case(cs_w)
			1'b0 : begin
				BREADY_S5 = 1'b0;
				BREADY_S1 = 1'b0;
				BREADY_S2 = 1'b0;
				BREADY_S3 = 1'b0;
				BREADY_S4 = 1'b0;
				BVALID_bus = 1'b0;
				BID_bus = 8'd0;
				BRESP_bus = 2'd0;
				case(AWADDR_bus[31:16])
					16'h0001 : begin
						AWREADY_bus = AWREADY_S1;
						AWID_S1 =  {4'd0, AWID_bus};
						AWADDR_S1 = AWADDR_bus;
						AWLEN_S1 = AWLEN_bus;
						AWSIZE_S1 = AWSIZE_bus;
						AWBURST_S1 = AWBURST_bus;
						AWVALID_S1 = AWVALID_bus;
						
						AWID_S2 = 8'd0;
						AWADDR_S2 = 32'd0;
						AWLEN_S2 = 32'd0;
						AWSIZE_S2 = 3'd0;
						AWBURST_S2 = 2'd0;
						AWVALID_S2 = 1'b0;

						AWID_S3 = 8'd0;
						AWADDR_S3 = 32'd0;
						AWLEN_S3 = 32'd0;
						AWSIZE_S3 = 3'd0;
						AWBURST_S3 = 2'd0;
						AWVALID_S3 = 1'b0;
						
						AWID_S4 = 8'd0;
						AWADDR_S4 = 32'd0;
						AWLEN_S4 = 32'd0;
						AWSIZE_S4 = 3'd0;
						AWBURST_S4 = 2'd0;
						AWVALID_S4 = 1'b0;

						AWID_S5 = 8'd0;
						AWADDR_S5 = 32'd0;
						AWLEN_S5 = 32'd0;
						AWSIZE_S5 = 3'd0;
						AWBURST_S5 = 2'd0;
						AWVALID_S5 = 1'b0;
					end
					16'h0002 : begin // slave 2 DM
						AWREADY_bus = AWREADY_S2;
						AWID_S1 = 8'd0;
						AWADDR_S1 = 32'd0;
						AWLEN_S1 = 32'd0;
						AWSIZE_S1 = 3'd0;
						AWBURST_S1 = 2'd0;
						AWVALID_S1 = 1'b0;
	
						AWID_S2 =  {4'd0, AWID_bus};
						AWADDR_S2 = AWADDR_bus;
						AWLEN_S2 = AWLEN_bus;
						AWSIZE_S2 = AWSIZE_bus;
						AWBURST_S2 = AWBURST_bus;
						AWVALID_S2 = AWVALID_bus;

						AWID_S3 = 8'd0;
						AWADDR_S3 = 32'd0;
						AWLEN_S3 = 32'd0;
						AWSIZE_S3 = 3'd0;
						AWBURST_S3 = 2'd0;
						AWVALID_S3 = 1'b0;
						
						AWID_S4 = 8'd0;
						AWADDR_S4 = 32'd0;
						AWLEN_S4 = 32'd0;
						AWSIZE_S4 = 3'd0;
						AWBURST_S4 = 2'd0;
						AWVALID_S4 = 1'b0;

						AWID_S5 = 8'd0;
						AWADDR_S5 = 32'd0;
						AWLEN_S5 = 32'd0;
						AWSIZE_S5 = 3'd0;
						AWBURST_S5 = 2'd0;
						AWVALID_S5 = 1'b0;
					end
					16'h1002 : begin  // slave 3 DMA
						AWREADY_bus = AWREADY_S3;
						AWID_S1 = 8'd0;
						AWADDR_S1 = 32'd0;
						AWLEN_S1 = 32'd0;
						AWSIZE_S1 = 3'd0;
						AWBURST_S1 = 2'd0;
						AWVALID_S1 = 1'b0;
	
						AWID_S2 = 8'd0;
						AWADDR_S2 = 32'd0;
						AWLEN_S2 = 32'd0;
						AWSIZE_S2 = 3'd0;
						AWBURST_S2 = 2'd0;
						AWVALID_S2 = 1'b0;

						AWID_S3 = {4'd0, AWID_bus};
						AWADDR_S3 = AWADDR_bus;
						AWLEN_S3 = AWLEN_bus;
						AWSIZE_S3 = AWSIZE_bus;
						AWBURST_S3 = AWBURST_bus;
						AWVALID_S3 = AWVALID_bus;
						
						AWID_S4 = 8'd0;
						AWADDR_S4 = 32'd0;
						AWLEN_S4 = 32'd0;
						AWSIZE_S4 = 3'd0;
						AWBURST_S4 = 2'd0;
						AWVALID_S4 = 1'b0;

						AWID_S5 = 8'd0;
						AWADDR_S5 = 32'd0;
						AWLEN_S5 = 32'd0;
						AWSIZE_S5 = 3'd0;
						AWBURST_S5 = 2'd0;
						AWVALID_S5 = 1'b0;
					end
					16'h1001 : begin //slave 4 WDT
						AWREADY_bus = AWREADY_S4;
						AWID_S1 = 8'd0;
						AWADDR_S1 = 32'd0;
						AWLEN_S1 = 32'd0;
						AWSIZE_S1 = 3'd0;
						AWBURST_S1 = 2'd0;
						AWVALID_S1 = 1'b0;
	
						AWID_S2 = 8'd0;
						AWADDR_S2 = 32'd0;
						AWLEN_S2 = 32'd0;
						AWSIZE_S2 = 3'd0;
						AWBURST_S2 = 2'd0;
						AWVALID_S2 = 1'b0;

						AWID_S3 = 8'd0;
						AWADDR_S3 = 32'd0;
						AWLEN_S3 = 32'd0;
						AWSIZE_S3 = 3'd0;
						AWBURST_S3 = 2'd0;
						AWVALID_S3 = 1'b0;
						
						AWID_S4 =  {4'd0, AWID_bus};
						AWADDR_S4 = AWADDR_bus;
						AWLEN_S4 = AWLEN_bus;
						AWSIZE_S4 = AWSIZE_bus;
						AWBURST_S4 = AWBURST_bus;
						AWVALID_S4 = AWVALID_bus;

						AWID_S5 = 8'd0;
						AWADDR_S5 = 32'd0;
						AWLEN_S5 = 32'd0;
						AWSIZE_S5 = 3'd0;
						AWBURST_S5 = 2'd0;
						AWVALID_S5 = 1'b0;
					end
					default : begin // slave 5 DRAM
						AWREADY_bus = AWREADY_S5;
						AWID_S1 = 8'd0;
						AWADDR_S1 = 32'd0;
						AWLEN_S1 = 32'd0;
						AWSIZE_S1 = 3'd0;
						AWBURST_S1 = 2'd0;
						AWVALID_S1 = 1'b0;
	
						AWID_S2 = 8'd0;
						AWADDR_S2 = 32'd0;
						AWLEN_S2 = 32'd0;
						AWSIZE_S2 = 3'd0;
						AWBURST_S2 = 2'd0;
						AWVALID_S2 = 1'b0;

						AWID_S3 = 8'd0;
						AWADDR_S3 = 32'd0;
						AWLEN_S3 = 32'd0;
						AWSIZE_S3 = 3'd0;
						AWBURST_S3 = 2'd0;
						AWVALID_S3 = 1'b0;
						
						AWID_S4 = 8'd0;
						AWADDR_S4 = 32'd0;
						AWLEN_S4 = 32'd0;
						AWSIZE_S4 = 3'd0;
						AWBURST_S4 = 2'd0;
						AWVALID_S4 = 1'b0;

						AWID_S5 = {4'd0, AWID_bus};
						AWADDR_S5 = AWADDR_bus;
						AWLEN_S5 = AWLEN_bus;
						AWSIZE_S5 = AWSIZE_bus;
						AWBURST_S5 = AWBURST_bus;
						AWVALID_S5 = AWVALID_bus;
					end
				endcase
				

				if(AWVALID_bus && AWREADY_bus)begin
					case(AWADDR_bus[31:16])
						16'h0001 : begin
							WREADY_bus = WREADY_S1;
							WDATA_S1 = WDATA_bus;
							WLAST_S1 = WLAST_bus;
							WVALID_S1 = WVALID_bus;
							WSTRB_S1 = WSTRB_bus;
							WDATA_S2 = 32'd0;
							WLAST_S2 = 1'b0;
							WVALID_S2 = 1'b0;
							WSTRB_S2 = 4'd0;
							WDATA_S3 = 32'd0;
							WLAST_S3 = 1'b0;
							WVALID_S3 = 1'b0;
							WSTRB_S3 = 4'd0;
							WDATA_S4 = 32'd0;
							WLAST_S4 = 1'b0;
							WVALID_S4 = 1'b0;
							WSTRB_S4 = 4'd0;
							WDATA_S5 = 32'd0;
							WLAST_S5 = 1'b0;
							WVALID_S5 = 1'b0;					
							WSTRB_S5 = 4'd0;
						end
						16'h0002 : begin
							WREADY_bus = WREADY_S2;
							WLAST_S1 = 1'b0;
							WVALID_S1 = 1'b0;
							WSTRB_S1 = 4'd0;
							WDATA_S1 = 32'd0;
							WDATA_S2 = WDATA_bus;
							WLAST_S2 = WLAST_bus;
							WVALID_S2 = WVALID_bus;
							WSTRB_S2 = WSTRB_bus;
							WDATA_S3 = 32'd0;
							WLAST_S3 = 1'b0;
							WVALID_S3 = 1'b0;
							WSTRB_S3 = 4'd0;
							WDATA_S4 = 32'd0;
							WLAST_S4 = 1'b0;
							WVALID_S4 = 1'b0;
							WSTRB_S4 = 4'd0;
							WDATA_S5 = 32'd0;
							WLAST_S5 = 1'b0;
							WVALID_S5 = 1'b0;					
							WSTRB_S5 = 4'd0;
						end
						16'h1002 : begin
							WREADY_bus = WREADY_S3;
							WLAST_S1 = 1'b0;
							WVALID_S1 = 1'b0;
							WSTRB_S1 = 4'd0;
							WDATA_S1 = 32'd0;
							WDATA_S2 = 32'd0;
							WLAST_S2 = 1'b0;
							WVALID_S2 = 1'b0;
							WSTRB_S2 = 4'd0;
							WDATA_S3 = WDATA_bus;
							WLAST_S3 = WLAST_bus;
							WVALID_S3 = WVALID_bus;
							WSTRB_S3 = WSTRB_bus;
							WDATA_S4 = 32'd0;
							WLAST_S4 = 1'b0;
							WVALID_S4 = 1'b0;
							WSTRB_S4 = 4'd0;
							WDATA_S5 = 32'd0;
							WLAST_S5 = 1'b0;
							WVALID_S5 = 1'b0;					
							WSTRB_S5 = 4'd0;
						end
						16'h1001 : begin
							WREADY_bus = WREADY_S4;
							WDATA_S1 = 32'd0;
							WLAST_S1 = 1'b0;
							WVALID_S1 = 1'b0;
							WSTRB_S1 = 4'd0;
							WDATA_S2 = 32'd0;
							WLAST_S2 = 1'b0;
							WVALID_S2 = 1'b0;
							WSTRB_S2 = 4'd0;
							WDATA_S3 = 32'd0;
							WLAST_S3 = 1'b0;
							WVALID_S3 = 1'b0;
							WSTRB_S3 = 4'd0;
							WDATA_S4 = WDATA_bus;
							WLAST_S4 = WLAST_bus;
							WVALID_S4 = WVALID_bus;
							WSTRB_S4 = WSTRB_bus;
							WDATA_S5 = 32'd0;
							WLAST_S5 = 1'b0;
							WVALID_S5 = 1'b0;					
							WSTRB_S5 = 4'd0;
						end
						default : begin
							WREADY_bus = WREADY_S5;
							WDATA_S1 = 32'd0;
							WLAST_S1 = 1'b0;
							WVALID_S1 = 1'b0;
							WSTRB_S1 = 4'd0;
							WDATA_S2 = 32'd0;
							WLAST_S2 = 1'b0;
							WVALID_S2 = 1'b0;
							WSTRB_S2 = 4'd0;
							WDATA_S3 = 32'd0;
							WLAST_S3 = 1'b0;
							WVALID_S3 = 1'b0;
							WSTRB_S3 = 4'd0;
							WDATA_S4 = 32'd0;
							WLAST_S4 = 1'b0;
							WVALID_S4 = 1'b0;
							WSTRB_S4 = 4'd0;
							WDATA_S5 = WDATA_bus;
							WLAST_S5 = WLAST_bus;
							WVALID_S5 = WVALID_bus;
							WSTRB_S5 = WSTRB_bus;
						end 
						
					endcase
				
				end else begin
					WREADY_bus = 1'b0;
					WDATA_S1 = 32'd0;
					WLAST_S1 = 1'b0;
					WVALID_S1 = 1'b0;
					WSTRB_S1 = 4'd0;
					WDATA_S2 = 32'd0;
					WLAST_S2 = 1'b0;
					WVALID_S2 = 1'b0;
					WSTRB_S2 = 4'd0;
					WDATA_S3 = 32'd0;
					WLAST_S3 = 1'b0;
					WVALID_S3 = 1'b0;
					WSTRB_S3 = 4'd0;
					WDATA_S4 = 32'd0;
					WLAST_S4 = 1'b0;
					WVALID_S4 = 1'b0;
					WSTRB_S4 = 4'd0;
					WDATA_S5 = 32'd0;
					WLAST_S5 = 1'b0;
					WVALID_S5 = 1'b0;					
					WSTRB_S5 = 4'd0;
				end
				
			end
			1'b1 : begin
				
				case(wslave_dat_sel)
					3'd1 : begin // slave 1 IM
						AWREADY_bus = AWREADY_S1;
						AWID_S1 = {4'd0, AWID_bus};
						AWADDR_S1 = AWADDR_bus;
						AWLEN_S1 = AWLEN_bus;
						AWSIZE_S1 = AWSIZE_bus;
						AWBURST_S1 = AWBURST_bus;
						AWVALID_S1 = AWVALID_bus;

						AWID_S2 = 8'd0;
						AWADDR_S2 = 32'd0;
						AWLEN_S2 = 32'd0;
						AWSIZE_S2 = 3'd0;
						AWBURST_S2 = 2'd0;
						AWVALID_S2 = 1'b0;

						AWID_S3 = 8'd0;
						AWADDR_S3 = 32'd0;
						AWLEN_S3 = 32'd0;
						AWSIZE_S3 = 3'd0;
						AWBURST_S3 = 2'd0;
						AWVALID_S3 = 1'b0;

						AWID_S4 = 8'd0;
						AWADDR_S4 = 32'd0;
						AWLEN_S4 = 32'd0;
						AWSIZE_S4 = 3'd0;
						AWBURST_S4 = 2'd0;
						AWVALID_S4 = 1'b0;

						AWID_S5 = 8'd0;
						AWADDR_S5 = 32'd0;
						AWLEN_S5 = 32'd0;
						AWSIZE_S5 = 3'd0;
						AWBURST_S5 = 2'd0;
						AWVALID_S5 = 1'b0;
					
						WREADY_bus = WREADY_S1;
						WDATA_S1 = WDATA_bus;
						WLAST_S1 = WLAST_bus;
						WVALID_S1 = WVALID_bus;						
						WSTRB_S1 = WSTRB_bus;
	
						WDATA_S2 = 32'd0;
						WLAST_S2 = 1'b0;
						WVALID_S2 = 1'b0;
						WSTRB_S2 = 4'd0;

						WDATA_S3 = 32'd0;
						WLAST_S3 = 1'b0;
						WVALID_S3 = 1'b0;
						WSTRB_S3 = 4'd0;

						WDATA_S4 = 32'd0;
						WLAST_S4 = 1'b0;
						WVALID_S4 = 1'b0;
						WSTRB_S4 = 4'd0;
		
						WDATA_S5 = 32'd0;
						WLAST_S5 = 1'b0;
						WVALID_S5 = 1'b0;
						WSTRB_S5 = 4'd0;

						BREADY_S1 = BREADY_bus;
						BREADY_S2 = 1'b0;
						BREADY_S3 = 1'b0;
						BREADY_S4 = 1'b0;
						BREADY_S5 = 1'b0;
						BVALID_bus = BVALID_S1;
						BID_bus = BID_S1;
						BRESP_bus = BRESP_S1;
					end
					3'd2 : begin // slave 2 DM
						AWREADY_bus = AWREADY_S2;
						AWID_S2 = {4'd0, AWID_bus};
						AWADDR_S2 = AWADDR_bus;
						AWLEN_S2 = AWLEN_bus;
						AWSIZE_S2 = AWSIZE_bus;
						AWBURST_S2 = AWBURST_bus;
						AWVALID_S2 = AWVALID_bus;

						AWID_S1 = 8'd0;
						AWADDR_S1 = 32'd0;
						AWLEN_S1 = 32'd0;
						AWSIZE_S1 = 3'd0;
						AWBURST_S1 = 2'd0;
						AWVALID_S1 = 1'b0;

						AWID_S3 = 8'd0;
						AWADDR_S3 = 32'd0;
						AWLEN_S3 = 32'd0;
						AWSIZE_S3 = 3'd0;
						AWBURST_S3 = 2'd0;
						AWVALID_S3 = 1'b0;

						AWID_S4 = 8'd0;
						AWADDR_S4 = 32'd0;
						AWLEN_S4 = 32'd0;
						AWSIZE_S4 = 3'd0;
						AWBURST_S4 = 2'd0;
						AWVALID_S4 = 1'b0;

						AWID_S5 = 8'd0;
						AWADDR_S5 = 32'd0;
						AWLEN_S5 = 32'd0;
						AWSIZE_S5 = 3'd0;
						AWBURST_S5 = 2'd0;
						AWVALID_S5 = 1'b0;

						WREADY_bus = WREADY_S2;
						WDATA_S2 = WDATA_bus;
						WLAST_S2 = WLAST_bus;
						WVALID_S2 = WVALID_bus;						
						WSTRB_S2 = WSTRB_bus;
	
						WDATA_S1 = 32'd0;
						WLAST_S1 = 1'b0;
						WVALID_S1 = 1'b0;
						WSTRB_S1 = 4'd0;

						WDATA_S3 = 32'd0;
						WLAST_S3 = 1'b0;
						WVALID_S3 = 1'b0;
						WSTRB_S3 = 4'd0;

						WDATA_S4 = 32'd0;
						WLAST_S4 = 1'b0;
						WVALID_S4 = 1'b0;
						WSTRB_S4 = 4'd0;
		
						WDATA_S5 = 32'd0;
						WLAST_S5 = 1'b0;
						WVALID_S5 = 1'b0;
						WSTRB_S5 = 4'd0;

						BREADY_S1 = 1'b0;
						BREADY_S2 = BREADY_bus;
						BREADY_S3 = 1'b0;
						BREADY_S4 = 1'b0;
						BREADY_S5 = 1'b0;
						BVALID_bus = BVALID_S2;
						BID_bus = BID_S2;
						BRESP_bus = BRESP_S2;
					end
					3'd3 : begin // slave 3 DMA
						AWREADY_bus = AWREADY_S3;
						AWID_S3 = {4'd0, AWID_bus};
						AWADDR_S3 = AWADDR_bus;
						AWLEN_S3 = AWLEN_bus;
						AWSIZE_S3 = AWSIZE_bus;
						AWBURST_S3 = AWBURST_bus;
						AWVALID_S3 = AWVALID_bus;

						AWID_S1 = 8'd0;
						AWADDR_S1 = 32'd0;
						AWLEN_S1 = 32'd0;
						AWSIZE_S1 = 3'd0;
						AWBURST_S1 = 2'd0;
						AWVALID_S1 = 1'b0;

						AWID_S2 = 8'd0;
						AWADDR_S2 = 32'd0;
						AWLEN_S2 = 32'd0;
						AWSIZE_S2 = 3'd0;
						AWBURST_S2 = 2'd0;
						AWVALID_S2 = 1'b0;

						AWID_S4 = 8'd0;
						AWADDR_S4 = 32'd0;
						AWLEN_S4 = 32'd0;
						AWSIZE_S4 = 3'd0;
						AWBURST_S4 = 2'd0;
						AWVALID_S4 = 1'b0;

						AWID_S5 = 8'd0;
						AWADDR_S5 = 32'd0;
						AWLEN_S5 = 32'd0;
						AWSIZE_S5 = 3'd0;
						AWBURST_S5 = 2'd0;
						AWVALID_S5 = 1'b0;

						WREADY_bus = WREADY_S3;
						WDATA_S3 = WDATA_bus;
						WLAST_S3 = WLAST_bus;
						WVALID_S3 = WVALID_bus;						
						WSTRB_S3 = WSTRB_bus;
	
						WDATA_S1 = 32'd0;
						WLAST_S1 = 1'b0;
						WVALID_S1 = 1'b0;
						WSTRB_S1 = 4'd0;

						WDATA_S2 = 32'd0;
						WLAST_S2 = 1'b0;
						WVALID_S2 = 1'b0;
						WSTRB_S2 = 4'd0;

						WDATA_S4 = 32'd0;
						WLAST_S4 = 1'b0;
						WVALID_S4 = 1'b0;
						WSTRB_S4 = 4'd0;
		
						WDATA_S5 = 32'd0;
						WLAST_S5 = 1'b0;
						WVALID_S5 = 1'b0;
						WSTRB_S5 = 4'd0;
		
						BREADY_S1 = 1'b0;
						BREADY_S2 = 1'b0;
						BREADY_S3 = BREADY_bus;
						BREADY_S4 = 1'b0;
						BREADY_S5 = 1'b0;
	
						BVALID_bus = BVALID_S3;
						BID_bus = BID_S3;
						BRESP_bus = BRESP_S3;
					end
					3'd4 : begin // slave 4 WDT
						AWREADY_bus = AWREADY_S4;
						AWID_S4 = {4'd0, AWID_bus};
						AWADDR_S4 = AWADDR_bus;
						AWLEN_S4 = AWLEN_bus;
						AWSIZE_S4 = AWSIZE_bus;
						AWBURST_S4 = AWBURST_bus;
						AWVALID_S4 = AWVALID_bus;

						AWID_S1 = 8'd0;
						AWADDR_S1 = 32'd0;
						AWLEN_S1 = 32'd0;
						AWSIZE_S1 = 3'd0;
						AWBURST_S1 = 2'd0;
						AWVALID_S1 = 1'b0;

						AWID_S2 = 8'd0;
						AWADDR_S2 = 32'd0;
						AWLEN_S2 = 32'd0;
						AWSIZE_S2 = 3'd0;
						AWBURST_S2 = 2'd0;
						AWVALID_S2 = 1'b0;

						AWID_S3 = 8'd0;
						AWADDR_S3 = 32'd0;
						AWLEN_S3 = 32'd0;
						AWSIZE_S3 = 3'd0;
						AWBURST_S3 = 2'd0;
						AWVALID_S3 = 1'b0;

						AWID_S5 = 8'd0;
						AWADDR_S5 = 32'd0;
						AWLEN_S5 = 32'd0;
						AWSIZE_S5 = 3'd0;
						AWBURST_S5 = 2'd0;
						AWVALID_S5 = 1'b0;

						WREADY_bus = WREADY_S4;
						WDATA_S4 = WDATA_bus;
						WLAST_S4 = WLAST_bus;
						WVALID_S4 = WVALID_bus;						
						WSTRB_S4 = WSTRB_bus;
	
						WDATA_S1 = 32'd0;
						WLAST_S1 = 1'b0;
						WVALID_S1 = 1'b0;
						WSTRB_S1 = 4'd0;

						WDATA_S2 = 32'd0;
						WLAST_S2 = 1'b0;
						WVALID_S2 = 1'b0;
						WSTRB_S2 = 4'd0;

						WDATA_S3 = 32'd0;
						WLAST_S3 = 1'b0;
						WVALID_S3 = 1'b0;
						WSTRB_S3 = 4'd0;
		
						WDATA_S5 = 32'd0;
						WLAST_S5 = 1'b0;
						WVALID_S5 = 1'b0;
						WSTRB_S5 = 4'd0;

						BREADY_S1 = 1'b0;
						BREADY_S2 = 1'b0;
						BREADY_S3 = 1'b0;
						BREADY_S4 = BREADY_bus;
						BREADY_S5 = 1'b0;

						BVALID_bus = BVALID_S4;
						BID_bus = BID_S4;
						BRESP_bus = BRESP_S4;
					end
					3'd5 : begin // slave 5 DRAM
						AWREADY_bus = AWREADY_S5;
						AWID_S5 = {4'd0, AWID_bus};
						AWADDR_S5 = AWADDR_bus;
						AWLEN_S5 = AWLEN_bus;
						AWSIZE_S5 = AWSIZE_bus;
						AWBURST_S5 = AWBURST_bus;
						AWVALID_S5 = AWVALID_bus;

						AWID_S1 = 8'd0;
						AWADDR_S1 = 32'd0;
						AWLEN_S1 = 32'd0;
						AWSIZE_S1 = 3'd0;
						AWBURST_S1 = 2'd0;
						AWVALID_S1 = 1'b0;

						AWID_S2 = 8'd0;
						AWADDR_S2 = 32'd0;
						AWLEN_S2 = 32'd0;
						AWSIZE_S2 = 3'd0;
						AWBURST_S2 = 2'd0;
						AWVALID_S2 = 1'b0;

						AWID_S3 = 8'd0;
						AWADDR_S3 = 32'd0;
						AWLEN_S3 = 32'd0;
						AWSIZE_S3 = 3'd0;
						AWBURST_S3 = 2'd0;
						AWVALID_S3 = 1'b0;

						AWID_S4 = 8'd0;
						AWADDR_S4 = 32'd0;
						AWLEN_S4 = 32'd0;
						AWSIZE_S4 = 3'd0;
						AWBURST_S4 = 2'd0;
						AWVALID_S4 = 1'b0;

						WREADY_bus = WREADY_S5;
						WDATA_S5 = WDATA_bus;
						WLAST_S5 = WLAST_bus;
						WVALID_S5 = WVALID_bus;						
						WSTRB_S5 = WSTRB_bus;
	
						WDATA_S1 = 32'd0;
						WLAST_S1 = 1'b0;
						WVALID_S1 = 1'b0;
						WSTRB_S1 = 4'd0;

						WDATA_S2 = 32'd0;
						WLAST_S2 = 1'b0;
						WVALID_S2 = 1'b0;
						WSTRB_S2 = 4'd0;

						WDATA_S3 = 32'd0;
						WLAST_S3 = 1'b0;
						WVALID_S3 = 1'b0;
						WSTRB_S3 = 4'd0;
		
						WDATA_S4 = 32'd0;
						WLAST_S4 = 1'b0;
						WVALID_S4 = 1'b0;
						WSTRB_S4 = 4'd0;

						BREADY_S1 = 1'b0;
						BREADY_S2 = 1'b0;
						BREADY_S3 = 1'b0;
						BREADY_S4 = 1'b0;
						BREADY_S5 = BREADY_bus;

						BVALID_bus = BVALID_S5;
						BID_bus = BID_S5;
						BRESP_bus = BRESP_S5;
					end
					default : begin
						AWREADY_bus = 1'b0;
						AWID_S1 = 8'd0;
						AWADDR_S1 = 32'd0;
						AWLEN_S1 = 32'd0;
						AWSIZE_S1 = 3'd0;
						AWBURST_S1 = 2'd0;
						AWVALID_S1 = 1'b0;

						AWID_S2 = 8'd0;
						AWADDR_S2 = 32'd0;
						AWLEN_S2 = 32'd0;
						AWSIZE_S2 = 3'd0;
						AWBURST_S2 = 2'd0;
						AWVALID_S2 = 1'b0;

						AWID_S3 = 8'd0;
						AWADDR_S3 = 32'd0;
						AWLEN_S3 = 32'd0;
						AWSIZE_S3 = 3'd0;
						AWBURST_S3 = 2'd0;
						AWVALID_S3 = 1'b0;

						AWID_S4 = 8'd0;
						AWADDR_S4 = 32'd0;
						AWLEN_S4 = 32'd0;
						AWSIZE_S4 = 3'd0;
						AWBURST_S4 = 2'd0;
						AWVALID_S4 = 1'b0;

						AWID_S5 = 8'd0;
						AWADDR_S5 = 32'd0;
						AWLEN_S5 = 32'd0;
						AWSIZE_S5 = 3'd0;
						AWBURST_S5 = 2'd0;
						AWVALID_S5 = 1'b0;

						WDATA_S1 = 32'd0;
						WLAST_S1 = 1'b0;
						WVALID_S1 = 1'b0;
						WSTRB_S1 = 4'd0;
	
						WDATA_S2 = 32'd0;
						WLAST_S2 = 1'b0;
						WVALID_S2 = 1'b0;
						WSTRB_S2 = 4'd0;

						WDATA_S3 = 32'd0;
						WLAST_S3 = 1'b0;
						WVALID_S3 = 1'b0;
						WSTRB_S3 = 4'd0;

						WDATA_S4 = 32'd0;
						WLAST_S4 = 1'b0;
						WVALID_S4 = 1'b0;
						WSTRB_S4 = 4'd0;
		
						WDATA_S5 = 32'd0;
						WLAST_S5 = 1'b0;
						WVALID_S5 = 1'b0;
						WSTRB_S5 = 4'd0;

						BREADY_S1 = 1'b0;
						BREADY_S2 = 1'b0;
						BREADY_S3 = 1'b0;
						BREADY_S4 = 1'b0;
						BREADY_S5 = 1'b0;

						BVALID_bus = 1'b0;
						BID_bus = 8'd0;
						BRESP_bus = 2'd0;

						WREADY_bus = 1'b0;
					end
				endcase
				
				
			end
		endcase 
	end



endmodule
