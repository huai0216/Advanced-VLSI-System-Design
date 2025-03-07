module EXMEM(
	input clk,
	input rst,
	input [31:0] indata,
	input inmemtoreg,
	input [4:0] inrd,
	input inregwrite,
	input stall,
	//input [31:0] inimm,
	input infloatwb,
	input [2:0] indatatype,
	output logic [31:0] aludata,
	output logic outmemtoreg,
	output logic [4:0] outrd,
	output logic [2:0] outdatatype,
	output logic outregwrite,
	output logic outfloatwb
);

	always_ff@(posedge clk or posedge rst)begin
		if(rst)begin
			aludata <= 32'd0;
			outmemtoreg <= 1'd0;
			outrd <= 5'd0;
			outdatatype <= 3'd0;
			outregwrite <= 1'b0;
			outfloatwb <= 1'b0;
		end else begin
			if(stall)begin
				aludata <= aludata;
				outmemtoreg <= outmemtoreg;
				outrd <= outrd;
				outdatatype <= outdatatype;
				outregwrite <= outregwrite;
				outfloatwb <= outfloatwb;
			end else begin
				aludata <= indata;
				outmemtoreg <= inmemtoreg;
				outrd <= inrd;
				outdatatype <= indatatype;
				outregwrite <= inregwrite;
				outfloatwb <= infloatwb;
			end
		end
	end

endmodule
