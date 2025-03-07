module alu(
	input [3:0] aluop,
	input [31:0] in1,
	input [31:0] in2,
	input floatop,
	output logic [31:0] aluout
);
logic [31:0] dat1; // 0 : rs1 , 1 : rs1(signed)
logic [31:0] dat2; // 0 : rs2, 1 : rs2(signed), 2 : rs2[4:0]
logic [65:0] mul;
logic [31:0] fa, fb, fa_abs, fb_abs;
logic [31:0] fa_swap, fb_swap;
logic [7:0] a_exp, b_exp, diff_exp;
logic [23:0] fix_a, fix_b;
logic signed [48:0] signed_a, signed_b;
logic signed [48:0] shift_b;
logic signed [49:0] sum;
logic [49:0] sum_abs;
logic [7:0] exp;
logic [22:0] mant, mantissa;
logic [31:0] normal1, normal2, normal3, normal4, normal5, normal6;
logic [5:0] normal;
logic fb_signed;
logic comp, flag0, flag1, flag2, flag3, flag4, sign, round;
logic [31:0] result;
logic signed [32:0] dat1_s;
logic signed [32:0] dat2_s;

logic [32:0] ander;
logic signed [32:0] and1, and2;




	always_comb begin
	
		case(aluop)
			4'd10, 4'd12:begin
				dat1_s = {1'b0, in1};
				dat2_s = {1'b0, in2};
			end
			4'd11:begin
				dat1_s = {in1[31],in1};
				dat2_s = {in2[31],in2};
			end
			4'd13:begin
				dat1_s = {in1[31],in1};
				dat2_s = {1'b0, in2};
			end
			default : begin
				dat1_s = 33'd0;
				dat2_s = 33'd0;
			end	
		endcase
		
		mul = $signed(dat1_s) * $signed(dat2_s);
	end	

	always_comb begin
		
		if(floatop)begin

			aluout = result;
		end else begin
			case(aluop)
				4'd0 : aluout = in1 + in2;
				4'd1 : aluout = in1 - in2;
				4'd2 : aluout = in1 << in2[4:0];
				4'd3 : aluout = ($signed(in1) < $signed(in2))? 32'd1 : 32'd0;
				4'd4 : aluout = ($unsigned(in1) < $unsigned(in2)) ? 32'd1 : 32'd0;
				4'd5 : aluout = in1 ^ in2;
				4'd6 : aluout = in1 >> in2[4:0];
				4'd7 : aluout = $signed(in1) >>> in2[4:0];
				4'd8 : aluout = in1 | in2;
				4'd9 : aluout = in1 & in2;
				4'd10: aluout = mul[31:0];
				4'd11, 4'd12, 4'd13 : aluout = mul[63:32];
				4'd14 : aluout = {in2[19:0],12'd0};
				default : aluout = 32'd0;
			endcase
		end
	end

	always_comb begin
	
		fa_abs = {1'b0, in1[30:0]};
		fb_abs = {1'b0, in2[30:0]};
		comp = (in1[30:23] < in2[30:23])?1'b0:1'b1;
		fa_swap = comp ? in1 : in2;
		fb_swap = comp ? in2 : in1;
		fb_signed = fb_swap[31] ^ aluop[0];
		a_exp = fa_swap[30:23];
		b_exp = fb_swap[30:23];
		diff_exp = a_exp - b_exp;
		fix_a = {1'b1, fa_swap[22:0]};
		fix_b = {1'b1, fb_swap[22:0]};
		if(fa_swap[31])begin
			signed_a = -({1'b0, fix_a, 24'd0});
		end else begin
			signed_a = ({1'b0, fix_a, 24'd0});
		end
		if(fb_signed)begin
			signed_b = -({1'b0, fix_b, 24'd0});
		end else begin
			signed_b = {1'b0, fix_b, 24'd0};
		end
		shift_b = signed_b >>> diff_exp;
		sum = shift_b + signed_a;
		sign = sum[49];
		sum_abs = (sum[49]) ? -sum : sum;
		if(sum_abs[48])begin
			exp = a_exp + 8'd1;
			mant = sum_abs[47:25];
		end else begin
			exp = a_exp + {2'd0,normal} - 8'd47;
			case(normal)
				6'd47 : mant = sum_abs[46:24];
				6'd46 : mant = {sum_abs[45:24], 1'd0};
				6'd45 : mant = {sum_abs[44:24], 2'd0};
				6'd44 : mant = {sum_abs[43:24], 3'd0};
				6'd43 : mant = {sum_abs[42:24], 4'd0};
				6'd42 : mant = {sum_abs[41:24], 5'd0};
				6'd41 : mant = {sum_abs[40:24], 6'd0};
				6'd40 : mant = {sum_abs[39:24], 7'd0};
				6'd39 : mant = {sum_abs[38:24], 8'd0};
				6'd38 : mant = {sum_abs[37:24], 9'd0};
				6'd37 : mant = {sum_abs[36:24], 10'd0};
				6'd36 : mant = {sum_abs[35:24], 11'd0};
				6'd35 : mant = {sum_abs[34:24], 12'd0};
				6'd34 : mant = {sum_abs[33:24], 13'd0};
				6'd33 : mant = {sum_abs[32:24], 14'd0};
				6'd32 : mant = {sum_abs[31:24], 15'd0};
				6'd31 : mant = {sum_abs[30:24], 16'd0};
				6'd30 : mant = {sum_abs[29:24], 17'd0};
				6'd29 : mant = {sum_abs[28:24], 18'd0};
				6'd28 : mant = {sum_abs[27:24], 19'd0};
				6'd27 : mant = {sum_abs[26:24], 20'd0};
				6'd26 : mant = {sum_abs[25:24], 21'd0};
				default : mant = sum_abs[47:25];
			endcase
		end
		
		if(sum_abs[23:0] > 24'h8000_00)
			round = 1'b1;
		else if (sum_abs[23:0] == 24'h8000_00)
			round = sum_abs[24];
		else
			round = 1'b0;
		mantissa = mant + {22'd0,round};
		result = {sign, exp, mantissa};
		
	end
	always_comb begin
		normal = 6'd24;
		normal1 = 32'd42;
		normal2 = 32'd40;
		normal3 = 32'd36;
		normal4 = 32'd32;
		normal5 = 32'd28;
		normal6 = 32'd24;
		flag0 = 1'b0;
		flag1 = 1'b0;
		flag2 = 1'b0;
		flag3 = 1'b0;
		flag4 = 1'b0;
		for (int i = 42 ; i < 48; i = i + 1)begin
			if(sum_abs[i])begin
				normal1 = i;
				flag0 = 1'b1;
			end	
		end
		for (int j = 40 ; j < 42 ; j = j + 1)begin
			if(sum_abs[j])begin
				normal2 = j;
				flag1 = 1'b1;
			end
		end
		for (int k = 36 ; k < 40 ; k = k + 1)begin
			if(sum_abs[k])begin
				normal3 = k;
				flag2 = 1'b1;
			end
		end
		for (int l = 32 ; l < 36 ; l = l + 1)begin
			if(sum_abs[l])begin
				normal4 = l;
				flag3 = 1'b1;
			end
		end
		for (int m = 28 ; m < 32 ; m = m + 1)begin
			if(sum_abs[m])begin
				normal5 = m;
				flag4 = 1'b1;
			end
		end
		for (int n = 24 ; n < 28 ; n = n + 1)begin
			if(sum_abs[n])begin
				normal6 = n;
			end
		end
		if(flag0)
			normal = normal1[5:0];
		else if(flag1)
			normal = normal2[5:0];
		else if(flag2)
			normal = normal3[5:0];
		else if(flag3)
			normal = normal4[5:0];
		else if(flag4)
			normal = normal5[5:0];
		else 
			normal = normal6[5:0];

	end


endmodule
