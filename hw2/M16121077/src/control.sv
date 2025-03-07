module control(
	//input [31:0] inst,
	input [6:0] op,
	input [2:0] funct3,
	input [6:0] funct7,
	input [1:0] instret,
	output logic [3:0] aluop,
	output logic memtoreg, //0 : memdata, 1 : aludata
	output logic [1:0] data2src,
	output logic memwrite,
	output logic [2:0] datatype,
	output logic jump,
	output logic regwrite,
	output logic [1:0] writetype,
	output logic [2:0] comptype,
	output logic branch,
	output logic memread,
	output logic auipc,
	output logic [1:0] regwritedat,
	output logic pcwritedat,
	output logic floatop,
	output logic floatrd2,
	output logic floatwb,
	output logic rdinstret,
	output logic high,
	output logic csrsel
);

	always_comb begin
		memread = (op == 7'b0000011 || op == 7'b0000111);
		jump = ((op == 7'b1100111)||(op==7'b1101111));
		pcwritedat = ~(op == 7'b1100011 || op == 7'b0010111 || op == 7'b1101111); // pc + imm
		auipc = (op == 7'b0010111);
		
		if (op == 7'b0110111)begin
			regwritedat = 2'd1; //rd = imm
		end else if(op == 7'b1100111 || op == 7'b1101111) begin
			regwritedat = 2'd2; //rd = pc + 4
		end else if(op == 7'b1110011)begin
			regwritedat = 2'd3;
		end else begin
			regwritedat = 2'd0; //rd = pc+imm or alu
		end
		regwrite = (op == 7'b0110011 || op == 7'b0010011 || op == 7'b0000011 || op == 7'b1100111 || op ==7'b0010111 || op ==7'b1101111||op == 7'b0110111 || op == 7'b1110011 || op == 7'b0000111 || op == 7'b1010011);
		
		branch = (op == 7'b1100011);
		if(op == 7'b0010011 && (funct3 == 3'b001 || funct3 ==3'b101))begin
			data2src = 2'd2; //shamt
		end else if(op == 7'b0010011 || op == 7'b0000011 ||op == 7'b0100011 || op == 7'b1101111 || op == 7'b1100111 || op==7'b0100111 || op ==7'b0000111)begin
			data2src = 2'd1; //imm
		end else begin
			data2src = 2'd0; //rs2
		end
		memtoreg = ~(op == 7'b0000011 || op == 7'b0000111); //dm
		
		memwrite = (op == 7'b0100011 || op == 7'b0100111);
		if(op == 7'b0110011)begin
			case(funct7)
				7'b0000_000 : begin
					case(funct3)
						3'b000 : aluop = 4'd0; //ADD
						3'b001 : aluop = 4'd2; //SLL
						3'b010 : aluop = 4'd3; //SLT
						3'b011 : aluop = 4'd4;//SLTU
						3'b100 : aluop = 4'd5;//XOR
						3'b101 : aluop = 4'd6;//SRL
						3'b110 : aluop = 4'd8;//OR
						3'b111 : aluop = 4'd9;//AND
					endcase
				end
				7'b0100_000 : begin
					aluop = (funct3==3'b000)?4'd1:4'd7; //MINUS:SRA
				end	
				7'b0000_001 : begin
					case(funct3)
						3'b000 : aluop = 4'd10; // MULL
						3'b001 : aluop = 4'd11; //MULH
						3'b011 : aluop = 4'd12; //MULHU
						3'b010 : aluop = 4'd13;//MULHSU
						default :aluop = 4'd11;//MULL
					endcase
				end
				default : aluop = 4'd0; //ADD
			endcase
		end else if(op == 7'b0010011) begin
			case(funct3)
				3'b000 : aluop = 4'd0; //ADD
				3'b001 : aluop = 4'd2; //SLL
				3'b010 : aluop = 4'd3; //SLT
				3'b011 : aluop = 4'd4;//SLTU
				3'b100 : aluop = 4'd5; //XOR
				3'b101 : aluop = (funct7 == 7'b0100000)?4'd7:4'd6; //SRA:SRL
				3'b110 : aluop = 4'd8; //OR
				3'b111 : aluop = 4'd9;//AND
			endcase
		end else if(op == 7'b0110111)begin
			aluop = 4'd14; //LUI
		end else if(op == 7'b1010011 && funct7[6:2] == 5'b00001)begin
			aluop = 4'd1; //MINUS
		end else begin
			aluop = 4'd0; //ADD
		end
		if(op == 7'b1100011)begin
			case(funct3)
				3'd0 : comptype = 3'd0; //EQ
				3'd1 : comptype = 3'd1; //NE
				3'd4 : comptype = 3'd2; //LT
				3'd5 : comptype = 3'd3; //GE
				3'd6 : comptype = 3'd4;//LTU
				3'd7 : comptype = 3'd5;//GEU
				default : comptype = 3'd0;//EQ
			endcase
		end else begin
			comptype = 3'd6;
		end
		if(op == 7'b0000011)begin
			case(funct3)
				3'b000 : datatype = 3'd1; //bs
				3'b010 : datatype = 3'd0; //all
				3'b001 : datatype = 3'd2; //hs
				3'b100 : datatype = 3'd3; //bu
				3'b101 : datatype = 3'd4; //hu
				default : datatype =3'd1;
			endcase
		end else begin
			datatype = 3'd0;
		end
		if(op == 7'b0100011)begin
			case(funct3)
				3'b010 : writetype = 2'd0; //write word
				3'b000 : writetype = 2'd1; //write byte
				3'b001 : writetype = 2'd2; //write half
				default : writetype = 2'd0;
			endcase
		end else begin
			writetype = 2'd0;
		end
		floatop = (op == 7'b1010011);
		floatrd2 = (op == 7'b1010011 || op == 7'b0100111);
		floatwb = (op == 7'b0000111 || op == 7'b1010011);
		rdinstret = (op == 7'b1110011 && instret == 2'b10);
		high = (op == 7'b1110011 && funct7[2]);
		csrsel = (op == 7'b1110011);
		
	end

endmodule
