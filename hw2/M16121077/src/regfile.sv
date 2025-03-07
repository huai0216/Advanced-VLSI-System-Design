module regfile(
	input clk,
	input rst,
	input [4:0] readreg1,
	input [4:0] readreg2,
	input [4:0] writereg,
	input [31:0] writedata,
	input regwrite,
	input stall,
	//input flush,
	input floatrd1,
	input floatrd2,
	input floatwb,
	input load_use_hazard,
	output logic [31:0] readdata1,
	output logic [31:0] readdata2
);

logic [31:0] regfile [0:63];
logic [5:0] readreg1_mv, readreg2_mv, writereg_mv;
integer i;

//wire [31:0] expiredata1;
//assign expiredata1 = regfile[readreg1];
	always_ff@(posedge clk or posedge rst)begin
		if(rst)begin
			for(i = 0; i < 64; i = i + 1)begin
				regfile[i] <= 32'd0;
			end
			readdata1 <= 32'd0;
			readdata2 <= 32'd0;
		end else begin
			if(stall)begin
				regfile[writereg_mv] <= regfile[writereg_mv];
			end else 
			if(regwrite && (writereg_mv!= 6'd0))begin
				regfile[writereg_mv] <= writedata;
			end
			if(stall)begin
				readdata1 <= readdata1;
				readdata2 <= readdata2;
			end else
			if(load_use_hazard) begin
				readdata1 <= 32'd0;
				readdata2 <= 32'd0;
			end else begin
				if(regwrite && (readreg1_mv == writereg_mv) && (writereg_mv!=6'd0))
					readdata1 <= writedata;
				else 
					readdata1 <= regfile[readreg1_mv];
				if(regwrite && (readreg2_mv == writereg_mv) && (writereg_mv != 6'd0))
					readdata2 <= writedata;
				else
					readdata2 <= regfile[readreg2_mv];
			end

		end
	end
	always_comb begin
		if(floatrd1)begin
			readreg1_mv = {1'b0, readreg1} + 6'd32;
		end else begin
			readreg1_mv = {1'b0,readreg1};
		end
		if(floatrd2)begin
			readreg2_mv = {1'b0, readreg2} + 6'd32;
		end else begin
			readreg2_mv = {1'b0, readreg2};
		end
		if(floatwb)begin
			writereg_mv = {1'b0, writereg} + 6'd32;
		end else begin
			writereg_mv = {1'b0, writereg};
		end
	end
endmodule
