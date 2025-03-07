

module CHIP(
  input            cpu_clk,
  input            axi_clk,
  input            rom_clk,
  input            dram_clk,
  input            cpu_rst,
  input            axi_rst,
  input            rom_rst,
  input            dram_rst,
  input  [   31:0] ROM_out,
  input  [   31:0] DRAM_Q,
  output           ROM_read,
  output           ROM_enable,
  output [   11:0] ROM_address,
  output           DRAM_CSn,
  output [    3:0] DRAM_WEn,
  output           DRAM_RASn,
  output           DRAM_CASn,
  input            DRAM_valid, 
  output [   10:0] DRAM_A,
  output [   31:0] DRAM_D
);

wire           cpu_clk_i;
wire           cpu_rst_i;
wire           axi_clk_i;
wire           axi_rst_i;
wire           rom_clk_i;
wire           rom_rst_i;
wire           dram_clk_i;
wire           dram_rst_i;
wire [   31:0] ROM_out_i;
wire           ROM_read_o;
wire           ROM_enable_o;
wire [   11:0] ROM_address_o;
wire [   31:0] DRAM_Q_i;
wire           DRAM_CSn_o;
wire [    3:0] DRAM_WEn_o;
wire           DRAM_RASn_o;
wire           DRAM_CASn_o;
wire [   10:0] DRAM_A_o;
wire [   31:0] DRAM_D_o;
wire           DRAM_valid_i;


//core instance
top u_TOP(
	.cpu_clk		(cpu_clk_i      ), // CPU CLOCK DOMAIN
	.cpu_rst		(cpu_rst_i      ),
    .axi_clk		(axi_clk_i      ),
    .axi_rst		(axi_rst_i      ),
	.rom_clk        (rom_clk_i      ),//rom
    .rom_rst        (rom_rst_i      ),
    .ROM_out        (ROM_out_i      ),//rom
    .ROM_read       (ROM_read_o     ),
    .ROM_enable     (ROM_enable_o   ),
    .ROM_address    (ROM_address_o  ),
	.dram_clk       (dram_clk_i     ),//DRAM
	.dram_rst       (dram_rst_i     ),
    .DRAM_valid     (DRAM_valid_i   ),
    .DRAM_Q         (DRAM_Q_i       ),
    .DRAM_CSn       (DRAM_CSn_o     ),
    .DRAM_WEn       (DRAM_WEn_o     ),
    .DRAM_RASn      (DRAM_RASn_o    ),
    .DRAM_CASn      (DRAM_CASn_o    ),
    .DRAM_A         (DRAM_A_o       ),
    .DRAM_D         (DRAM_D_o       )
);


