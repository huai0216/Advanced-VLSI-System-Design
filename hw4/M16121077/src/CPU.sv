

module CPU(
	input clk,
	input rst,
	input [31:0] inst,
	input [31:0] ddata,
	input stall,
	input interrupt_dma,
	input interrupt_time,
	output logic read_im,
	output logic [31:0] iaddr,
	output logic memwrite,
	output logic memread,
	output logic [31:0] daddr,
	//data memory
	output logic [31:0] datawrite,
	output logic [31:0] bit_enable
);


logic [31:0] instruction_id;
logic [31:0] pcnext, pcin;

logic [31:0] inst_out_id;
wire [3:0] aluopfromctrl;
wire [31:0] data1fromreg, data2fromreg;
logic [31:0] data1;
logic [31:0] data2;
wire [3:0] aluop;
logic [31:0] aluout, datapc, aluresult;

wire [31:0] writedata;
wire [31:0] writeddata;
wire memtoregctrl, memtoregex, memtoregmem, memtoreg;
wire [4:0] rdex, rdmem, rd;
logic [31:0] data2frommux;
wire [1:0] data2src, data2srcctrl;
wire memwritefromctrl;
logic [31:0] writedatareg;
logic [31:0] extendimm, immdata;
wire [2:0] datatypefromctrl;
wire [2:0] datatypeex;
wire [2:0] datatypemem;
logic [31:0] pcnextex;

logic pcsrc;
wire regwrite, regwritectrl, regwriteex, regwritemem;
wire [1:0] writetypectrl, writetype;
logic [31:0] pc_buffer;
wire [31:0] pcdata;
logic [1:0] forwarda, forwardb;
logic jumpctrl, jump;
logic [2:0] comptype, comptypectrl;
wire [4:0] shamtdata;
logic branchctrl, branch, branch_check;
wire memreadctrl;
logic [31:0] idata;
logic load_use_hazard, delay_hazard;
logic [31:0] pcimm;
wire auipc, auipcctrl;
wire [1:0] regwritedatctrl, regwritedat;
wire pcwritedatctrl, pcwritedat;
logic [63:0] instret, totalcycle;
logic floatop, floatopctrl, floatwbmem, floatwb, floatwbctrl, floatrd1ctrl, floatrd2ctrl,floatwbex, floatrd1, floatrd2;
logic rdinstretctrl, highctrl, rdinstret, high;
logic [31:0] csrdata;
logic [63:0] csr_cnt;
logic first;
logic [31:0] datafromalu;
logic [31:0] dmdata;
logic [31:0] pcout;
logic branch_taken;
logic [31:0] csr_out;
logic write_csr_ctrl, write_csr_ex, write_csr;
logic [31:0] alu_csr_data;
logic wfi, wfi_ctrl;
logic [31:0] trap_pc;
logic interrupt_delay;
logic mret_out;
logic [31:0] mret_pc;
logic [15:0] sddata;

