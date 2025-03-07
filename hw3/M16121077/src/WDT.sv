module WDT(
	input clk,
	input rst,
	//input en_flag,
	//input live_flag,
	//input cnt_flag,
	input WDEN,
	input WDLIVE,
	input [31:0] WTOCNT,
	output logic WTO
);

logic WDEN_reg;
logic WDLIVE_reg;
logic [31:0] WTOCNT_reg;
logic [31:0] cnt;

	always_ff@(posedge clk)begin
		if(!rst)begin
			WDEN_reg <= 1'b0;
			WTOCNT_reg <= 32'd0;
			WDLIVE_reg <= 1'b0;
		end else begin
			//if(en_flag)begin
				WDEN_reg <= WDEN;
			//end
			//if (live_flag)begin
				WDLIVE_reg <= WDLIVE;
			//end
			//if(cnt_flag)begin
				WTOCNT_reg <= WTOCNT;
			//end
		end
	end

	always_ff@(posedge clk )begin
		if(!rst)begin
			cnt <= 32'd0;
			WTO <= 1'b0;
		end else begin
			if(WDEN_reg && (cnt == WTOCNT_reg))begin
				cnt <= 32'd0;
				WTO <= 1'b1;
			end else if(WDLIVE_reg)begin
				cnt <= 32'd0;
				WTO <= 1'b0;
			end else if(WDEN_reg)begin
				cnt <= cnt + 32'd1;
				WTO <= 1'b0;
			end
		end
	end

endmodule