//iopad example
//upper 37
PDCDG_V ipad_DRAM_Q0    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[0 ]), .C(DRAM_Q_i[0 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q1    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[1 ]), .C(DRAM_Q_i[1 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q2    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[2 ]), .C(DRAM_Q_i[2 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q3    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[3 ]), .C(DRAM_Q_i[3 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q4    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[4 ]), .C(DRAM_Q_i[4 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q5    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[5 ]), .C(DRAM_Q_i[5 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q6    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[6 ]), .C(DRAM_Q_i[6 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q7    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[7 ]), .C(DRAM_Q_i[7 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q8    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[8 ]), .C(DRAM_Q_i[8 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q9    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[9 ]), .C(DRAM_Q_i[9 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q10    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[10 ]), .C(DRAM_Q_i[10 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q11    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[11 ]), .C(DRAM_Q_i[11 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q12    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[12 ]), .C(DRAM_Q_i[12 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q13    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[13 ]), .C(DRAM_Q_i[13 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q14    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[14 ]), .C(DRAM_Q_i[14 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q15    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[15 ]), .C(DRAM_Q_i[15 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q16    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[16 ]), .C(DRAM_Q_i[16 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q17    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[17 ]), .C(DRAM_Q_i[17 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q18    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[18 ]), .C(DRAM_Q_i[18 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q19    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[19 ]), .C(DRAM_Q_i[19 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q20    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[20 ]), .C(DRAM_Q_i[20 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q21    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[21 ]), .C(DRAM_Q_i[21 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q22    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[22 ]), .C(DRAM_Q_i[22 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q23    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[23 ]), .C(DRAM_Q_i[23 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q24    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[24 ]), .C(DRAM_Q_i[24 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q25    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[25 ]), .C(DRAM_Q_i[25 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q26    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[26 ]), .C(DRAM_Q_i[26 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q27    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[27 ]), .C(DRAM_Q_i[27 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q28    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[28 ]), .C(DRAM_Q_i[28 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q29    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[29 ]), .C(DRAM_Q_i[29 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q30    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[30 ]), .C(DRAM_Q_i[30 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_Q31    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_Q[31 ]), .C(DRAM_Q_i[31 ])); ///DRAM_Q
PDCDG_V ipad_DRAM_valid  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(DRAM_valid), .C(DRAM_valid_i)); ///DRAM_Q
PDCDG_V ipad_dram_clk    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(dram_clk), .C(dram_clk_i)); ///DRAM_Q
PDCDG_V ipad_dram_rst    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(dram_rst), .C(dram_rst_i)); ///DRAM_Q
PDCDG_V ipad_axi_clk    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(axi_clk), .C(axi_clk_i)); ///DRAM_Q
PDCDG_V ipad_axi_rst    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(axi_rst), .C(axi_rst_i)); ///DRAM_Q

//left 32
PDCDG_H opad_DRAM_CSn  (.OEN(1'b0), .IE(1'b0), .I(DRAM_CSn_o     ), .PAD(DRAM_CSn    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_WEn0  (.OEN(1'b0), .IE(1'b0), .I(DRAM_WEn_o[0]     ), .PAD(DRAM_WEn[0]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_WEn1  (.OEN(1'b0), .IE(1'b0), .I(DRAM_WEn_o[1]     ), .PAD(DRAM_WEn[1]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_WEn2  (.OEN(1'b0), .IE(1'b0), .I(DRAM_WEn_o[2]     ), .PAD(DRAM_WEn[2]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_WEn3  (.OEN(1'b0), .IE(1'b0), .I(DRAM_WEn_o[3]     ), .PAD(DRAM_WEn[3]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_RASn  (.OEN(1'b0), .IE(1'b0), .I(DRAM_RASn_o     ), .PAD(DRAM_RASn    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_CASn  (.OEN(1'b0), .IE(1'b0), .I(DRAM_CASn_o     ), .PAD(DRAM_CASn    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A0  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[0]     ), .PAD(DRAM_A[0]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A1  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[1]     ), .PAD(DRAM_A[1]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A2  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[2]     ), .PAD(DRAM_A[2]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A3  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[3]     ), .PAD(DRAM_A[3]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A4  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[4]     ), .PAD(DRAM_A[4]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A5  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[5]     ), .PAD(DRAM_A[5]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A6  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[6]     ), .PAD(DRAM_A[6]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A7  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[7]     ), .PAD(DRAM_A[7]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A8  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[8]     ), .PAD(DRAM_A[8]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A9  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[9]     ), .PAD(DRAM_A[9]    ), .C());  ///DRAM control
PDCDG_H opad_DRAM_A10  (.OEN(1'b0), .IE(1'b0), .I(DRAM_A_o[10]     ), .PAD(DRAM_A[10]    ), .C());  ///DRAM control
PDCDG_H opad_ROM_address0  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[0]     ), .PAD(ROM_address[0]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address1  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[1]     ), .PAD(ROM_address[1]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address2  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[2]     ), .PAD(ROM_address[2]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address3  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[3]     ), .PAD(ROM_address[3]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address4  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[4]     ), .PAD(ROM_address[4]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address5  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[5]     ), .PAD(ROM_address[5]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address6  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[6]     ), .PAD(ROM_address[6]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address7  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[7]     ), .PAD(ROM_address[7]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address8  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[8]     ), .PAD(ROM_address[8]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address9  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[9]     ), .PAD(ROM_address[9]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address10  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[10]     ), .PAD(ROM_address[10]    ), .C());  ///ROM control
PDCDG_H opad_ROM_address11  (.OEN(1'b0), .IE(1'b0), .I(ROM_address_o[11]     ), .PAD(ROM_address[11]    ), .C());  ///ROM control
PDCDG_H opad_ROM_read  (.OEN(1'b0), .IE(1'b0), .I(ROM_read_o   ), .PAD(ROM_read    ), .C());  ///ROM control
PDCDG_H opad_ROM_enable  (.OEN(1'b0), .IE(1'b0), .I(ROM_enable_o     ), .PAD(ROM_enable    ), .C());  ///ROM control

//bottom 32
PDCDG_V opad_DRAM_D0  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[0 ]  ), .PAD(DRAM_D[0]  ), .C());
PDCDG_V opad_DRAM_D1  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[1 ]  ), .PAD(DRAM_D[1]  ), .C());
PDCDG_V opad_DRAM_D2  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[2 ]  ), .PAD(DRAM_D[2]  ), .C());
PDCDG_V opad_DRAM_D3  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[3 ]  ), .PAD(DRAM_D[3]  ), .C());
PDCDG_V opad_DRAM_D4  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[4 ]  ), .PAD(DRAM_D[4]  ), .C());
PDCDG_V opad_DRAM_D5  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[5 ]  ), .PAD(DRAM_D[5]  ), .C());
PDCDG_V opad_DRAM_D6  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[6 ]  ), .PAD(DRAM_D[6]  ), .C());
PDCDG_V opad_DRAM_D7  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[7 ]  ), .PAD(DRAM_D[7]  ), .C());
PDCDG_V opad_DRAM_D8  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[8 ]  ), .PAD(DRAM_D[8]  ), .C());
PDCDG_V opad_DRAM_D9  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[9 ]  ), .PAD(DRAM_D[9]  ), .C());
PDCDG_V opad_DRAM_D10  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[10 ]  ), .PAD(DRAM_D[10]  ), .C());
PDCDG_V opad_DRAM_D11  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[11 ]  ), .PAD(DRAM_D[11]  ), .C());
PDCDG_V opad_DRAM_D12  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[12 ]  ), .PAD(DRAM_D[12]  ), .C());
PDCDG_V opad_DRAM_D13  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[13 ]  ), .PAD(DRAM_D[13]  ), .C());
PDCDG_V opad_DRAM_D14  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[14 ]  ), .PAD(DRAM_D[14]  ), .C());
PDCDG_V opad_DRAM_D15  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[15 ]  ), .PAD(DRAM_D[15]  ), .C());
PDCDG_V opad_DRAM_D16  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[16 ]  ), .PAD(DRAM_D[16]  ), .C());
PDCDG_V opad_DRAM_D17  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[17 ]  ), .PAD(DRAM_D[17]  ), .C());
PDCDG_V opad_DRAM_D18  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[18 ]  ), .PAD(DRAM_D[18]  ), .C());
PDCDG_V opad_DRAM_D19  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[19 ]  ), .PAD(DRAM_D[19]  ), .C());
PDCDG_V opad_DRAM_D20  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[20 ]  ), .PAD(DRAM_D[20]  ), .C());
PDCDG_V opad_DRAM_D21  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[21 ]  ), .PAD(DRAM_D[21]  ), .C());
PDCDG_V opad_DRAM_D22  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[22 ]  ), .PAD(DRAM_D[22]  ), .C());
PDCDG_V opad_DRAM_D23  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[23 ]  ), .PAD(DRAM_D[23]  ), .C());
PDCDG_V opad_DRAM_D24  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[24 ]  ), .PAD(DRAM_D[24]  ), .C());
PDCDG_V opad_DRAM_D25  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[25 ]  ), .PAD(DRAM_D[25]  ), .C());
PDCDG_V opad_DRAM_D26  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[26 ]  ), .PAD(DRAM_D[26]  ), .C());
PDCDG_V opad_DRAM_D27  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[27 ]  ), .PAD(DRAM_D[27]  ), .C());
PDCDG_V opad_DRAM_D28  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[28 ]  ), .PAD(DRAM_D[28]  ), .C());
PDCDG_V opad_DRAM_D29  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[29 ]  ), .PAD(DRAM_D[29]  ), .C());
PDCDG_V opad_DRAM_D30  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[30 ]  ), .PAD(DRAM_D[30]  ), .C());
PDCDG_V opad_DRAM_D31  (.OEN(1'b0), .IE(1'b0), .I(DRAM_D_o[31 ]  ), .PAD(DRAM_D[31]  ), .C());



