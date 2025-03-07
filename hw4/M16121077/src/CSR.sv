module CSR(
	input clk,
	input rst,
	input [31:0] inst_ex,
	input [31:0] rs1_data,
	input csr_write,
	input stall,
	input interrupt_dma,
	input interrupt_time,
	input [31:0] pc_buffer,
	output logic interrupt_delay,
	//output logic interrupt_time_delay,
	output logic [31:0] csr_out,
	output logic wfi,
	output logic [31:0] trap_pc,
	output logic [31:0] mret_pc,
	output logic mret_out
);

logic [31:0] mstatus;
logic [31:0] mie;
logic [31:0] mtvec;
logic [31:0] mepc;
logic [31:0] mip;
logic [31:0] uimm;
logic [11:0] csr_imm;
logic [4:0] imm;
logic [2:0] funct3;
logic [4:0] rd;

localparam [31:0] wfi_instr = 32'b0001_0000_0101_0000_0000_0000_0111_0011;
localparam [31:0] mret_instr = 32'b0011_0000_0010_0000_0000_0000_0111_0011;


	always_comb begin
		
		csr_imm = inst_ex[31:20];
		imm = inst_ex[19:15];
		uimm = {27'd0,imm};
		funct3 = inst_ex[14:12];
		mtvec = 32'h0001_0000;
		trap_pc = {mtvec[31:2], 2'b00};
		mret_pc = mepc;
		rd = inst_ex[11:7];
	end

	always_ff@(posedge clk)begin
		if(rst)begin
			mstatus <= 32'd0;
			mie <= 32'd0;
			mepc <= 32'd0;
			mip <= 32'd0;
			csr_out <= 32'd0;
			interrupt_delay <= 1'b0;
			mret_out <= 1'b0;
		end else begin
			if(stall)begin
				mstatus <= mstatus;
				mie <= mie;
				mepc <= mepc;
				mip <= mip;
				csr_out <= csr_out;
				interrupt_delay <= interrupt_delay;
				mret_out <= mret_out;
			end else begin
				interrupt_delay <= (interrupt_dma | interrupt_time);
				case(csr_imm)
					12'h300 : begin
						csr_out <= mstatus;
					end
					12'h304 : begin
						csr_out <= mie;
					end
					12'h305 : begin //mtvec
						csr_out <= mtvec;
					end
					12'h341 : begin
						csr_out <= mepc;
					end
					12'h344 : begin
						csr_out <= mip;
					end
					default : csr_out <= 32'd0;
				endcase
				if((interrupt_dma || interrupt_time) && inst_ex == wfi_instr)begin				
					mepc <= pc_buffer;
					mstatus[7] <= mstatus[3];
					mstatus[3] <= 1'b0;
					mstatus[12:11] <= 2'b11;
					mret_out <= 1'b0;
				end else if(interrupt_dma || interrupt_time)begin
					mepc <= pc_buffer + 32'd4;
					mstatus[7] <= mstatus[3];
					mstatus[3] <= 1'b0;
					mstatus[12:11] <= 2'b11;
					mret_out <= 1'b0;
				end else if(inst_ex == mret_instr)begin
					mepc <= mepc;
					mstatus[7] <= 1'b1;
					mstatus[3] <= mstatus[7];
					mstatus[12:11] <= 2'b11;
					mret_out <= 1'b1;
				end else if(csr_write)begin
					mret_out <= 1'b0;
					mip[11] <= interrupt_dma;
					mip[7] <= 1'b0;
						case(csr_imm)
							12'h300 : begin
								case(funct3)
									3'b001 : begin //CSRRW
										mstatus[3] <= rs1_data[3];
										mstatus[7] <= rs1_data[7];
										mstatus[12:11] <= rs1_data[12:11];
									end
									3'b010 : begin // CSRRS
										mstatus[3] <= mstatus[3] | rs1_data[3];
										mstatus[7] <= mstatus[7] | rs1_data[7];
										mstatus[12:11] <= mstatus[12:11] | rs1_data[12:11];
									end
									3'b011 : begin // CSRRC
										mstatus[3] <= mstatus[3] & (~rs1_data[3]);
										mstatus[7] <= mstatus[7] & (~rs1_data[7]);
										mstatus[12:11] <= mstatus[12:11] & (~rs1_data[12:11]);
									end
									3'b101 : begin // CSRRWI
										mstatus[3] <= uimm[3];
										mstatus[7] <= uimm[7];
										mstatus[12:11] <= uimm[12:11];
									end
									3'b110 : begin // CSRRSI
										if(uimm > 32'd0)begin
											mstatus[3] <= mstatus[3] | uimm[3];
											mstatus[7] <= mstatus[7] | uimm[7];
											mstatus[12:11] <= mstatus[12:11] | uimm[12:11];
										end 
									end
									3'b111 : begin // CSRRCI
										if(uimm > 32'd0)begin
											mstatus[3] <= mstatus[3] & (~uimm[3]);
											mstatus[7] <= mstatus[7] & (~uimm[7]);
											mstatus[12:11] <= mstatus[12:11] & (~uimm[12:11]);
										end
									end
								endcase
							end
							12'h304 : begin
								case(funct3)
									3'b001 : begin //CSRRW
										mie[7] <= rs1_data[7];
										mie[11] <= rs1_data[11];
									end
									3'b010 : begin // CSRRS
										mie[7] <= mie[7] | rs1_data[7];
										mie[11] <= mie[11] | rs1_data[11];
									end
									3'b011 : begin // CSRRC
										mie[7] <= mie[7] & (~rs1_data[7]);
										mie[11] <= mie[11] & (~rs1_data[11]);
									end
									3'b101 : begin // CSRRWI
										mie[7] <= uimm[7];
										mie[11] <= uimm[11];
									end
									3'b110 : begin // CSRRSI
										if(uimm > 32'd0)begin
											mie[7] <= mie[7] | uimm[7];
											mie[11] <= mie[11] | uimm[11];
										end 
									end
									3'b111 : begin // CSRRCI
										if(uimm > 32'd0)begin
											mie[7] <= mie[7] & (~uimm[7]);
											mie[11] <= mie[11] & (~uimm[11]);
										end
									end
								endcase
							end
							12'h341 : begin
								case(funct3)
									3'b001 : begin //CSRRW
										mepc <= rs1_data;
									end
									3'b010 : begin // CSRRS
										mepc <= mepc | rs1_data;
									end
									3'b011 : begin // CSRRC
										mepc <= mepc & (~rs1_data);
									end
									3'b101 : begin // CSRRWI
										mepc <= uimm;
									end
									3'b110 : begin // CSRRSI
										if(uimm > 32'd0)begin
											mepc <= mepc | uimm;
										end 
									end
									3'b111 : begin // CSRRCI
										if(uimm > 32'd0)begin
											mepc <= mepc & (~uimm);
										end
									end
								endcase
							end
							
						endcase
				
				end else begin
					mret_out <= 1'b0;
				end
			end
		end
	end
	always_comb begin
		if(inst_ex == wfi_instr && (!interrupt_dma)) wfi = 1'b1;
		else wfi = 1'b0;
	end




endmodule
