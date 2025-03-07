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
//					data_array128X64 SRAM macro  	//
//					no timing information included, unsynthesizable	//
// 	Date:			2024/09/28								   		//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////
module TS1N16ADFPCLLLVTA128X64M4SWSHOD_data_array (
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
	
	parameter Words 	= 4096;
	parameter Bits 		= 32;
	parameter Bytes	    = 2;
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
	input [63:0] D;
	input [63:0] BWEB;


	// Data Output
	output logic [63:0] Q;
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
			if(~BWEB[0])  MEMORY[A/numCM][A%numCM][0] <= D[0];
			if(~BWEB[1])  MEMORY[A/numCM][A%numCM][1] <= D[1];
			if(~BWEB[2])  MEMORY[A/numCM][A%numCM][2] <= D[2];
			if(~BWEB[3])  MEMORY[A/numCM][A%numCM][3] <= D[3];
			if(~BWEB[4])  MEMORY[A/numCM][A%numCM][4] <= D[4];
			if(~BWEB[5])  MEMORY[A/numCM][A%numCM][5] <= D[5];
			if(~BWEB[6])  MEMORY[A/numCM][A%numCM][6] <= D[6];
			if(~BWEB[7])  MEMORY[A/numCM][A%numCM][7] <= D[7];
			if(~BWEB[8])  MEMORY[A/numCM][A%numCM][8] <= D[8];
			if(~BWEB[9])  MEMORY[A/numCM][A%numCM][9] <= D[9];
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
			if(~BWEB[32]) MEMORY[A/numCM][A%numCM][32] <= D[32];
			if(~BWEB[33]) MEMORY[A/numCM][A%numCM][33] <= D[33];
			if(~BWEB[34]) MEMORY[A/numCM][A%numCM][34] <= D[34];
			if(~BWEB[35]) MEMORY[A/numCM][A%numCM][35] <= D[35];
			if(~BWEB[36]) MEMORY[A/numCM][A%numCM][36] <= D[36];
			if(~BWEB[37]) MEMORY[A/numCM][A%numCM][37] <= D[37];
			if(~BWEB[38]) MEMORY[A/numCM][A%numCM][38] <= D[38];
			if(~BWEB[39]) MEMORY[A/numCM][A%numCM][39] <= D[39];
			if(~BWEB[40]) MEMORY[A/numCM][A%numCM][40] <= D[40];
			if(~BWEB[41]) MEMORY[A/numCM][A%numCM][41] <= D[41];
			if(~BWEB[42]) MEMORY[A/numCM][A%numCM][42] <= D[42];
			if(~BWEB[43]) MEMORY[A/numCM][A%numCM][43] <= D[43];
			if(~BWEB[44]) MEMORY[A/numCM][A%numCM][44] <= D[44];
			if(~BWEB[45]) MEMORY[A/numCM][A%numCM][45] <= D[45];
			if(~BWEB[46]) MEMORY[A/numCM][A%numCM][46] <= D[46];
			if(~BWEB[47]) MEMORY[A/numCM][A%numCM][47] <= D[47];
			if(~BWEB[48]) MEMORY[A/numCM][A%numCM][48] <= D[48];
			if(~BWEB[49]) MEMORY[A/numCM][A%numCM][49] <= D[49];
			if(~BWEB[50]) MEMORY[A/numCM][A%numCM][50] <= D[50];
			if(~BWEB[51]) MEMORY[A/numCM][A%numCM][51] <= D[51];
			if(~BWEB[52]) MEMORY[A/numCM][A%numCM][52] <= D[52];
			if(~BWEB[53]) MEMORY[A/numCM][A%numCM][53] <= D[53];
			if(~BWEB[54]) MEMORY[A/numCM][A%numCM][54] <= D[54];
			if(~BWEB[55]) MEMORY[A/numCM][A%numCM][55] <= D[55];
			if(~BWEB[56]) MEMORY[A/numCM][A%numCM][56] <= D[56];
			if(~BWEB[57]) MEMORY[A/numCM][A%numCM][57] <= D[57];
			if(~BWEB[58]) MEMORY[A/numCM][A%numCM][58] <= D[58];
			if(~BWEB[59]) MEMORY[A/numCM][A%numCM][59] <= D[59];
			if(~BWEB[60]) MEMORY[A/numCM][A%numCM][60] <= D[60];
			if(~BWEB[61]) MEMORY[A/numCM][A%numCM][61] <= D[61];
			if(~BWEB[62]) MEMORY[A/numCM][A%numCM][62] <= D[62];
			if(~BWEB[63]) MEMORY[A/numCM][A%numCM][63] <= D[63];
			// if(~BWEB[64]) MEMORY[A/numCM][A%numCM][64] <= D[64];
			// if(~BWEB[65]) MEMORY[A/numCM][A%numCM][65] <= D[65];
			// if(~BWEB[66]) MEMORY[A/numCM][A%numCM][66] <= D[66];
			// if(~BWEB[67]) MEMORY[A/numCM][A%numCM][67] <= D[67];
			// if(~BWEB[68]) MEMORY[A/numCM][A%numCM][68] <= D[68];
			// if(~BWEB[69]) MEMORY[A/numCM][A%numCM][69] <= D[69];
			// if(~BWEB[70]) MEMORY[A/numCM][A%numCM][70] <= D[70];
			// if(~BWEB[71]) MEMORY[A/numCM][A%numCM][71] <= D[71];
			// if(~BWEB[72]) MEMORY[A/numCM][A%numCM][72] <= D[72];
			// if(~BWEB[73]) MEMORY[A/numCM][A%numCM][73] <= D[73];
			// if(~BWEB[74]) MEMORY[A/numCM][A%numCM][74] <= D[74];
			// if(~BWEB[75]) MEMORY[A/numCM][A%numCM][75] <= D[75];
			// if(~BWEB[76]) MEMORY[A/numCM][A%numCM][76] <= D[76];
			// if(~BWEB[77]) MEMORY[A/numCM][A%numCM][77] <= D[77];
			// if(~BWEB[78]) MEMORY[A/numCM][A%numCM][78] <= D[78];
			// if(~BWEB[79]) MEMORY[A/numCM][A%numCM][79] <= D[79];
			// if(~BWEB[80]) MEMORY[A/numCM][A%numCM][80] <= D[80];
			// if(~BWEB[81]) MEMORY[A/numCM][A%numCM][81] <= D[81];
			// if(~BWEB[82]) MEMORY[A/numCM][A%numCM][82] <= D[82];
			// if(~BWEB[83]) MEMORY[A/numCM][A%numCM][83] <= D[83];
			// if(~BWEB[84]) MEMORY[A/numCM][A%numCM][84] <= D[84];
			// if(~BWEB[85]) MEMORY[A/numCM][A%numCM][85] <= D[85];
			// if(~BWEB[86]) MEMORY[A/numCM][A%numCM][86] <= D[86];
			// if(~BWEB[87]) MEMORY[A/numCM][A%numCM][87] <= D[87];
			// if(~BWEB[88]) MEMORY[A/numCM][A%numCM][88] <= D[88];
			// if(~BWEB[89]) MEMORY[A/numCM][A%numCM][89] <= D[89];
			// if(~BWEB[90]) MEMORY[A/numCM][A%numCM][90] <= D[90];
			// if(~BWEB[91]) MEMORY[A/numCM][A%numCM][91] <= D[91];
			// if(~BWEB[92]) MEMORY[A/numCM][A%numCM][92] <= D[92];
			// if(~BWEB[93]) MEMORY[A/numCM][A%numCM][93] <= D[93];
			// if(~BWEB[94]) MEMORY[A/numCM][A%numCM][94] <= D[94];
			// if(~BWEB[95]) MEMORY[A/numCM][A%numCM][95] <= D[95];
			// if(~BWEB[96]) MEMORY[A/numCM][A%numCM][96] <= D[96];
			// if(~BWEB[97]) MEMORY[A/numCM][A%numCM][97] <= D[97];
			// if(~BWEB[98]) MEMORY[A/numCM][A%numCM][98] <= D[98];
			// if(~BWEB[99]) MEMORY[A/numCM][A%numCM][99] <= D[99];
			// if(~BWEB[100]) MEMORY[A/numCM][A%numCM][100] <= D[100];
			// if(~BWEB[101]) MEMORY[A/numCM][A%numCM][101] <= D[101];
			// if(~BWEB[102]) MEMORY[A/numCM][A%numCM][102] <= D[102];
			// if(~BWEB[103]) MEMORY[A/numCM][A%numCM][103] <= D[103];
			// if(~BWEB[104]) MEMORY[A/numCM][A%numCM][104] <= D[104];
			// if(~BWEB[105]) MEMORY[A/numCM][A%numCM][105] <= D[105];
			// if(~BWEB[106]) MEMORY[A/numCM][A%numCM][106] <= D[106];
			// if(~BWEB[107]) MEMORY[A/numCM][A%numCM][107] <= D[107];
			// if(~BWEB[108]) MEMORY[A/numCM][A%numCM][108] <= D[108];
			// if(~BWEB[109]) MEMORY[A/numCM][A%numCM][109] <= D[109];
			// if(~BWEB[110]) MEMORY[A/numCM][A%numCM][110] <= D[110];
			// if(~BWEB[111]) MEMORY[A/numCM][A%numCM][111] <= D[111];
			// if(~BWEB[112]) MEMORY[A/numCM][A%numCM][112] <= D[112];
			// if(~BWEB[113]) MEMORY[A/numCM][A%numCM][113] <= D[113];
			// if(~BWEB[114]) MEMORY[A/numCM][A%numCM][114] <= D[114];
			// if(~BWEB[115]) MEMORY[A/numCM][A%numCM][115] <= D[115];
			// if(~BWEB[116]) MEMORY[A/numCM][A%numCM][116] <= D[116];
			// if(~BWEB[117]) MEMORY[A/numCM][A%numCM][117] <= D[117];
			// if(~BWEB[118]) MEMORY[A/numCM][A%numCM][118] <= D[118];
			// if(~BWEB[119]) MEMORY[A/numCM][A%numCM][119] <= D[119];
			// if(~BWEB[120]) MEMORY[A/numCM][A%numCM][120] <= D[120];
			// if(~BWEB[121]) MEMORY[A/numCM][A%numCM][121] <= D[121];
			// if(~BWEB[122]) MEMORY[A/numCM][A%numCM][122] <= D[122];
			// if(~BWEB[123]) MEMORY[A/numCM][A%numCM][123] <= D[123];
			// if(~BWEB[124]) MEMORY[A/numCM][A%numCM][124] <= D[124];
			// if(~BWEB[125]) MEMORY[A/numCM][A%numCM][125] <= D[125];
			// if(~BWEB[126]) MEMORY[A/numCM][A%numCM][126] <= D[126];
			// if(~BWEB[127]) MEMORY[A/numCM][A%numCM][127] <= D[127];
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
