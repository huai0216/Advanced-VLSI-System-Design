
module cdc_write_wrapper(
	input clk,
	input clk2,
	input rst,
	input rst2,
	
	//WRITE ADDRESS dma
	input [`AXI_IDS_BITS-1:0] AWID_M,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M,
	input [`AXI_LEN_BITS-1:0] AWLEN_M,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M,
	input [1:0] AWBURST_M,
	input AWVALID_M,
	output logic AWREADY_M,
	
	//WRITE DATA dma
	input [`AXI_DATA_BITS-1:0] WDATA_M,
	input [`AXI_STRB_BITS-1:0] WSTRB_M,
	input WLAST_M,
	input WVALID_M,
	output logic WREADY_M,
	
	//WRITE RESPONSE dma
	output logic [`AXI_IDS_BITS-1:0] BID_M,
	output logic [1:0] BRESP_M,
	output logic BVALID_M,
	input BREADY_M,


	//WRITE ADDRESS  DRAM
	output logic [`AXI_IDS_BITS-1:0] AWID_S,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S,
	output logic [1:0] AWBURST_S,
	output logic AWVALID_S,
	input AWREADY_S,
	
	//WRITE DATA DRAM
	output logic [`AXI_DATA_BITS-1:0] WDATA_S,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S,
	output logic WLAST_S,
	output logic WVALID_S,
	input WREADY_S,
	
	//WRITE RESPONSE DRAM
	input [`AXI_IDS_BITS-1:0] BID_S,
	input [1:0] BRESP_S,
	input BVALID_S,
	output logic BREADY_S
);

logic [63:0] aw_wdata, aw_rdata;
logic aw_wfull, aw_rempty;
logic [36:0] w_wdata, w_rdata;
logic w_wfull, w_rempty;
logic [1:0] b_wdata, b_rdata;
logic b_wfull, b_rempty;

	

	always_comb begin
		BID_M = `AXI_IDS_BITS'd0;
		
		AWID_S = `AXI_IDS_BITS'd0;
		AWSIZE_S = 3'b010;
		AWBURST_S = 2'd1;
	end

	always_comb begin
		aw_wdata = {AWADDR_M, AWLEN_M};
		{AWADDR_S, AWLEN_S} = aw_rdata;
		AWREADY_M = ~aw_wfull;
		AWVALID_S = ~aw_rempty;
	end

	afifo #(.DSIZE(64), .ASIZE(2))
	aw_channel(
		.rdata(aw_rdata),       // Output data - data to be read	output		
	    	.wfull(aw_wfull),                   // Write full signal	output
	    	.rempty(aw_rempty),                  // Read empty signal	output
	   	.wdata(aw_wdata),      // Input data - data to be written	input
	    	.winc(AWVALID_M), 
		.wclk(clk), 
		.wrst_n(rst),       // Write increment, write clock, write reset	input
	    	.rinc(AWREADY_S), 
		.rclk(clk2), 
		.rrst_n(rst2)      // Read increment, read clock, read reset	input
	 );

	always_comb begin
		w_wdata = {WDATA_M, WSTRB_M, WLAST_M};
		{WDATA_S, WSTRB_S, WLAST_S} = w_rdata;
		WREADY_M = ~w_wfull;
		WVALID_S = ~w_rempty;
	end

	afifo #(.DSIZE(37), .ASIZE(2))w_channel(
		.rdata(w_rdata),       // Output data - data to be read	output		
	    	.wfull(w_wfull),                   // Write full signal	output
	    	.rempty(w_rempty),                  // Read empty signal	output
	   	.wdata(w_wdata),      // Input data - data to be written	input
	    	.winc(WVALID_M), 
		.wclk(clk), 
		.wrst_n(rst),       // Write increment, write clock, write reset	input
	    	.rinc(WREADY_S), 
		.rclk(clk2), 
		.rrst_n(rst2)      // Read increment, read clock, read reset	input
	 );

	always_comb begin
		b_wdata = BRESP_S;
		BRESP_M = b_rdata;
		BREADY_S = ~b_wfull;
		BVALID_M = ~b_rempty;
	end

	afifo #(.DSIZE(2), .ASIZE(2))b_channel(
		.rdata(b_rdata),       // Output data - data to be read	output		
	    	.wfull(b_wfull),                   // Write full signal	output
	    	.rempty(b_rempty),                  // Read empty signal	output
	   	.wdata(b_wdata),      // Input data - data to be written	input
	    	.winc(BVALID_S), 
		.wclk(clk2), 
		.wrst_n(rst2),       // Write increment, write clock, write reset	input
	    	.rinc(BREADY_M), 
		.rclk(clk), 
		.rrst_n(rst)      // Read increment, read clock, read reset	input
	 );

endmodule
