module tag_array_wrapper (
  input CK,
  input CS,
  input OE,
  input WEB,
  input BWEB,
  input [4:0] A,
  input [22:0] DI,
  output logic [45:0] DO
);
logic WEB0, WEB1;
logic [31:0] DO1, DO2;

	always_comb begin
		if(!WEB)begin
			WEB0 = OE;
			WEB1 = ~OE;
		end else begin
			WEB0 = 1'b1;
			WEB1 = 1'b1;
		end
		DO = {DO2[22:0],DO1[22:0]};
	end

  TS1N16ADFPCLLLVTA128X64M4SWSHOD_tag_array i_tag_array1 (
    .CLK        (CK),
    .A          (A),
    .CEB        (1'b0),  // chip enable, active LOW
    .WEB        (WEB0),  // write:LOW, read:HIGH
    .BWEB       ({32{BWEB}}),  // bitwise write enable write:LOW
    .D          ({9'd0,DI}),  // Data into RAM
    .Q          (DO1),  // Data out of RAM
    .RTSEL      (2'b01),
    .WTSEL      (2'b01),
    .SLP        (1'b0),
    .DSLP       (1'b0),
    .SD         (1'b0),
    .PUDELAY    ()
  );

  TS1N16ADFPCLLLVTA128X64M4SWSHOD_tag_array i_tag_array2 (
    .CLK        (CK),
    .A          (A),
    .CEB        (1'b0),  // chip enable, active LOW
    .WEB        (WEB1),  // write:LOW, read:HIGH
    .BWEB       ({32{BWEB}}),  // bitwise write enable write:LOW
    .D          ({9'd0,DI}),  // Data into RAM
    .Q          (DO2),  // Data out of RAM
    .RTSEL      (2'b01),
    .WTSEL      (2'b01),
    .SLP        (1'b0),
    .DSLP       (1'b0),
    .SD         (1'b0),
    .PUDELAY    ()
  );

endmodule