///right 36
PDCDG_H ipad_ROM_out0  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[0 ]), .C(ROM_out_i[0 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out1  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[1 ]), .C(ROM_out_i[1 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out2  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[2 ]), .C(ROM_out_i[2 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out3  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[3 ]), .C(ROM_out_i[3 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out4  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[4 ]), .C(ROM_out_i[4 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out5  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[5 ]), .C(ROM_out_i[5 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out6  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[6 ]), .C(ROM_out_i[6 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out7  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[7 ]), .C(ROM_out_i[7 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out8  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[8 ]), .C(ROM_out_i[8 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out9  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[9 ]), .C(ROM_out_i[9 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out10  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[10 ]), .C(ROM_out_i[10 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out11  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[11 ]), .C(ROM_out_i[11 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out12  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[12 ]), .C(ROM_out_i[12 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out13  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[13 ]), .C(ROM_out_i[13 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out14  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[14 ]), .C(ROM_out_i[14 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out15  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[15 ]), .C(ROM_out_i[15 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out16  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[16 ]), .C(ROM_out_i[16 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out17  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[17 ]), .C(ROM_out_i[17 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out18  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[18 ]), .C(ROM_out_i[18 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out19  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[19 ]), .C(ROM_out_i[19 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out20  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[20 ]), .C(ROM_out_i[20 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out21  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[21 ]), .C(ROM_out_i[21 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out22  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[22 ]), .C(ROM_out_i[22 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out23  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[23 ]), .C(ROM_out_i[23 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out24  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[24 ]), .C(ROM_out_i[24 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out25  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[25 ]), .C(ROM_out_i[25 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out26  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[26 ]), .C(ROM_out_i[26 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out27  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[27 ]), .C(ROM_out_i[27 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out28  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[28 ]), .C(ROM_out_i[28 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out29  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[29 ]), .C(ROM_out_i[29 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out30  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[30 ]), .C(ROM_out_i[30 ])); ///DRAM_Q
PDCDG_H ipad_ROM_out31  (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(ROM_out[31 ]), .C(ROM_out_i[31 ])); ///DRAM_Q
PDCDG_H ipad_rom_clk    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(rom_clk), .C(rom_clk_i)); ///DRAM_Q
PDCDG_H ipad_rom_rst    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(rom_rst), .C(rom_rst_i)); ///DRAM_Q
PDCDG_H ipad_cpu_clk    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(cpu_clk), .C(cpu_clk_i)); ///DRAM_Q
PDCDG_H ipad_cpu_rst    (.OEN(1'b1), .IE(1'b1), .I(1'b0), .PAD(cpu_rst), .C(cpu_rst_i)); ///DRAM_Q


endmodule
