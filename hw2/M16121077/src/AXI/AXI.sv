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
`include "AXI_define.svh"

module AXI(

	input ACLK,
	input ARESETn,

	//SLAVE INTERFACE FOR MASTERS
	
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
	//WRITE ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output logic [1:0] AWBURST_S0,
	output logic AWVALID_S0,
	input AWREADY_S0,
	
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output logic WLAST_S0,
	output logic WVALID_S0,
	input WREADY_S0,
	
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output logic BREADY_S0,
	
	//WRITE ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1,
	
	//READ ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] ARID_S0,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output logic [1:0] ARBURST_S0,
	output logic ARVALID_S0,
	input ARREADY_S0,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic RREADY_S0,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S1,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output logic [1:0] ARBURST_S1,
	output logic ARVALID_S1,
	input ARREADY_S1,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic RREADY_S1
	
);
    //---------- you should put your design here ----------//

logic pre_rmaster_r, rmaster_sel, rmaster_dat_sel;
logic [1:0] rslave_sel, rslave_dat_sel;
logic cs, ns, cs_w, ns_w, cs_0, cs_1, ns_0, ns_1;
logic [1:0] wslave_sel, wslave_dat_sel;
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


	always_ff@(posedge ACLK or negedge ARESETn)begin
		if(!ARESETn)begin
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
				ns = (ARVALID_M0 || ARVALID_M1);
			end
			1'b1 : begin
				ns = ~(((!rmaster_dat_sel) && RREADY_M0 && RVALID_M0 && RLAST_M0) || (RLAST_M1 && RREADY_M1 && RVALID_M1 && rmaster_dat_sel));		
			end
		endcase
		case(cs_w)
			1'b0 : begin
				ns_w = (AWVALID_M1 && AWREADY_M1);
			end 
			1'b1 : begin
				ns_w = ~(BREADY_M1 && BVALID_M1);
			end
		endcase
		
	end
	
	always_comb begin : master_select
		case(cs)
			1'b0 : begin
				case({ARVALID_M0, ARVALID_M1})
					2'b11 : rmaster_sel = ~pre_rmaster_r;
					2'b10 : rmaster_sel = 1'b0;
					2'b01 : rmaster_sel = 1'b1;
					2'b00 : rmaster_sel = pre_rmaster_r;
				endcase
			end 
			1'b1 : begin
				rmaster_sel = pre_rmaster_r;
			end 
		endcase
	end
	always_comb begin
		case(cs)
			1'b0 : begin			
				if((rmaster_sel && ARVALID_M1) && (ARADDR_M1[31:16] == 16'h0000 || ARADDR_M1[31:16] == 16'h0001)) begin
					rslave_sel = ARADDR_M1[17:16];
				end else if((!rmaster_sel) && (ARVALID_M0) && (ARADDR_M0[31:16] == 16'h0000 || ARADDR_M0[31:16] == 16'h0001))begin
					rslave_sel = ARADDR_M0[17:16];
				end else begin
					rslave_sel = 2'd2;
				end
			end
			1'b1 : begin
				if((rmaster_dat_sel && ARVALID_M1) && (ARADDR_M1[31:16] == 16'h0000 || ARADDR_M1[31:16] == 16'h0001)) begin
					rslave_sel = ARADDR_M1[17:16];
				
				end else if(((!rmaster_dat_sel) && ARVALID_M0) && (ARADDR_M0[31:16] == 16'h0000 || ARADDR_M0[31:16] == 16'h0001))begin
					rslave_sel = ARADDR_M0[17:16];
				end else begin
					rslave_sel = 2'd2;
				end
				
			end
		endcase
		
		
		
		if(AWVALID_M1 && (AWADDR_M1[31:16] == 16'h0000 || AWADDR_M1[31:16] == 16'h0001)) begin
			wslave_sel = AWADDR_M1[17:16];
		end else begin
			wslave_sel = 2'd2;
		end
	end

	always_ff@(posedge ACLK or negedge ARESETn)begin
		if(!ARESETn)begin
			pre_rmaster_r <= 1'b0;
			rslave_dat_sel <= 2'd0;
			rmaster_dat_sel <= 1'b0;
			wslave_dat_sel <= 2'd0;	
		end else begin
			
			case(cs)
				1'b0 :begin
					if(ARVALID_M0 || ARVALID_M1)begin
						rslave_dat_sel <= rslave_sel;
						rmaster_dat_sel <= rmaster_sel;
					end 
					
				end
				1'b1 : begin
					pre_rmaster_r <= rmaster_sel;
				end
			endcase
			if(AWVALID_M1) wslave_dat_sel <= wslave_sel;
			else wslave_dat_sel <= wslave_dat_sel;
			
			
		end
	end


	always_comb begin
		case(cs)
			1'b0 : begin
				
				if(rslave_sel == 2'd1 && (!rmaster_sel))begin
				//read address
					ARID_S0 = 8'd0;
					ARADDR_S0 = 32'd0;
					ARLEN_S0 = 4'd0;
					ARSIZE_S0 = 3'd0;
					ARBURST_S0 = 2'd0;
					ARVALID_S0 = 1'b0;
					ARREADY_M1 = 1'b0;
					ARID_S1 = {4'd0,ARID_M0};
					ARADDR_S1 = ARADDR_M0;
					ARLEN_S1 = ARLEN_M0;
					ARSIZE_S1 = ARSIZE_M0;
					ARBURST_S1 = ARBURST_M0;
					ARVALID_S1 = ARVALID_M0;
					ARREADY_M0 = ARREADY_S1;
				end else if(rslave_sel == 2'd1 && rmaster_sel)begin
					ARID_S0 = 8'd0;
					ARADDR_S0 = 32'd0;
					ARLEN_S0 = 4'd0;
					ARSIZE_S0 = 3'd0;
					ARBURST_S0 = 2'd0;
					ARVALID_S0 = 1'b0;
					ARREADY_M0 = 1'b0;
					ARID_S1 = {4'd0,ARID_M1};
					ARADDR_S1 = ARADDR_M1;
					ARLEN_S1 = ARLEN_M1;
					ARSIZE_S1 = ARSIZE_M1;
					ARBURST_S1 = ARBURST_M1;
					ARVALID_S1 = ARVALID_M1;
					ARREADY_M1 = ARREADY_S1;
				end else if(rslave_sel == 2'd0 && rmaster_sel)begin
					//read address
					ARID_S0 = {4'd0, ARID_M1};
					ARADDR_S0 = ARADDR_M1;
					ARLEN_S0 = ARLEN_M1;
					ARSIZE_S0 = ARSIZE_M1;
					ARBURST_S0 = ARBURST_M1;
					ARVALID_S0 = ARVALID_M1;
					ARREADY_M0 =1'b0;
					ARID_S1 = 8'd0;
					ARADDR_S1 = 32'd0;
					ARLEN_S1 = 4'd0;
					ARSIZE_S1 = 3'd0;
					ARBURST_S1 = 2'd0;
					ARVALID_S1 = 1'b0;
					ARREADY_M1 = ARREADY_S0;
				end else if(rslave_sel == 2'd0 && (!rmaster_sel))begin
					//read address
					ARID_S0 = {4'd0, ARID_M0};
					ARADDR_S0 = ARADDR_M0;
					ARLEN_S0 = ARLEN_M0;
					ARSIZE_S0 = ARSIZE_M0;
					ARBURST_S0 = ARBURST_M0;
					ARVALID_S0 = ARVALID_M0;
					ARREADY_M0 = ARREADY_S0;
					ARID_S1 = 8'd0;
					ARADDR_S1 = 32'd0;
					ARLEN_S1 = 4'd0;
					ARSIZE_S1 = 3'd0;
					ARBURST_S1 = 2'd0;
					ARVALID_S1 = 1'b0;
					ARREADY_M1 = 1'b0;
				end else begin
					ARID_S0 = 8'd0;
					ARADDR_S0 = 32'd0;
					ARLEN_S0 = 4'd0;
					ARSIZE_S0 = 3'd0;
					ARBURST_S0 = 2'd0;
					ARVALID_S0 = 1'b0;
					ARREADY_M0 = 1'b0;
					ARID_S1 = 8'd0;
					ARADDR_S1 = 32'd0;
					ARLEN_S1 = 4'd0;
					ARSIZE_S1 = 3'd0;
					ARBURST_S1 = 2'd0;
					ARVALID_S1 = 1'b0;
					ARREADY_M1 = 1'b0;
				end 
				RID_M0 = 4'd0;
				RDATA_M0 = 32'd0;
				RRESP_M0 = 2'd0;
				RLAST_M0 = 1'b0;
				RVALID_M0 = 1'b0;
				RREADY_S0 = 1'b0;
				RID_M1 = 4'd0;
				RDATA_M1 = 32'd0;
				RRESP_M1 = 2'd0;
				RLAST_M1 = 1'b0;
				RVALID_M1 = 1'b0;
				RREADY_S1 = 1'b0;
			end
			1'b1 : begin
				
				if(rslave_dat_sel == 2'd1 && (!rmaster_dat_sel))begin
				//read address
					ARID_S0 = 8'd0;
					ARADDR_S0 = 32'd0;
					ARLEN_S0 = 4'd0;
					ARSIZE_S0 = 3'd0;
					ARBURST_S0 = 2'd0;
					ARVALID_S0 = 1'b0;
					ARREADY_M1 = 1'b0;
					ARID_S1 = {4'd0, ARID_M0};
					ARADDR_S1 = ARADDR_M0;
					ARLEN_S1 = ARLEN_M0;
					ARSIZE_S1 = ARSIZE_M0;
					ARBURST_S1 = ARBURST_M0;
					ARVALID_S1 = ARVALID_M0;
					ARREADY_M0 = ARREADY_S1;
					RID_M0 = RID_S1[3:0];
					RDATA_M0 = RDATA_S1;
					RRESP_M0 = RRESP_S1;
					RLAST_M0 = RLAST_S1;
					RVALID_M0 = RVALID_S1;
					RREADY_S1 = RREADY_M0;
					RID_M1 = 4'd0;
					RDATA_M1 = 32'd0;
					RRESP_M1 = 2'd0;
					RLAST_M1 = 1'b0;
					RVALID_M1 = 1'b0;
					RREADY_S0 = 1'b0;
				end else if(rslave_dat_sel == 2'd1 && rmaster_dat_sel)begin
					ARID_S0 = 8'd0;
					ARADDR_S0 = 32'd0;
					ARLEN_S0 = 4'd0;
					ARSIZE_S0 = 3'd0;
					ARBURST_S0 = 2'd0;
					ARVALID_S0 = 1'b0;
					ARREADY_M0 = 1'b0;
					ARID_S1 = {4'd0, ARID_M1};
					ARADDR_S1 = ARADDR_M1;
					ARLEN_S1 = ARLEN_M1;
					ARSIZE_S1 = ARSIZE_M1;
					ARBURST_S1 = ARBURST_M1;
					ARVALID_S1 = ARVALID_M1;
					ARREADY_M1 = ARREADY_S1;
					RID_M0 = 4'd0;
					RDATA_M0 = 32'd0;
					RRESP_M0 = 2'd0;
					RLAST_M0 = 1'b0;
					RVALID_M0 = 1'b0;
					RREADY_S0 = 1'b0;
					RID_M1 = RID_S1[3:0];
					RDATA_M1 = RDATA_S1;
					RRESP_M1 = RRESP_S1;
					RLAST_M1 = RLAST_S1;
					RVALID_M1 = RVALID_S1;
					RREADY_S1 = RREADY_M1;
				end else if(rslave_dat_sel == 2'd0 && rmaster_dat_sel)begin
					//read address
					ARID_S0 = {4'd0,ARID_M1};
					ARADDR_S0 = ARADDR_M1;
					ARLEN_S0 = ARLEN_M1;
					ARSIZE_S0 = ARSIZE_M1;
					ARBURST_S0 = ARBURST_M1;
					ARVALID_S0 = ARVALID_M1;
					ARREADY_M0 =1'b0;
					ARID_S1 = 8'd0;
					ARADDR_S1 = 32'd0;
					ARLEN_S1 = 4'd0;
					ARSIZE_S1 = 3'd0;
					ARBURST_S1 = 2'd0;
					ARVALID_S1 = 1'b0;
					ARREADY_M1 = ARREADY_S0;
					RID_M0 = 4'd0;
					RDATA_M0 = 32'd0;
					RRESP_M0 = 2'd0;
					RLAST_M0 = 1'b0;
					RVALID_M0 = 1'b0;
					RREADY_S1 = 1'b0;
					RID_M1 = RID_S0[3:0];
					RDATA_M1 = RDATA_S0;
					RRESP_M1 = RRESP_S0;
					RLAST_M1 = RLAST_S0;
					RVALID_M1 = RVALID_S0;
					RREADY_S0 = RREADY_M1;
				end else if(rslave_dat_sel == 2'd0 && (!rmaster_dat_sel))begin
					//read address
					ARID_S0 = {4'd0,ARID_M0};
					ARADDR_S0 = ARADDR_M0;
					ARLEN_S0 = ARLEN_M0;
					ARSIZE_S0 = ARSIZE_M0;
					ARBURST_S0 = ARBURST_M0;
					ARVALID_S0 = ARVALID_M0;
					ARREADY_M0 = ARREADY_S0;
					ARID_S1 = 8'd0;
					ARADDR_S1 = 32'd0;
					ARLEN_S1 = 4'd0;
					ARSIZE_S1 = 3'd0;
					ARBURST_S1 = 2'd0;
					ARVALID_S1 = 1'b0;
					ARREADY_M1 = 1'b0;
					RID_M0 = RID_S0[3:0];
					RDATA_M0 = RDATA_S0;
					RRESP_M0 = RRESP_S0;
					RLAST_M0 = RLAST_S0;
					RVALID_M0 = RVALID_S0;
					RREADY_S0 = RREADY_M0;
					RID_M1 = 4'd0;
					RDATA_M1 = 32'd0;
					RRESP_M1 = 2'd0;
					RLAST_M1 = 1'b0;
					RVALID_M1 = 1'b0;
					RREADY_S1 = 1'b0;
				end else begin
					ARID_S0 = 8'd0;
					ARADDR_S0 = 32'd0;
					ARLEN_S0 = 4'd0;
					ARSIZE_S0 = 3'd0;
					ARBURST_S0 = 2'd0;
					ARVALID_S0 = 1'b0;
					ARREADY_M0 = 1'b0;
					ARID_S1 = 8'd0;
					ARADDR_S1 = 32'd0;
					ARLEN_S1 = 4'd0;
					ARSIZE_S1 = 3'd0;
					ARBURST_S1 = 2'd0;
					ARVALID_S1 = 1'b0;
					ARREADY_M1 = 1'b0;
					RID_M0 = 4'd0;
					RDATA_M0 = 32'd0;
					RRESP_M0 = 2'b11;
					RLAST_M0 = 1'b0;
					RVALID_M0 = 1'b0;
					RREADY_S0 = 1'b0;
					RID_M1 = 4'd0;
					RDATA_M1 = 32'd0;
					RRESP_M1 = 2'b11;
					RLAST_M1 = 1'b0;
					RVALID_M1 = 1'b0;
					RREADY_S1 = 1'b0;
				end
				
			end
		endcase 
	end
	always_comb begin
		case(cs_w)
			1'b0 : begin
				if(wslave_sel == 2'd1)begin
					AWID_S1 = {4'd0, AWID_M1};
					AWADDR_S1 = AWADDR_M1;
					AWLEN_S1 = AWLEN_M1;
					AWSIZE_S1 = AWSIZE_M1;
					AWBURST_S1 = AWBURST_M1;
					AWVALID_S1 = AWVALID_M1;
					AWREADY_M1 = AWREADY_S1;
					AWID_S0 = 8'd0;
					AWADDR_S0 = 32'd0;
					AWLEN_S0 = 4'd0;
					AWSIZE_S0 = 3'd0;
					AWBURST_S0 = 2'd0;
					AWVALID_S0 = 1'b0;
				end else if(wslave_sel == 2'd0)begin
					AWID_S0 = {4'd0, AWID_M1};
					AWADDR_S0 = AWADDR_M1;
					AWLEN_S0 = AWLEN_M1;
					AWSIZE_S0 = AWSIZE_M1;
					AWBURST_S0 = AWBURST_M1;
					AWVALID_S0 = AWVALID_M1;
					AWREADY_M1 = AWREADY_S0;
					
					AWID_S1 = 8'd0;
					AWADDR_S1 = 32'd0;
					AWLEN_S1 = 4'd0;
					AWSIZE_S1 = 3'd0;
					AWBURST_S1 = 2'd0;
					AWVALID_S1 = 1'b0;
				end else begin
					AWID_S1 = 8'd0;
					AWADDR_S1 = 32'd0;
					AWLEN_S1 = 4'd0;
					AWSIZE_S1 = 3'd0;
					AWBURST_S1 = 2'd0;
					AWVALID_S1 = 1'b0;
					AWID_S0 = 8'd0;
					AWADDR_S0 = 32'd0;
					AWLEN_S0 = 4'd0;
					AWSIZE_S0 = 3'd0;
					AWBURST_S0 = 2'd0;
					AWVALID_S0 = 1'b0;
					AWREADY_M1 = 1'b0;
				end
				if(AWVALID_M1 && AWREADY_M1 && (wslave_sel == 2'd0))begin
					WDATA_S0 = WDATA_M1;
					WLAST_S0 = WLAST_M1;
					WVALID_S0 = WVALID_M1;
					WREADY_M1 = WREADY_S0;
					WSTRB_S0 = WSTRB_M1;
					WDATA_S1 = 32'd0;
					WLAST_S1 = 1'b0;
					WVALID_S1 = 1'b0;
					WSTRB_S1 = 4'd0;
				end else if(AWVALID_M1 && AWREADY_M1 && (wslave_sel == 2'd1))begin
					WDATA_S1 = WDATA_M1;
					WLAST_S1 = WLAST_M1;
					WVALID_S1 = WVALID_M1;
					WREADY_M1 = WREADY_S1;
					WSTRB_S1 = WSTRB_M1;
					WSTRB_S0 = 4'd0;
					WDATA_S0 = 32'd0;
					WLAST_S0 = 1'b0;
					WVALID_S0 = 1'b0;
				end else begin
					WDATA_S1 = 32'd0;
					WLAST_S1 = 1'b0;
					WVALID_S1 = 1'b0;
					WDATA_S0 = 32'd0;
					WLAST_S0 = 1'b0;
					WVALID_S0 = 1'b0;
					WREADY_M1 = 1'b0;
					WSTRB_S0 = 4'd0;
					WSTRB_S1 = 4'd0;	
				end
				BREADY_S0 = 1'b0;
				BREADY_S1 = 1'b0;
				BID_M1 = 4'd0;
				BRESP_M1 = 2'd0;
				BVALID_M1 = 1'b0;
			end
			1'b1 : begin
				if(wslave_dat_sel == 2'd0)begin
					WDATA_S0 = WDATA_M1;
					WLAST_S0 = WLAST_M1;
					WVALID_S0 = WVALID_M1;
					WREADY_M1 = WREADY_S0;
					WSTRB_S0 = WSTRB_M1;
					WDATA_S1 = 32'd0;
					WLAST_S1 = 1'b0;
					WVALID_S1 = 1'b0;
					WSTRB_S1 = 4'd0;
					BREADY_S1 = 1'b0;
					BREADY_S0 = BREADY_M1;
					BID_M1 = BID_S0[3:0];
					BRESP_M1 = BRESP_S0;
					BVALID_M1 = BVALID_S0;
					AWID_S0 = {4'd0, AWID_M1};
					AWADDR_S0 = AWADDR_M1;
					AWLEN_S0 = AWLEN_M1;
					AWSIZE_S0 = AWSIZE_M1;
					AWBURST_S0 = AWBURST_M1;
					AWVALID_S0 = AWVALID_M1;
					AWREADY_M1 = AWREADY_S0;
					AWID_S1 = 8'd0;
					AWADDR_S1 = 32'd0;
					AWLEN_S1 = 4'd0;
					AWSIZE_S1 = 3'd0;
					AWBURST_S1 = 2'd0;
					AWVALID_S1 = 1'b0;
				end else if(wslave_dat_sel == 2'd1)begin
					WDATA_S1 = WDATA_M1;
					WLAST_S1 = WLAST_M1;
					WVALID_S1 = WVALID_M1;
					WREADY_M1 = WREADY_S1;
					WSTRB_S1 = WSTRB_M1;
					WSTRB_S0 = 4'd0;
					WDATA_S0 = 32'd0;
					WLAST_S0 = 1'b0;
					WVALID_S0 = 1'b0;
					BREADY_S1 = BREADY_M1;
					BREADY_S0 = 1'b0;
					BID_M1 = BID_S1[3:0];
					BRESP_M1 = BRESP_S1;
					BVALID_M1 = BVALID_S1;
					AWID_S1 = {4'd0,AWID_M1};
					AWADDR_S1 = AWADDR_M1;
					AWLEN_S1 = AWLEN_M1;
					AWSIZE_S1 = AWSIZE_M1;
					AWBURST_S1 = AWBURST_M1;
					AWVALID_S1 = AWVALID_M1;
					AWREADY_M1 = AWREADY_S1;
					AWID_S0 = 8'd0;
					AWADDR_S0 = 32'd0;
					AWLEN_S0 = 4'd0;
					AWSIZE_S0 = 3'd0;
					AWBURST_S0 = 2'd0;
					AWVALID_S0 = 1'b0;
				end else begin
					BREADY_S0 = 1'b0;
					BREADY_S1 = 1'b0;
					BID_M1 = 4'd0;
					BRESP_M1 = 2'd0;
					BVALID_M1 = 1'b0;
					WDATA_S1 = 32'd0;
					WLAST_S1 = 1'b0;
					WVALID_S1 = 1'b0;
					WREADY_M1 = 1'b0;
					WDATA_S0 = 32'd0;
					WLAST_S0 = 1'b0;
					WVALID_S0 = 1'b0;
					WSTRB_S0 = 4'd0;
					WSTRB_S1 = 4'd0;
					AWID_S1 = 8'd0;
					AWADDR_S1 = 32'd0;
					AWLEN_S1 = 4'd0;
					AWSIZE_S1 = 3'd0;
					AWBURST_S1 = 2'd0;
					AWVALID_S1 = 1'b0;
					AWID_S0 = 8'd0;
					AWADDR_S0 = 32'd0;
					AWLEN_S0 = 4'd0;
					AWSIZE_S0 = 3'd0;
					AWBURST_S0 = 2'd0;
					AWVALID_S0 = 1'b0;
					AWREADY_M1 = 1'b0;
				end
				
				
			end
		endcase 
	end



endmodule