pc pc(
	.clk(clk),
	.rst(rst),
	.stall(stall),
	.wfi(wfi),
	.read_im(read_im),
	.pcin(pcnext),
	.first(first),
	.load_use_hazard(load_use_hazard),
	.pcout(pcout)
);



	

	always_ff@(posedge clk)begin
		if(rst)begin
			instret <= 64'd0;
			totalcycle <= 64'd0;
			first <= 1'b0;
			pc_buffer <= 32'd0;
		end else begin
			totalcycle <= totalcycle + 64'd1;
			if(stall || load_use_hazard || wfi || interrupt_time)
				pc_buffer <= pc_buffer;
			else
				pc_buffer <= iaddr;
			
			first <= 1'b1;
			if((branch_check && branch)||jump||load_use_hazard || stall)
				instret <= instret;
			else
				instret <= instret + 64'd1;
			
		end
	end



	


	always_comb begin
		case(memtoreg)
			1'b0 : writedatareg = writeddata;
			1'b1 : writedatareg = writedata;
		endcase		
	end
	always_comb begin
		case(forwarda)
			2'b00 : data1 = data1fromreg;
			2'b01 : data1 = writedatareg;
			2'b10 : data1 = aluresult;
			default : data1 = 32'd0;
		endcase
	end
	always_comb begin
		case(forwardb)
			2'b00 : data2frommux = data2fromreg; //data2frommux;
			2'b01 : data2frommux = writedatareg;
			2'b10 : data2frommux = alu_csr_data;
			default : data2frommux = 32'd0;
		endcase
	end
	always_comb begin
		case(data2src)
			2'd0 : data2 = data2frommux;
			2'd1 : data2 = immdata;
			2'd2 : data2 = {27'd0,shamtdata};
			2'd3 : data2 = csr_out;
		endcase
	end
	always_comb begin
		case(comptype)
			3'd0 : branch_check = (data1 == data2) ? 1'b1 : 1'b0; //EQ
			3'd1 : branch_check = (data1 != data2) ? 1'b1 : 1'b0; //NE
			3'd2 : branch_check = ($signed(data1) < $signed(data2)) ? 1'b1 : 1'b0; //LT
			3'd3 : branch_check = ~(($signed(data1)< $signed(data2)) ? 1'b1 : 1'b0); //GE
			3'd4 : branch_check = (data1 < data2) ? 1'b1 : 1'b0; //LTU
			3'd5 : branch_check = ~((data1 < data2) ? 1'b1 : 1'b0); //GEU
			default : branch_check = 1'b0;
		endcase
	end
	
	always_comb begin
		branch_taken = ((branch_check && branch) || jump);
		if(interrupt_delay)begin
			iaddr = trap_pc;
		end else if(mret_out)begin
			iaddr = mret_pc;
		end else if(branch_taken)begin
			iaddr = datapc;
		end else if(wfi) begin
			iaddr = pc_buffer;
		end else begin
			iaddr = pcout;
		end
		pcnext = iaddr + 32'd4;
	end
	always_comb begin
		if(branch_taken ||(!first) || interrupt_delay || mret_out)begin
			idata = 32'h0000_0093;
		end else if(delay_hazard || wfi)begin
			idata = inst_out_id;
		end else begin
			idata = inst;
		end
	end
	always_comb begin
		
		if(auipc)
			pcimm = {immdata[31:12],12'd0} + pcdata;
		else
			pcimm = pcdata + immdata;
		case(pcwritedat)
			1'b0 : datapc = pcimm;
			1'b1 : datapc = aluout;
		endcase
	end
	always_comb begin
		if(rdinstret)
			csr_cnt = instret - 64'd3;
		else 
			csr_cnt = totalcycle - 64'd2;
		if(high) 
			csrdata = csr_cnt[63:32];
		else 
			csrdata = csr_cnt[31:0];
	end
	always_comb begin
		case(idata[6:0])
			7'b0100011: extendimm = {{20{idata[31]}},idata[31:25],idata[11:7]};
			7'b0010111: extendimm = {idata[31:12], {12{idata[31]}}};
			7'b1100011: extendimm = {{20{idata[31]}}, idata[7], idata[30:25], idata[11:8],1'b0};
			7'b0110111: extendimm = {12'd0,idata[31:12]};
			7'b0100111: extendimm = {{20{idata[31]}}, idata[31:25],idata[11:7]};
			7'b1101111: extendimm = {{12{idata[31]}}, idata[19:12],idata[20],idata[30:21],1'b0};
			default : extendimm =  {{20{idata[31]}}, idata[31:20]};
		endcase
	end
	always_comb begin
		case(regwritedat)
			2'b00 : datafromalu = datapc;
			2'b01 : datafromalu = {immdata[19:0],12'd0};
			2'b10 : datafromalu = pcnextex;
			2'b11 : datafromalu = csr_out;
		endcase
	end
	always_comb begin
		daddr = datafromalu[31:0];
	end
	always_comb begin
		case(writetype) // 0 : full, 1 : byte, 2 : half
			2'b00 : begin
				datawrite = data2frommux;//  datawritemem
				bit_enable = 32'h0000_0000;
			end
			2'b01 : begin
				case(datafromalu[1:0])
					2'b00 : begin
						datawrite = data2frommux;
						bit_enable = 32'hffff_ff00;
					end
					2'b01 : begin
						datawrite = {16'd0, data2frommux[7:0], 8'd0};
						bit_enable = 32'hffff_00ff;
					end
					2'b10 : begin
						datawrite = {8'd0, data2frommux[7:0], 16'd0};
						bit_enable = 32'hff00_ffff; 
					end
					default : begin
						datawrite = {data2frommux[7:0], 24'd0};
						bit_enable = 32'h00ff_ffff;
					end
				endcase
			end
			2'b10 : begin
				case(datafromalu[1:0])
					2'b00 : begin
						datawrite = data2frommux;
						bit_enable = 32'hffff_0000;
					end
					2'b01 : begin
						datawrite = {8'd0, data2frommux[15:0], 8'd0};
						bit_enable = 32'hff00_00ff;
					end
					2'b10 : begin
						datawrite = {data2frommux[15:0], 16'd0};
						bit_enable = 32'h0000_ffff;
					end
					default : begin
						datawrite = 32'h0000_0000;
						bit_enable = 32'hffff_ffff;
					end
				endcase
			end
			default : begin
				datawrite = 32'h0000_0000;
				bit_enable = 32'hffff_ffff;
			end
		endcase
	end
	always_comb begin
		case(aluresult[1:0])
			2'b00 : sddata = ddata[15:0];
			2'b01 : sddata = ddata[23:8];
			2'b11 : sddata = {8'd0, ddata[31:24]};
			default : sddata = ddata[31:16];
		endcase

		case(datatypemem)
			3'd1 : dmdata = {{24{sddata[7]}},sddata[7:0]}; //bs
			3'd0 : dmdata = ddata; //all
			3'd2 : dmdata = {{16{sddata[15]}}, sddata[15:0]}; //hs
			3'd3 : dmdata = {24'd0,sddata[7:0]}; //bu
			3'd4 : dmdata = {16'd0,sddata[15:0]}; //hu
			default : dmdata = 32'd0;
		endcase
		if(write_csr)
			alu_csr_data = csr_out;
		else
			alu_csr_data = aluresult;
		

	end


