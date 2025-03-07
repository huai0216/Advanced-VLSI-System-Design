module MEMWB(
	input clk,
	input rst,
	input [31:0] indata,
	input inmemtoreg,
	input [4:0] inrd,
	input [31:0] inddata,
	input inregwrite,
	input infloatwb,
	input stall,
	output logic [31:0] outdata,
	output logic memtoreg,
	output logic [4:0] outrd,
	output logic [31:0] outddata,
	output logic outregwrite,
	output logic outfloatwb
);

	always_ff@(posedge clk or posedge rst)begin
		if(rst)begin
			outdata <= 32'd0;
			memtoreg <= 1'd0;
			outrd <= 5'd0;
			outddata <= 32'd0;
			outregwrite <= 1'b0;
			outfloatwb <= 1'b0;
		end else begin
			if(stall)begin
				outdata <= outdata;
				memtoreg <= memtoreg;
				outrd <= outrd;
				outddata <= outddata;
				outregwrite <= outregwrite;
				outfloatwb <= outfloatwb;	
			end else begin
				outdata <= indata;
				memtoreg <= inmemtoreg;
				outrd <= inrd;
				outddata <= inddata;
				outregwrite <= inregwrite;
				outfloatwb <= infloatwb;
			end
		end
	end

endmodule
