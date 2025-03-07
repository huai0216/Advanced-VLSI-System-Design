module pc(
	input clk,
	input rst,
	input [31:0] pcin,
	input stall,
	input first,
	//input pcwrite,
	input load_use_hazard,
	output logic [31:0] pcout
);

	always_ff@(posedge clk or posedge rst)begin
		if(rst)begin
			pcout <= 32'd0;
		end else begin
			if(stall || (!first) || load_use_hazard)begin
				pcout <= pcout;
			end else begin
				pcout <= pcin;
			end		
		end
	end
endmodule
