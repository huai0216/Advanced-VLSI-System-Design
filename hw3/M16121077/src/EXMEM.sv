module EXMEM(
	input clk,
	input rst,
	input [31:0] indata,
	input inmemtoreg,
	input [4:0] inrd,
	input inregwrite,
	input inwrite_csr,
	input stall,
	input mret_out,
	input wfi,
	//input [31:0] inimm,
	input infloatwb,
	input [2:0] indatatype,
	output logic [31:0] aludata,
	output logic outmemtoreg,
	output logic [4:0] outrd,
	output logic [2:0] outdatatype,
	output logic outregwrite,
	output logic outfloatwb,
	output logic outwrite_csr
);

	always_ff@(posedge clk)begin
		if(rst)begin
			aludata <= 32'd0;
			outmemtoreg <= 1'd0;
			outrd <= 5'd0;
			outdatatype <= 3'd0;
			outregwrite <= 1'b0;
			outfloatwb <= 1'b0;
			outwrite_csr <= 1'b0;
		end else begin
			
			if(stall || wfi)begin
				aludata <= aludata;
				outmemtoreg <= outmemtoreg;
				outrd <= outrd;
				outdatatype <= outdatatype;
				outregwrite <= outregwrite;
				outfloatwb <= outfloatwb;
				outwrite_csr <= outwrite_csr;
			end else if(mret_out)begin
				aludata <= 32'd0;
				outmemtoreg <= 1'd0;
				outrd <= 5'd0;
				outdatatype <= 3'd0;
				outregwrite <= 1'b0;
				outfloatwb <= 1'b0;
				outwrite_csr <= 1'b0;
			end else begin
				aludata <= indata;
				outmemtoreg <= inmemtoreg;
				outrd <= inrd;
				outdatatype <= indatatype;
				outregwrite <= inregwrite;
				outfloatwb <= infloatwb;
				outwrite_csr <= inwrite_csr;
			end
		end
	end

endmodule
