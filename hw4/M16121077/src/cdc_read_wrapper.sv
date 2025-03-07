
module cdc_read_wrapper(
	input clk,
	input clk2,
	input rst,
	input rst2,

        // AR master channel
  	input [`AXI_ID_BITS-1:0] ARID_M,  //4
	input [`AXI_ADDR_BITS-1:0] ARADDR_M, //32
	input [`AXI_LEN_BITS-1:0] ARLEN_M, //32
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M, //3
	input [1:0] ARBURST_M, //2
	input ARVALID_M,  //1
	output logic ARREADY_M,

	// AR slave channel
	output logic [`AXI_IDS_BITS-1:0] ARID_S,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S,
	output logic [1:0] ARBURST_S,
	output logic ARVALID_S,
	input ARREADY_S,

	// R master
	output logic [`AXI_ID_BITS-1:0] RID_M,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M,
	output logic [1:0] RRESP_M,
	output logic RLAST_M,
	output logic RVALID_M,
	input RREADY_M,

	// R slave
	input [`AXI_IDS_BITS-1:0] RID_S,
	input [`AXI_DATA_BITS-1:0] RDATA_S,
	input [1:0] RRESP_S,
	input RLAST_S,
	input RVALID_S,
	output logic RREADY_S
);


logic [63:0] ar_rdata, ar_wdata;
logic [32:0] r_wdata, r_rdata;
logic ar_rempty, r_rempty;
logic ar_wfull, r_wfull;

	always_comb begin
		ARID_S = 8'd0;
		ARSIZE_S = 3'b010;
		ARBURST_S = 2'b01;
		RID_M = 4'd0;
		RRESP_M = 2'd0;
	end

	always_comb begin
		ar_wdata = {ARADDR_M, ARLEN_M};
		{ARADDR_S, ARLEN_S} = ar_rdata;
		ARVALID_S = ~ar_rempty;
		ARREADY_M = ~ar_wfull;
		
	end 
	afifo #(.DSIZE(64), .ASIZE(2))
	ar_channel(
		.rdata(ar_rdata),       // Output data - data to be read	output		
	    	.wfull(ar_wfull),                   // Write full signal	output
	    	.rempty(ar_rempty),                  // Read empty signal	output
	   	.wdata(ar_wdata),      // Input data - data to be written	input
	    	.winc(ARVALID_M), 
		.wclk(clk), 
		.wrst_n(rst),       // Write increment, write clock, write reset	input
	    	.rinc(ARREADY_S), 
		.rclk(clk2), 
		.rrst_n(rst2)      // Read increment, read clock, read reset	input
	 );

	always_comb begin
		RREADY_S = ~r_wfull;
		RVALID_M = ~r_rempty;
		r_wdata = {RDATA_S, RLAST_S};
		{RDATA_M, RLAST_M} = r_rdata;
	end
	
	afifo #(.DSIZE(33), .ASIZE(2))r_channel(
		.rdata(r_rdata),       // Output data - data to be read	output		
	    	.wfull(r_wfull),                   // Write full signal	output
	    	.rempty(r_rempty),                  // Read empty signal	output
	   	.wdata(r_wdata),      // Input data - data to be written	input
	    	.winc(RVALID_S), 
		.wclk(clk2), 
		.wrst_n(rst2),       // Write increment, write clock, write reset	input
	    	.rinc(RREADY_M), 
		.rclk(clk), 
		.rrst_n(rst)      // Read increment, read clock, read reset	input
	 );
endmodule
