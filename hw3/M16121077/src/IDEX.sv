module IDEX(
	input clk,
	input rst,
	input [31:0] ininstruction,
	input [3:0] inaluop,
	input inmemtoreg,
	input [4:0] inrd,
	input inmemwrite,
	input [2:0] indatatype,
	input [31:0] inpcnext,
	input inregwrite,
	input [1:0] inwritetype,
	input injump,
	input branch_taken,
	input inbranch,
	input [31:0] inpc,
	input [31:0] inimme,
	input [4:0] inshamt,
	input [1:0] indata2src,
	input inmemread,
	input [1:0] inregwritedat,
	input inpcwritedat,
	input inauipc,
	input infloatop,
	input infloatwb,
	input load_use_hazard,
	input [2:0] incomptype,
	input inrdinstret,
	input inhigh,
	input inwrite_csr,
	input stall,
	input wfi,
	input interrupt_delay,
	//input interrupt_dma,
	//input interrupt_time,
	input mret_out,
	output logic [31:0] outinstruction,
	output reg [3:0] aluop,
	output logic outmemtoreg,
	output logic [4:0] outrd,
	output logic outmemwrite,
	output logic [2:0] outdatatype,
	output logic [31:0] outpcnext,
	output logic outregwrite,
	output logic [1:0] outwritetype,
	output logic outjump,
	output logic outbranch,
	output logic [31:0] outpc,
	output logic [31:0] outimme,
	output logic [4:0] outshamt,
	output logic [1:0] outdata2src,
	output logic outmemread,
	output logic outpcwritedat,
	output logic [1:0] outregwritedat,
	output logic outauipc,
	output logic outfloatop,
	output logic outfloatwb,
	output logic [2:0] outcomptype,
	output logic outrdinstret,
	output logic outhigh,
	output logic outwrite_csr
);

	always_ff@(posedge clk)begin
		if(rst)begin
			aluop <= 4'd0;
			outmemtoreg <= 1'd0;
			outrd <= 5'd0;
			outmemwrite <= 1'b0;
			outdatatype <= 3'd0;
			outpcnext <= 32'd0;
			outregwrite <= 1'b0;
			outwritetype <= 2'd0;
			outjump <= 1'b0;
			outbranch <= 1'b0;
			outpc <= 32'd0;
			outimme <= 32'd0;
			outshamt <= 5'd0;
			outdata2src <= 2'd0;
			outmemread <= 1'b0;
			outpcwritedat <= 1'b0;
			outregwritedat <= 2'd0;
			outauipc <= 1'd0;
			outfloatop <= 1'b0;
			outfloatwb <= 1'b0;
			outcomptype <= 3'd0;
			outrdinstret <= 1'b0;
			outhigh <= 1'b0;
			outinstruction <= 32'd0;
			outwrite_csr <= 1'b0;
		end else begin
			if(stall || wfi)begin
				aluop <= aluop;
				outmemtoreg <= outmemtoreg;
				outrd <= outrd;
				outmemwrite <= outmemwrite;
				outdatatype <= outdatatype;
				outpcnext <= outpcnext;
				outregwrite <= outregwrite;
				outwritetype <= outwritetype;
				outjump <= outjump;
				outbranch <= outbranch;
				outpc <= outpc;
				outimme <= outimme;
				outshamt <= outshamt;
				outdata2src <= outdata2src;
				outmemread <= outmemread;
				outpcwritedat <= outpcwritedat;
				outregwritedat <= outregwritedat;
				outauipc <= outauipc;
				outfloatop <= outfloatop;
				outfloatwb <= outfloatwb;
				outcomptype <= outcomptype;
				outrdinstret <= outrdinstret;
				outhigh <= outhigh;
				outinstruction <= outinstruction;
				outwrite_csr <= outwrite_csr;
			end else 
			if(load_use_hazard || branch_taken || interrupt_delay || mret_out)begin
				aluop <= 4'd0;
				outmemtoreg <= 1'd0;
				outrd <= 5'd0;
				outmemwrite <= 1'b0;
				outdatatype <= 3'd0;
				outpcnext <= 32'd0;
				outregwrite <= 1'b0;
				outwritetype <= 2'd0;
				outjump <= 1'd0;
				outbranch <= 1'b0;
				outpc <= 32'd0;
				outimme <= 32'd0;
				outshamt <= 5'd0;
				outdata2src <= 2'd0;
				outmemread <= 1'b0;
				outpcwritedat <= 1'b0;
				outregwritedat <= 2'd0;
				outauipc <= 1'b0;
				outfloatop <= 1'b0;
				outfloatwb <= 1'b0;
				outcomptype <= 3'd0;
				outrdinstret <= 1'b0;
				outhigh <= 1'b0;
				outinstruction <= 32'd0;
				outwrite_csr <= outwrite_csr;
			end else begin
				aluop <= inaluop;
				outmemtoreg <= inmemtoreg;
				outrd <= inrd;
				outmemwrite <= inmemwrite;
				outdatatype <= indatatype;
				outpcnext <= inpcnext;
				outregwrite <= inregwrite;
				outwritetype <= inwritetype;
				outjump <= injump;
				outbranch <= inbranch;
				outpc <= inpc;
				outimme <= inimme;
				outshamt <= inshamt;
				outdata2src <= indata2src;
				outmemread <= inmemread;
				outpcwritedat <= inpcwritedat;
				outregwritedat <= inregwritedat;
				outauipc <= inauipc;
				outfloatop <= infloatop;
				outfloatwb <= infloatwb;
				outcomptype <= incomptype;
				outrdinstret <= inrdinstret;
				outhigh <= inhigh;
				outinstruction <= ininstruction;
				outwrite_csr <= inwrite_csr;
			end
		end
	end

endmodule
