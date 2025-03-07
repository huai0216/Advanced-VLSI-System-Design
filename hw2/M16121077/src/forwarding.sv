module forwarding(
	input clk,
	input rst,
	input [4:0] ex_mem_rd,
	input [4:0] mem_wb_rd,
	input [4:0] id_ex_rs1,
	input [4:0] id_ex_rs2,
	input regwritemem,
	input regwritewb,
	input floatrd1,
	input floatrd2,
	input floatwb,
	input floatwbmem,
	input stall,
	output logic [1:0] forwardinga,
	output logic [1:0] forwardingb
);
	
	always_ff@(posedge clk or posedge rst) begin
		if(rst)begin
			forwardinga <= 2'd0;
			forwardingb <= 2'd0;
		end else begin		
			if(stall)
				forwardinga <= forwardinga;
			else if(regwritemem && (ex_mem_rd == id_ex_rs1)&& (ex_mem_rd != 5'd0) && (floatwbmem == floatrd1))
				forwardinga <= 2'b10;
			else if((regwritewb && ((ex_mem_rd != id_ex_rs1) || (floatrd1 != floatwbmem)) && (mem_wb_rd == id_ex_rs1) && (mem_wb_rd != 5'd0)) && (floatwb == floatrd1) )
				forwardinga <= 2'b01;
			else
				forwardinga <= 2'b00;
			if(stall) 
				forwardingb <= forwardingb;
			else if(regwritemem && (ex_mem_rd == id_ex_rs2) && (ex_mem_rd != 5'd0) && (floatwbmem == floatrd2))
				forwardingb <= 2'b10;
			else if(regwritewb && ((ex_mem_rd != id_ex_rs2)|| (floatrd2 != floatwbmem)) && (mem_wb_rd == id_ex_rs2) && (mem_wb_rd != 5'd0) && (floatwb == floatrd2))
				forwardingb <= 2'b01;
			else
				forwardingb <= 2'b00;
		end
		
	end
endmodule
