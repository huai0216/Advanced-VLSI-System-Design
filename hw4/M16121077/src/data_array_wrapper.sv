module data_array_wrapper (
  input CK,
  input CS, 
  input OE,
  input WEB,
  input [15:0] BWEB,
  input [4:0] A,
  input [127:0] DI,
  output logic [127:0] DO
);

logic [63:0] DI1_1, DI1_2, DI2_1, DI2_2;
logic [63:0] DO1_1, DO1_2, DO2_1, DO2_2;
logic WEB1, WEB2;
logic [63:0] BWEB_H, BWEB_L;
	always_comb begin
		if(OE)begin
			DO = {DO2_2, DO2_1};
			
		end else begin
			DO = {DO1_2, DO1_1};
		end
		DI1_1 = DI[63:0];
		DI2_1 = DI[63:0];
		DI1_2 = DI[127:64];
		DI2_2 = DI[127:64];
		if(!WEB)begin
			WEB1 = OE;
			WEB2 = ~OE;
		end else begin
			WEB1 = 1'b1;
			WEB2 = 1'b1;
		end
		BWEB_L = {{8{BWEB[7]}},{8{BWEB[6]}}, {8{BWEB[5]}}, {8{BWEB[4]}}, {8{BWEB[3]}}, {8{BWEB[2]}}, {8{BWEB[1]}},{8{BWEB[0]}}};
		BWEB_H = {{8{BWEB[15]}},{8{BWEB[14]}}, {8{BWEB[13]}}, {8{BWEB[12]}}, {8{BWEB[11]}}, {8{BWEB[10]}}, {8{BWEB[9]}},{8{BWEB[8]}}};
	end


  TS1N16ADFPCLLLVTA128X64M4SWSHOD_data_array i_data_array1_1 (
    .CLK        (CK),
    .A          (A),
    .CEB        (1'b0),  // chip enable, active LOW
    .WEB        (WEB1),  // write:LOW, read:HIGH
    .BWEB       (BWEB_L),  // bitwise write enable write:LOW
    .D          (DI1_1),  // Data into RAM
    .Q          (DO1_1),  // Data out of RAM
    .RTSEL      (2'b01),
    .WTSEL      (2'b01),
    .SLP        (1'b0),
    .DSLP       (1'b0),
    .SD         (1'b0),
    .PUDELAY    ()
  );
  
  
    TS1N16ADFPCLLLVTA128X64M4SWSHOD_data_array i_data_array1_2 (
    .CLK        (CK),
    .A          (A),
    .CEB        (1'b0),  // chip enable, active LOW
    .WEB        (WEB1),  // write:LOW, read:HIGH
    .BWEB       (BWEB_H),  // bitwise write enable write:LOW
    .D          (DI1_2),  // Data into RAM
    .Q          (DO1_2),  // Data out of RAM
    .RTSEL      (2'b01),
    .WTSEL      (2'b01),
    .SLP        (1'b0),
    .DSLP       (1'b0),
    .SD         (1'b0),
    .PUDELAY    ()
  );

  TS1N16ADFPCLLLVTA128X64M4SWSHOD_data_array i_data_array2_1 (
    .CLK        (CK),
    .A          (A),
    .CEB        (1'b0),  // chip enable, active LOW
    .WEB        (WEB2),  // write:LOW, read:HIGH
    .BWEB       (BWEB_L),  // bitwise write enable write:LOW
    .D          (DI2_1),  // Data into RAM
    .Q          (DO2_1),  // Data out of RAM
    .RTSEL      (2'b01),
    .WTSEL      (2'b01),
    .SLP        (1'b0),
    .DSLP       (1'b0),
    .SD         (1'b0),
    .PUDELAY    ()
  );
  
  TS1N16ADFPCLLLVTA128X64M4SWSHOD_data_array i_data_array2_2 (
    .CLK        (CK),
    .A          (A),
    .CEB        (1'b0),  // chip enable, active LOW
    .WEB        (WEB2),  // write:LOW, read:HIGH
    .BWEB       (BWEB_H),  // bitwise write enable write:LOW
    .D          (DI2_2),  // Data into RAM
    .Q          (DO2_2),  // Data out of RAM
    .RTSEL      (2'b01),
    .WTSEL      (2'b01),
    .SLP        (1'b0),
    .DSLP       (1'b0),
    .SD         (1'b0),
    .PUDELAY    ()
  );


endmodule
