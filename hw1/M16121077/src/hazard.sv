module hazard(
	input clk,
	input rst,
	//input inflush,
	input id_ex_memread,
	input [4:0] rs1,
	input [4:0] rs2,
	input [4:0] rd,
	//input floatrd2,
	//input floatwb,
	output logic delay_hazard,
	output logic load_use_hazard
);
//logic float_rd;
//logic load_use_hazard;
	always_ff@(posedge clk or posedge rst)begin
		if(rst)begin
			delay_hazard <= 1'b0;
		end else begin
			delay_hazard <= load_use_hazard;
		end
	end
	always_comb begin
		/*if(floatrd2 && (rs2==rd))begin
			float_rd = 1'b1;
		end else begin
			float_rd = 1'b0;
		end*/
		if(id_ex_memread && ((rd==rs1) || (rd==rs2)) )begin //load use hazard
			load_use_hazard = 1'b1;
		end else begin
			load_use_hazard = 1'b0;
		end	
	end
endmodule
