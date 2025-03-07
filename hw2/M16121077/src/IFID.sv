module IFID(
	input clk,
	input rst,
	input [31:0] inst_in,
	input stall,
	//input [15:0] inpc,
	output logic [31:0] inst_out

);
logic first;
	always_ff@(posedge clk or posedge rst)begin
		if(rst)begin
			inst_out <= 32'd0;
			first <= 1'b0;
		end else begin
			first <= 1'b1;
			if(!first)begin
				inst_out <= 32'h0000_0013;
			end else if(stall)begin
				inst_out <= inst_out;
			end else begin
				inst_out <= inst_in;
			end
		end
	end

endmodule