CSR CSR(
	.clk(clk),
	.rst(rst),
	.stall(stall),
	.interrupt_dma(interrupt_dma),
	.interrupt_time(interrupt_time),
	.interrupt_delay(interrupt_delay),
	.inst_ex(instruction_id),
	.csr_write(write_csr_ex),
	.rs1_data(data1),
	.pc_buffer(pc_buffer),
	//
	.csr_out(csr_out),
	.wfi(wfi),
	.trap_pc(trap_pc),
	.mret_out(mret_out),
	.mret_pc(mret_pc)
);







IFID ifid(
	//input
	.clk(clk),
	.rst(rst),
	.stall(stall),
	.inst_in(idata),
	.wfi(wfi),
	.mret_out(mret_out),
	//output
	.inst_out(inst_out_id)
);

	
control control(
	.op(idata[6:0]),
	.funct3(idata[14:12]),
	.funct7(idata[31:25]),
	.instret(idata[21:20]),
	//output
	.aluop(aluopfromctrl),
	.memtoreg(memtoregctrl),
	.data2src(data2srcctrl),
	.memwrite(memwritefromctrl),
	.datatype(datatypefromctrl),
	.jump(jumpctrl),
	.regwrite(regwritectrl),
	.writetype(writetypectrl),
	.comptype(comptypectrl),
	.branch(branchctrl),
	.memread(memreadctrl),
	.auipc(auipcctrl),
	.regwritedat(regwritedatctrl),
	.pcwritedat(pcwritedatctrl),
	.floatop(floatopctrl),
	.floatrd2(floatrd2ctrl),
	.floatwb(floatwbctrl),
	.rdinstret(rdinstretctrl),
	.high(highctrl),
	.write_csr(write_csr_ctrl)
);



hazard hazard(
	.clk(clk),
	.rst(rst),
	.id_ex_memread(memread),
	.rs1(idata[19:15]),
	.rs2(idata[24:20]),
	.rd(rdex),
	.stall(stall),
	.wfi(wfi),
	//output
	.delay_hazard(delay_hazard),
	.load_use_hazard(load_use_hazard)
);


regfile regfile(
	// input
	.clk(clk),
	.rst(rst),
	.stall(stall),
	.readreg1(idata[19:15]),
	.readreg2(idata[24:20]),
	.regwrite(regwrite),// temp
	.writereg(rd),//temp
	.writedata(writedatareg),//temp
	.load_use_hazard(load_use_hazard),
	.floatrd1(floatopctrl),
	.floatrd2(floatrd2ctrl),
	.floatwb(floatwb),
	.interrupt_delay(interrupt_delay),
	.mret_out(mret_out),
	// output
	.readdata1(data1fromreg),
	.readdata2(data2fromreg)
);




