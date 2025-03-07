module pc(
	input clk,
	input rst,
	input [15:0] pcin,
	//input pcwrite,
	input load_use_hazard,
	output logic [15:0] pcout,
	output logic [15:0] pc_buffer
);

	always_ff@(posedge clk or posedge rst)begin
		if(rst)begin
			pcout <= 16'd0;
			pc_buffer <= 16'd0;
		end else begin
			if(load_use_hazard)begin
				pcout <= pcout;
				pc_buffer <= pc_buffer;
			end else begin
				pcout <= pcin;
				pc_buffer <= pcout;
			end		
		end
	end
endmodule
