//////////////////////////////////////////////////////////////////////
//          ██╗       ██████╗   ██╗  ██╗    ██████╗            		//
//          ██║       ██╔══█║   ██║  ██║    ██╔══█║            		//
//          ██║       ██████║   ███████║    ██████║            		//
//          ██║       ██╔═══╝   ██╔══██║    ██╔═══╝            		//
//          ███████╗  ██║  	    ██║  ██║    ██║  	           		//
//          ╚══════╝  ╚═╝  	    ╚═╝  ╚═╝    ╚═╝  	           		//
//                                                             		//
// 	2024 Advanced VLSI System Design, advisor: Lih-Yih, Chiou		//
//                                                             		//
//////////////////////////////////////////////////////////////////////
//                                                             		//
// 	Autor: 			Cheng_Hong Pai (Justin)				  	   		//
//	Filename:		data_aray_rtl.sv                          		//
//	Description:	RTL model of 									//
//					tag_array64X22 SRAM macro  	//
//					no timing information included, unsynthesizable	//
// 	Date:			2024/09/28								   		//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////
module TS1N16ADFPCLLLVTA128X64M4SWSHOD_tag_array (
	SLP,
    DSLP,
    SD,
    PUDELAY,
    CLK, CEB, WEB,
    A, D,
    BWEB,
    RTSEL,
    WTSEL,
    Q);
	
	//parameter Words 	= 736;
	parameter Bits 		= 32;
	parameter Bytes	    = 1;
	parameter numRow    = 32;
	parameter numCM     = 1;	
	
	//=== IO Ports ===//

	// Normal Mode Input
	input SLP;
	input DSLP;
	input SD;
	input CLK;
	input CEB;
	input WEB;
	input [4:0] A;
	input [31:0] D;
	input [31:0] BWEB;


	// Data Output
	output logic [31:0] Q;
	output PUDELAY;


	// Test Mode
	input [1:0] RTSEL;
	input [1:0] WTSEL;
	
	
	logic	[Bytes*Bits-1:0] 	MEMORY [numRow][numCM];
	logic   [Bytes*Bits-1:0]    latched_DO;   
	
	assign PUDELAY = 1'b0;
	
	
always @(posedge CLK) begin
	if(~CEB) begin
		if (~WEB) begin
			if(~BWEB[0]) MEMORY[A/numCM][A%numCM][0] <= D[0];
			if(~BWEB[1]) MEMORY[A/numCM][A%numCM][1] <= D[1];
			if(~BWEB[2]) MEMORY[A/numCM][A%numCM][2] <= D[2];
			if(~BWEB[3]) MEMORY[A/numCM][A%numCM][3] <= D[3];
			if(~BWEB[4]) MEMORY[A/numCM][A%numCM][4] <= D[4];
			if(~BWEB[5]) MEMORY[A/numCM][A%numCM][5] <= D[5];
			if(~BWEB[6]) MEMORY[A/numCM][A%numCM][6] <= D[6];
			if(~BWEB[7]) MEMORY[A/numCM][A%numCM][7] <= D[7];
			if(~BWEB[8]) MEMORY[A/numCM][A%numCM][8] <= D[8];
			if(~BWEB[9]) MEMORY[A/numCM][A%numCM][9] <= D[9];
			if(~BWEB[10]) MEMORY[A/numCM][A%numCM][10] <= D[10];
			if(~BWEB[11]) MEMORY[A/numCM][A%numCM][11] <= D[11];
			if(~BWEB[12]) MEMORY[A/numCM][A%numCM][12] <= D[12];
			if(~BWEB[13]) MEMORY[A/numCM][A%numCM][13] <= D[13];
			if(~BWEB[14]) MEMORY[A/numCM][A%numCM][14] <= D[14];
			if(~BWEB[15]) MEMORY[A/numCM][A%numCM][15] <= D[15];
			if(~BWEB[16]) MEMORY[A/numCM][A%numCM][16] <= D[16];
			if(~BWEB[17]) MEMORY[A/numCM][A%numCM][17] <= D[17];
			if(~BWEB[18]) MEMORY[A/numCM][A%numCM][18] <= D[18];
			if(~BWEB[19]) MEMORY[A/numCM][A%numCM][19] <= D[19];
			if(~BWEB[20]) MEMORY[A/numCM][A%numCM][20] <= D[20];
			if(~BWEB[21]) MEMORY[A/numCM][A%numCM][21] <= D[21];
			if(~BWEB[22]) MEMORY[A/numCM][A%numCM][22] <= D[22];
			if(~BWEB[23]) MEMORY[A/numCM][A%numCM][23] <= D[23];
			if(~BWEB[24]) MEMORY[A/numCM][A%numCM][24] <= D[24];
			if(~BWEB[25]) MEMORY[A/numCM][A%numCM][25] <= D[25];
			if(~BWEB[26]) MEMORY[A/numCM][A%numCM][26] <= D[26];
			if(~BWEB[27]) MEMORY[A/numCM][A%numCM][27] <= D[27];
			if(~BWEB[28]) MEMORY[A/numCM][A%numCM][28] <= D[28];
			if(~BWEB[29]) MEMORY[A/numCM][A%numCM][29] <= D[29];
			if(~BWEB[30]) MEMORY[A/numCM][A%numCM][30] <= D[30];
			if(~BWEB[31]) MEMORY[A/numCM][A%numCM][31] <= D[31];
		end
		else begin
			latched_DO<= MEMORY[A/numCM][A%numCM];
		end
	end
end
	
always_comb begin
	Q = latched_DO;
end
	
endmodule