IDEX idex(
	.clk(clk),
	.rst(rst),
	.ininstruction(idata),
	.indata2src(data2srcctrl),
	.inaluop(aluopfromctrl),
	.inmemtoreg(memtoregctrl),
	.inrd(idata[11:7]), //idata
	.inmemwrite(memwritefromctrl),
	.indatatype(datatypefromctrl),
	.inpcnext(iaddr),
	.inregwrite(regwritectrl),
	.inwritetype(writetypectrl),
	.injump(jumpctrl),
	.branch_taken(branch_taken),
	.inbranch(branchctrl),
	.inpc(pc_buffer),
	.inimme(extendimm),
	.inshamt(idata[24:20]),
	.inmemread(memreadctrl),
	.inregwritedat(regwritedatctrl),
	.inpcwritedat(pcwritedatctrl),
	.inauipc(auipcctrl),
	.infloatop(floatopctrl),
	.infloatwb(floatwbctrl),
	.load_use_hazard(load_use_hazard),
	.incomptype(comptypectrl),
	.inrdinstret(rdinstretctrl),
	.inhigh(highctrl),
	.inwrite_csr(write_csr_ctrl),
	.stall(stall),
	.wfi(wfi),
	.interrupt_delay(interrupt_delay),
	.mret_out(mret_out),
	//output
	.outinstruction(instruction_id),
	.outdata2src(data2src),
	.aluop(aluop),
	.outmemtoreg(memtoregex),
	.outrd(rdex),
	.outmemwrite(memwrite),
	.outdatatype(datatypeex),
	.outpcnext(pcnextex),
	.outregwrite(regwriteex),
	.outwritetype(writetype),
	.outjump(jump),
	.outbranch(branch),
	.outpc(pcdata),
	.outimme(immdata),
	.outshamt(shamtdata),
	.outmemread(memread),
	.outregwritedat(regwritedat),
	.outpcwritedat(pcwritedat),
	.outauipc(auipc),
	.outfloatop(floatop),
	.outfloatwb(floatwbex),
	.outcomptype(comptype),
	.outrdinstret(rdinstret),
	.outhigh(high),
	.outwrite_csr(write_csr_ex)
);


alu alu(
	.aluop(aluop),
	.in1(data1),
	.in2(data2),
	.floatop(floatop),
	//output
	.aluout(aluout)
);



EXMEM exmem(
	.clk(clk),
	.rst(rst),
	.indata(datafromalu),
	.inmemtoreg(memtoregex),
	.inrd(rdex),
	.indatatype(datatypeex),
	.inregwrite(regwriteex),
	.infloatwb(floatwbex),
	.inwrite_csr(write_csr_ex),
	.stall(stall),
	.wfi(wfi),
	.mret_out(mret_out),
	//output
	.aludata(aluresult),
	.outmemtoreg(memtoregmem),
	.outrd(rdmem),
	.outdatatype(datatypemem),
	.outregwrite(regwritemem),
	.outfloatwb(floatwbmem),
	.outwrite_csr(write_csr)
);


MEMWB memwb(
	.clk(clk),
	.rst(rst),
	.indata(alu_csr_data),
	.inmemtoreg(memtoregmem),
	.inrd(rdmem),
	.inddata(dmdata),
	.inregwrite(regwritemem),
	.infloatwb(floatwbmem),
	.stall(stall),
	//output
	.outdata(writedata), //from alu
	.memtoreg(memtoreg),
	.outrd(rd),
	.outddata(writeddata),
	.outregwrite(regwrite),
	.outfloatwb(floatwb)
);


forwarding forwarding(
	//input
	.clk(clk),
	.rst(rst),
	.ex_mem_rd(rdex),
	.mem_wb_rd(rdmem),
	.id_ex_rs1(idata[19:15]),
	.id_ex_rs2(idata[24:20]),
	.regwritemem(regwriteex),
	.regwritewb(regwritemem),
	.floatwbmem(floatwbex),
	.floatwb(floatwbmem),
	.floatrd1(floatopctrl),
	.floatrd2(floatrd2ctrl),
	.stall(stall),
	.wfi(wfi),
	//output
	.forwardinga(forwarda),
	.forwardingb(forwardb)
);



endmodule
