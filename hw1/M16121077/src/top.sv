`include "SRAM_wrapper.sv"
`include "CPU.sv"

module top (
	input clk,
	input rst
);

logic [15:0] iaddr;
logic [31:0] idata;
logic [15:0] daddr;
logic memwrite;
logic [31:0] ddata;
logic [31:0] datawrite;
logic [31:0] bit_enable;

CPU cpu(
	//input
	.clk(clk),
	.rst(rst),
	.inst(idata),
	.ddata(ddata),
	//output
	.iaddr(iaddr),
	.memwrite(memwrite),
	.daddr(daddr),
	.datawrite(datawrite),
	.bit_enable(bit_enable)
);



SRAM_wrapper IM1(
	.CLK(clk),
	.RST(rst),
	.CEB(1'b0),
	.WEB(1'b1),
	.BWEB(32'hffff_ffff),
	.A(iaddr[15:2]),
	.DI(32'd0),
	.DO(idata)
);

SRAM_wrapper DM1(
	.CLK(clk),
	.RST(rst),
	.CEB(1'b0),
	.WEB(memwrite),
	.BWEB(bit_enable),
	.A(daddr[15:2]),
	.DI(datawrite),
	.DO(ddata)
);



endmodule

