module pc(
	input clk,
	input rst,
	input [31:0] pcin,
	input stall,
	input first,
	input wfi,
	//input pcwrite,
	input load_use_hazard,
	output logic read_im,
	output logic [31:0] pcout
);

	always_ff@(posedge clk)begin
		if(rst)begin
			pcout <= 32'd0;
			read_im <= 1'b0;
		end else begin
			if(wfi) read_im <= 1'b0;
			else read_im <= 1'b1;
			if(stall || (!first) || load_use_hazard || wfi)begin
				pcout <= pcout;
			end else begin
				pcout <= pcin;
			end		
		end
	end
endmodule
