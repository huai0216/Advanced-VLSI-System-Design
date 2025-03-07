//*#*********************************************************************************************************************/
//*
//*# Technology     : TSMC 16nm CMOS Logic FinFet Compact (FFC) Low Leakage HKMG                          */
//*# Memory Type    : TSMC 16nm FFC Single Port SRAM with d0907 bit cell                     */
//*# Library Name   : ts1n16adfpclllvta512x45m4swshod (user specify : ts1n16adfpclllvta512x45m4swshod)            */
//*# Library Version: 100a                                                */
//*# Generated Time : 2021/11/11, 16:15:29                                        */
//*#*********************************************************************************************************************/
//*#                                                            */
//*# STATEMENT OF USE                                                    */
//*#                                                            */
//*# This information contains confidential and proprietary information of TSMC.                    */
//*# No part of this information may be reproduced, transmitted, transcribed,                        */
//*# stored in a retrieval system, or translated into any human or computer                        */
//*# language, in any form or by any means, electronic, mechanical, magnetic,                        */
//*# optical, chemical, manual, or otherwise, without the prior written permission                    */
//*# of TSMC. This information was prepared for informational purpose and is for                    */
//*# use by TSMC's customers only. TSMC reserves the right to make changes in the                    */
//*# information at any time and without notice.                                    */
//*#                                                            */
//*#*********************************************************************************************************************/
//********************************************************************************/
//*                                                                              */
//*      Usage Limitation: PLEASE READ CAREFULLY FOR CORRECT USAGE               */
//*                                                                              */
//* Please be careful when using non 2^n  memory.                                */
//* In a non-fully decoded array, a write cycle to a nonexistent address location*/
//* does not change the memory array contents and output remains the same.       */
//* In a non-fully decoded array, a read cycle to a nonexistent address location */
//* does not change the memory array contents but the output becomes unknown.    */
//*                                                                              */
//* In the verilog model, the behavior of unknown clock will corrupt the         */
//* memory data and make output unknown regardless of CEB signal.  But in the    */
//* silicon, the unknown clock at CEB high, the memory and output data will be   */
//* held. The verilog model behavior is more conservative in this condition.     */
//*                                                                              */
//* The model doesn't identify physical column and row address.                  */
//*                                                                              */
//* The verilog model provides TSMC_CM_UNIT_DELAY mode for the fast function     */
//* simulation.                                                                  */
//* All timing values in the specification are not checked in the                */
//* TSMC_CM_UNIT_DELAY mode simulation.                                          */
//* The timing values specified in this model do not reflect real circuit        */
//* behavior. For real timing simulation, please back annotate SDF file.         */
//*                                                                              */
//* Template Version : S_01_61301                                                */
//****************************************************************************** */
//*      Macro Usage       : (+define[MACRO] for Verilog compiliers)             */
//* +TSMC_CM_UNIT_DELAY : Enable fast function simulation.                       */
//* +TSMC_CM_NO_WARNING : Disable all runtime warnings message from this model.  */
//* +TSMC_INITIALIZE_MEM : Initialize the memory data in verilog format.         */
//* +TSMC_INITIALIZE_FAULT : Initialize the memory fault data in verilog format. */
//* +TSMC_NO_TESTPINS_DEFAULT_VALUE_CHECK : Disable the wrong test pins          */
//*                           connection error  message if necessary.            */
//* +TSMC_STUCKAT_FAULT : Enable injectSA task. Please don't use this option     */
//*                       with initial options like +vcs+initmem+0/1 or          */
//*                       +vcs+initreg+0/1 ...                                   */
//****************************************************************************** */
`resetall

`celldefine

`timescale 1ns/1ps
`delay_mode_path
`suppress_faults
`enable_portfaults
      
module TS1N16ADFPCLLLVTA512X45M4SWSHOD (
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

// parameter numWord = 16384;
// parameter numRow = 2;
// parameter numCM = 8192;
// parameter numIOBit = 32;
// parameter numBit = 32;
// parameter numWordAddr = 14;
// parameter numRowAddr = 1;
// parameter numCMAddr = 13;
parameter numWord = 16384;
parameter numRow = 512;
parameter numCM = 32;
parameter numIOBit = 32;
parameter numBit = 32;
parameter numWordAddr = 14;
parameter numRowAddr = 9;
parameter numCMAddr = 5;
`ifdef TSMC_STUCKAT_FAULT
parameter numStuckAt = 20;
`endif

`ifdef TSMC_CM_UNIT_DELAY
parameter SRAM_DELAY = 0.0010;
`endif
`ifdef TSMC_INITIALIZE_MEM
parameter INITIAL_MEM_DELAY = 0.01;
`else
  `ifdef TSMC_INITIALIZE_MEM_USING_DEFAULT_TASKS
parameter INITIAL_MEM_DELAY = 0.01;
  `endif
`endif
`ifdef TSMC_INITIALIZE_FAULT
parameter INITIAL_FAULT_DELAY = 0.01;
`endif

`ifdef TSMC_INITIALIZE_MEM
parameter cdeFileInit  = "TS1N16ADFPCLLLVTA512X45M4SWSHOD_initial.cde";
`endif
`ifdef TSMC_INITIALIZE_FAULT
parameter cdeFileFault = "TS1N16ADFPCLLLVTA512X45M4SWSHOD_fault.cde";
`endif

`ifdef TSMC_CM_NO_WARNING
parameter MES_ALL = "OFF";
`else
parameter MES_ALL = "ON";
`endif

//=== IO Ports ===//

// Normal Mode Input
input SLP;
input DSLP;
input SD;
input CLK;
input CEB;
input WEB;
input [13:0] A;
input [31:0] D;
input [31:0] BWEB;


// Data Output
output [31:0] Q;
output PUDELAY;


// Test Mode
input [1:0] RTSEL;
input [1:0] WTSEL;

//=== Internal Signals ===//
        
// Normal Mode Input
wire SLP_b;
reg  SLP_i;
wire DSLP_b;
reg  DSLP_i;
wire SD_i;
wire CLK_i;
wire CEB_i;
wire WEB_i;
wire [numWordAddr-1:0] A_i;
wire [numIOBit-1:0] D_i;
wire [numIOBit-1:0] BWEB_i;

wire BIST_i;
assign BIST_i = 1'b0;


// Data Output
wire [numIOBit-1:0] Q_i;
wire PUDELAY_i;

// Serial Shift Register Data

// Test Mode
wire [1:0] RTSEL_i;
wire [1:0] WTSEL_i;

//=== IO Buffers ===//
        
// Normal Mode Input
buf (SLP_b, SLP);
buf (DSLP_b, DSLP);
buf (SD_i, SD);
buf (CLK_i, CLK);
buf (CEB_i, CEB);
buf (WEB_i, WEB);
buf (A_i[0], A[0]);
buf (A_i[1], A[1]);
buf (A_i[2], A[2]);
buf (A_i[3], A[3]);
buf (A_i[4], A[4]);
buf (A_i[5], A[5]);
buf (A_i[6], A[6]);
buf (A_i[7], A[7]);
buf (A_i[8], A[8]);
buf (A_i[9], A[9]);
buf (A_i[10], A[10]);
buf (A_i[11], A[11]);
buf (A_i[12], A[12]);
buf (A_i[13], A[13]);
buf (D_i[0], D[0]);
buf (D_i[1], D[1]);
buf (D_i[2], D[2]);
buf (D_i[3], D[3]);
buf (D_i[4], D[4]);
buf (D_i[5], D[5]);
buf (D_i[6], D[6]);
buf (D_i[7], D[7]);
buf (D_i[8], D[8]);
buf (D_i[9], D[9]);
buf (D_i[10], D[10]);
buf (D_i[11], D[11]);
buf (D_i[12], D[12]);
buf (D_i[13], D[13]);
buf (D_i[14], D[14]);
buf (D_i[15], D[15]);
buf (D_i[16], D[16]);
buf (D_i[17], D[17]);
buf (D_i[18], D[18]);
buf (D_i[19], D[19]);
buf (D_i[20], D[20]);
buf (D_i[21], D[21]);
buf (D_i[22], D[22]);
buf (D_i[23], D[23]);
buf (D_i[24], D[24]);
buf (D_i[25], D[25]);
buf (D_i[26], D[26]);
buf (D_i[27], D[27]);
buf (D_i[28], D[28]);
buf (D_i[29], D[29]);
buf (D_i[30], D[30]);
buf (D_i[31], D[31]);
buf (BWEB_i[0], BWEB[0]);
buf (BWEB_i[1], BWEB[1]);
buf (BWEB_i[2], BWEB[2]);
buf (BWEB_i[3], BWEB[3]);
buf (BWEB_i[4], BWEB[4]);
buf (BWEB_i[5], BWEB[5]);
buf (BWEB_i[6], BWEB[6]);
buf (BWEB_i[7], BWEB[7]);
buf (BWEB_i[8], BWEB[8]);
buf (BWEB_i[9], BWEB[9]);
buf (BWEB_i[10], BWEB[10]);
buf (BWEB_i[11], BWEB[11]);
buf (BWEB_i[12], BWEB[12]);
buf (BWEB_i[13], BWEB[13]);
buf (BWEB_i[14], BWEB[14]);
buf (BWEB_i[15], BWEB[15]);
buf (BWEB_i[16], BWEB[16]);
buf (BWEB_i[17], BWEB[17]);
buf (BWEB_i[18], BWEB[18]);
buf (BWEB_i[19], BWEB[19]);
buf (BWEB_i[20], BWEB[20]);
buf (BWEB_i[21], BWEB[21]);
buf (BWEB_i[22], BWEB[22]);
buf (BWEB_i[23], BWEB[23]);
buf (BWEB_i[24], BWEB[24]);
buf (BWEB_i[25], BWEB[25]);
buf (BWEB_i[26], BWEB[26]);
buf (BWEB_i[27], BWEB[27]);
buf (BWEB_i[28], BWEB[28]);
buf (BWEB_i[29], BWEB[29]);
buf (BWEB_i[30], BWEB[30]);
buf (BWEB_i[31], BWEB[31]);



// Data Output
nmos (Q[0], Q_i[0], 1'b1);
nmos (Q[1], Q_i[1], 1'b1);
nmos (Q[2], Q_i[2], 1'b1);
nmos (Q[3], Q_i[3], 1'b1);
nmos (Q[4], Q_i[4], 1'b1);
nmos (Q[5], Q_i[5], 1'b1);
nmos (Q[6], Q_i[6], 1'b1);
nmos (Q[7], Q_i[7], 1'b1);
nmos (Q[8], Q_i[8], 1'b1);
nmos (Q[9], Q_i[9], 1'b1);
nmos (Q[10], Q_i[10], 1'b1);
nmos (Q[11], Q_i[11], 1'b1);
nmos (Q[12], Q_i[12], 1'b1);
nmos (Q[13], Q_i[13], 1'b1);
nmos (Q[14], Q_i[14], 1'b1);
nmos (Q[15], Q_i[15], 1'b1);
nmos (Q[16], Q_i[16], 1'b1);
nmos (Q[17], Q_i[17], 1'b1);
nmos (Q[18], Q_i[18], 1'b1);
nmos (Q[19], Q_i[19], 1'b1);
nmos (Q[20], Q_i[20], 1'b1);
nmos (Q[21], Q_i[21], 1'b1);
nmos (Q[22], Q_i[22], 1'b1);
nmos (Q[23], Q_i[23], 1'b1);
nmos (Q[24], Q_i[24], 1'b1);
nmos (Q[25], Q_i[25], 1'b1);
nmos (Q[26], Q_i[26], 1'b1);
nmos (Q[27], Q_i[27], 1'b1);
nmos (Q[28], Q_i[28], 1'b1);
nmos (Q[29], Q_i[29], 1'b1);
nmos (Q[30], Q_i[30], 1'b1);
nmos (Q[31], Q_i[31], 1'b1);
nmos (PUDELAY, PUDELAY_i, 1'b1);



// Test Mode
buf sRTSEL0 (RTSEL_i[0], RTSEL[0]);
buf sRTSEL1 (RTSEL_i[1], RTSEL[1]);
buf sWTSEL0 (WTSEL_i[0], WTSEL[0]);
buf sWTSEL1 (WTSEL_i[1], WTSEL[1]);

//=== Data Structure ===//
reg invalid_slp;
reg invalid_dslp;
reg invalid_sd_dslp;
integer awt_counter;
integer wk_counter;

reg [numBit-1:0] MEMORY[numRow-1:0][numCM-1:0];
reg [numBit-1:0] MEMORY_FAULT[numRow-1:0][numCM-1:0];
reg [numIOBit-1:0] Q_d, bQ_tmp;
reg [numBit-1:0] Q_d_tmp;
reg [numIOBit-1:0] PRELOAD[0:numWord-1];
reg [numIOBit-1:0] PRELOAD2[0:numWord-1];
reg [numBit-1:0] DIN_tmp;

`ifdef TSMC_STUCKAT_FAULT
reg [numBit-1:0] ERR_tmp;
reg [numWordAddr-1:0] stuckAt0Addr [numStuckAt:0];
reg [numWordAddr-1:0] stuckAt1Addr [numStuckAt:0];
reg [numBit-1:0] stuckAt0Bit [numStuckAt:0];
reg [numBit-1:0] stuckAt1Bit [numStuckAt:0];
`endif

reg [numWordAddr-numCMAddr-1:0] row_tmp;
reg [numCMAddr-1:0] col_tmp;

integer i, j;
reg read_flag, write_flag, idle_flag;
reg slp_mode;
reg dslp_mode;
reg sd_mode;
reg clk_latch;
reg awt_mode;

`ifdef TSMC_CM_UNIT_DELAY
`else
reg notify_testpin;
reg notify_sd;
reg notify_dslp;
reg notify_slp;
reg notify_clk;
reg notify_sd_dslp;
reg notify_bist;
reg notify_ceb;
reg notify_web;
reg notify_addr;
reg notify_d0;
reg notify_bweb0;
reg notify_d1;
reg notify_bweb1;
reg notify_d2;
reg notify_bweb2;
reg notify_d3;
reg notify_bweb3;
reg notify_d4;
reg notify_bweb4;
reg notify_d5;
reg notify_bweb5;
reg notify_d6;
reg notify_bweb6;
reg notify_d7;
reg notify_bweb7;
reg notify_d8;
reg notify_bweb8;
reg notify_d9;
reg notify_bweb9;
reg notify_d10;
reg notify_bweb10;
reg notify_d11;
reg notify_bweb11;
reg notify_d12;
reg notify_bweb12;
reg notify_d13;
reg notify_bweb13;
reg notify_d14;
reg notify_bweb14;
reg notify_d15;
reg notify_bweb15;
reg notify_d16;
reg notify_bweb16;
reg notify_d17;
reg notify_bweb17;
reg notify_d18;
reg notify_bweb18;
reg notify_d19;
reg notify_bweb19;
reg notify_d20;
reg notify_bweb20;
reg notify_d21;
reg notify_bweb21;
reg notify_d22;
reg notify_bweb22;
reg notify_d23;
reg notify_bweb23;
reg notify_d24;
reg notify_bweb24;
reg notify_d25;
reg notify_bweb25;
reg notify_d26;
reg notify_bweb26;
reg notify_d27;
reg notify_bweb27;
reg notify_d28;
reg notify_bweb28;
reg notify_d29;
reg notify_bweb29;
reg notify_d30;
reg notify_bweb30;
reg notify_d31;
reg notify_bweb31;
`endif    //end `ifdef TSMC_CM_UNIT_DELAY

reg CEBL;
reg WEBL;

wire iCEB = (BIST_i===1) ? CEB_i : CEB_i;
wire iWEB = (BIST_i===1) ? WEB_i : WEB_i;
wire [numWordAddr-1:0] iA = A_i;
reg RCEB;

reg [numWordAddr-numCMAddr-1:0] iRowAddr;
reg [numCMAddr-1:0] iColAddr;
wire [numIOBit-1:0] iD = D_i;
wire [numIOBit-1:0] iBWEB = BWEB_i;



wire bDFTBYP;
wire bSE;
assign bDFTBYP = 1'b0;
assign bSE = 1'b0;

`ifdef TSMC_CM_UNIT_DELAY
`else
wire check_invalid_sd_dslp = invalid_sd_dslp;
wire check_read = read_flag & ~SD_i & ~DSLP_i & ~SLP_i;
wire check_write = write_flag & ~SD_i & ~DSLP_i & ~SLP_i & ~bDFTBYP & ~bSE;
wire check_nosd = ~SD_i & ~invalid_sd_dslp;
wire check_nosd_invalid = ~SD_i;
wire check_nosddslp = ~SD_i & ~DSLP_i ;
wire check_nopd = ~SD_i & ~DSLP_i & ~SLP_i;
wire mem_nopd = ~SD_i & ~DSLP_i & ~SLP_i & ~bDFTBYP & ~bSE;
wire check_noidle = ~idle_flag & ~SD_i & ~DSLP_i & ~SLP_i & ~bDFTBYP & ~bSE;
wire check_wk_2_clk = (~idle_flag | bDFTBYP) & ~SD_i & ~DSLP_i & ~SLP_i & ~invalid_sd_dslp;
wire check_wk_2_clk_invalid = (~idle_flag | bDFTBYP) & ~SD_i & ~DSLP_i & ~SLP_i;
wire check_idle = idle_flag & ~SD_i & ~DSLP_i & ~SLP_i & ~bDFTBYP & ~bSE;
wire check_ceb = ~CEB_i & ~SD_i & ~DSLP_i & ~SLP_i & ~bDFTBYP & ~bSE;

`endif    //end `ifdef TSMC_CM_UNIT_DELAY


assign Q_i= Q_d;

`ifdef TSMC_CM_UNIT_DELAY
assign #(SRAM_DELAY) PUDELAY_i = SD_i;
`else
assign PUDELAY_i = SD_i;
`endif

`ifdef TSMC_CM_UNIT_DELAY
`else

`ifdef TSMC_CM_ACCESS
`else
`define TSMC_CM_ACCESS 0.02
`endif
`ifdef TSMC_CM_RETAIN
`else
`define TSMC_CM_RETAIN 0.015
`endif
`ifdef TSMC_CM_SETUP
`else
`define TSMC_CM_SETUP 0.001
`endif
`ifdef TSMC_CM_HOLD
`else
`define TSMC_CM_HOLD 0.001
`endif
`ifdef TSMC_CM_PERIOD
`else
`define TSMC_CM_PERIOD 1
`endif
`ifdef TSMC_CM_WIDTH
`else
`define TSMC_CM_WIDTH 0.5
`endif
`ifdef TSMC_CM_CONTENTION
`else
`define TSMC_CM_CONTENTION 0.001
`endif

specify
    specparam PATHPULSE$ = ( 0, 0.001 );

    specparam tCYC = (`TSMC_CM_PERIOD);
    specparam tCKH = (`TSMC_CM_WIDTH);
    specparam tCKL = (`TSMC_CM_WIDTH);
    specparam tCS = (`TSMC_CM_SETUP);
    specparam tCH = (`TSMC_CM_HOLD);
    specparam tWS = (`TSMC_CM_SETUP);
    specparam tWH = (`TSMC_CM_HOLD);
    specparam tAS = (`TSMC_CM_SETUP);
    specparam tAH = (`TSMC_CM_HOLD);
    specparam tDS = (`TSMC_CM_SETUP);
    specparam tDH = (`TSMC_CM_HOLD);
    specparam tCD = (`TSMC_CM_ACCESS);
`ifdef TSMC_CM_READ_X_SQUASHING
    specparam tHOLD = (`TSMC_CM_ACCESS);
`else    
    specparam tHOLD = (`TSMC_CM_RETAIN);
`endif    
    specparam tQH = 0.0000;

    specparam tSDWK = (`TSMC_CM_SETUP);
    specparam tSDWK2CLK = (`TSMC_CM_SETUP);
    specparam tXSD = (`TSMC_CM_HOLD);
    specparam tSDQ = (`TSMC_CM_ACCESS);
    specparam tSDQH = 0.0000;
    specparam tSD2PUDLY = (`TSMC_CM_ACCESS);
    specparam tSDWK2PUDLY = (`TSMC_CM_ACCESS);
    specparam tDSLPWK = (`TSMC_CM_SETUP);
    specparam tDSLPWK2CLK =(`TSMC_CM_SETUP);
    specparam tDSLP = (`TSMC_CM_HOLD);
    specparam tXDSLP = (`TSMC_CM_HOLD);
    specparam tDSLPX = (`TSMC_CM_SETUP);
    specparam tDSLPQ = (`TSMC_CM_ACCESS);
    specparam tDSLPQH = 0.0000;
    specparam tSLPWK = (`TSMC_CM_SETUP);
    specparam tSLPWK2CLK =(`TSMC_CM_SETUP);
    specparam tSLP = (`TSMC_CM_HOLD);
    specparam tXSLP = (`TSMC_CM_HOLD);
    specparam tSLPX = (`TSMC_CM_SETUP);
    specparam tSLPQ = (`TSMC_CM_ACCESS);
    specparam tSLPQH = 0.0000;

    specparam tBWS = (`TSMC_CM_SETUP);
    specparam tBWH = (`TSMC_CM_HOLD);
    specparam ttests = (`TSMC_CM_SETUP);
    specparam ttesth = (`TSMC_CM_HOLD);





    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[0] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[1] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[2] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[3] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[4] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[5] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[6] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[7] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[8] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[9] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[10] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[11] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[12] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[13] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[14] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[15] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[16] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[17] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[18] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[19] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[20] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[21] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[22] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[23] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[24] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[25] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[26] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[27] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[28] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[29] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[30] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    if(!SD & !DSLP & !SLP & !CEB & WEB) (posedge CLK => (Q[31] : 1'bx)) = (tCD, tCD, tHOLD, tCD, tHOLD, tCD);
    (SD => (PUDELAY : 1'bx)) = (tSD2PUDLY, tSDWK2PUDLY, 0, tSD2PUDLY, 0, tSDWK2PUDLY);


    (posedge SD => (Q[0] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[1] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[2] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[3] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[4] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[5] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[6] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[7] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[8] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[9] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[10] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[11] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[12] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[13] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[14] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[15] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[16] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[17] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[18] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[19] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[20] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[21] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[22] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[23] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[24] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[25] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[26] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[27] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[28] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[29] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[30] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);
    (posedge SD => (Q[31] +: 1'b0)) = (0,tSDQ,tSDQH,0,tSDQH,tSDQ);


    if(!SD) (posedge DSLP => (Q[0] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[1] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[2] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[3] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[4] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[5] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[6] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[7] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[8] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[9] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[10] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[11] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[12] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[13] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[14] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[15] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[16] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[17] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[18] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[19] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[20] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[21] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[22] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[23] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[24] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[25] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[26] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[27] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[28] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[29] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[30] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);
    if(!SD) (posedge DSLP => (Q[31] +: 1'b0)) = (0,tDSLPQ,tDSLPQH,0,tDSLPQH,tDSLPQ);

    if(!SD & !DSLP) (posedge SLP => (Q[0] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[1] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[2] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[3] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[4] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[5] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[6] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[7] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[8] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[9] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[10] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[11] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[12] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[13] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[14] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[15] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[16] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[17] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[18] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[19] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[20] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[21] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[22] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[23] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[24] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[25] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[26] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[27] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[28] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[29] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[30] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);
    if(!SD & !DSLP) (posedge SLP => (Q[31] +: 1'b0)) = (0,tSLPQ,tSLPQH,0,tSLPQH,tSLPQ);


    $setuphold(negedge SD, negedge DSLP, tXSD, 0, notify_sd_dslp);
    $setuphold(negedge SD, posedge DSLP, 0, tSDWK, notify_sd_dslp);

    $setuphold(posedge CLK &&& check_wk_2_clk, negedge SD, tSDWK2CLK, 0, notify_sd);

    $setuphold(negedge CEB &&& check_nosd, posedge DSLP, tDSLPX, 0, notify_dslp);
    $setuphold(posedge CEB &&& check_nosd, negedge DSLP, 0, tXDSLP, notify_dslp);
    $setuphold(negedge CEB &&& check_nosd, negedge DSLP, tDSLPWK, 0, notify_dslp);
    $setuphold(posedge CEB &&& check_nosd, posedge DSLP, 0,tDSLP, notify_dslp);
    $recrem (negedge DSLP &&& check_invalid_sd_dslp, negedge CEB &&& check_nosd_invalid, tSDWK, 0, notify_dslp);
    $setuphold(posedge CLK &&& check_wk_2_clk, negedge DSLP, tDSLPWK2CLK, 0, notify_dslp);
    $recrem (negedge DSLP &&& check_invalid_sd_dslp, posedge CLK &&& check_wk_2_clk_invalid, tSDWK2CLK, 0, notify_dslp);

    $setuphold(negedge CEB &&& check_nosddslp, posedge SLP, tSLPX, 0, notify_slp);
    $setuphold(posedge CEB &&& check_nosddslp, negedge SLP, 0, tXSLP, notify_slp);
    $setuphold(negedge CEB &&& check_nosddslp, negedge SLP, tSLPWK, 0, notify_slp);
    $setuphold(posedge CEB &&& check_nosddslp, posedge SLP, 0,tSLP, notify_slp);
    $setuphold(posedge CLK &&& check_wk_2_clk, negedge SLP, tSLPWK2CLK, 0, notify_slp);

    $period(posedge CLK &&& check_ceb, tCYC, notify_clk);
    $period(negedge CLK &&& check_ceb, tCYC, notify_clk);
    $width(posedge CLK &&& check_ceb, tCKH, 0, notify_clk);
    $width(negedge CLK &&& check_ceb, tCKL, 0, notify_clk);


    $setuphold(posedge CLK &&& mem_nopd, negedge CEB, tCS, tCH, notify_ceb);
    $setuphold(posedge CLK &&& mem_nopd, posedge CEB, tCS, tCH, notify_ceb);

    $setuphold(posedge CLK &&& check_noidle, negedge WEB, tWS, tWH, notify_web);
    $setuphold(posedge CLK &&& check_noidle, posedge WEB, tWS, tWH, notify_web);

    $setuphold(posedge CLK &&& check_noidle, negedge A[0], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, negedge A[1], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, negedge A[2], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, negedge A[3], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, negedge A[4], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, negedge A[5], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, negedge A[6], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, negedge A[7], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, negedge A[8], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[0], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[1], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[2], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[3], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[4], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[5], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[6], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[7], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[8], tAS, tAH, notify_addr);
	$setuphold(posedge CLK &&& check_noidle, posedge A[9], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[10], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[11], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[12], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_noidle, posedge A[13], tAS, tAH, notify_addr);
    $setuphold(posedge CLK &&& check_write, negedge D[0], tDS, tDH, notify_d0);
    $setuphold(posedge CLK &&& check_write, negedge D[1], tDS, tDH, notify_d1);
    $setuphold(posedge CLK &&& check_write, negedge D[2], tDS, tDH, notify_d2);
    $setuphold(posedge CLK &&& check_write, negedge D[3], tDS, tDH, notify_d3);
    $setuphold(posedge CLK &&& check_write, negedge D[4], tDS, tDH, notify_d4);
    $setuphold(posedge CLK &&& check_write, negedge D[5], tDS, tDH, notify_d5);
    $setuphold(posedge CLK &&& check_write, negedge D[6], tDS, tDH, notify_d6);
    $setuphold(posedge CLK &&& check_write, negedge D[7], tDS, tDH, notify_d7);
    $setuphold(posedge CLK &&& check_write, negedge D[8], tDS, tDH, notify_d8);
    $setuphold(posedge CLK &&& check_write, negedge D[9], tDS, tDH, notify_d9);
    $setuphold(posedge CLK &&& check_write, negedge D[10], tDS, tDH, notify_d10);
    $setuphold(posedge CLK &&& check_write, negedge D[11], tDS, tDH, notify_d11);
    $setuphold(posedge CLK &&& check_write, negedge D[12], tDS, tDH, notify_d12);
    $setuphold(posedge CLK &&& check_write, negedge D[13], tDS, tDH, notify_d13);
    $setuphold(posedge CLK &&& check_write, negedge D[14], tDS, tDH, notify_d14);
    $setuphold(posedge CLK &&& check_write, negedge D[15], tDS, tDH, notify_d15);
    $setuphold(posedge CLK &&& check_write, negedge D[16], tDS, tDH, notify_d16);
    $setuphold(posedge CLK &&& check_write, negedge D[17], tDS, tDH, notify_d17);
    $setuphold(posedge CLK &&& check_write, negedge D[18], tDS, tDH, notify_d18);
    $setuphold(posedge CLK &&& check_write, negedge D[19], tDS, tDH, notify_d19);
    $setuphold(posedge CLK &&& check_write, negedge D[20], tDS, tDH, notify_d20);
    $setuphold(posedge CLK &&& check_write, negedge D[21], tDS, tDH, notify_d21);
    $setuphold(posedge CLK &&& check_write, negedge D[22], tDS, tDH, notify_d22);
    $setuphold(posedge CLK &&& check_write, negedge D[23], tDS, tDH, notify_d23);
    $setuphold(posedge CLK &&& check_write, negedge D[24], tDS, tDH, notify_d24);
    $setuphold(posedge CLK &&& check_write, negedge D[25], tDS, tDH, notify_d25);
    $setuphold(posedge CLK &&& check_write, negedge D[26], tDS, tDH, notify_d26);
    $setuphold(posedge CLK &&& check_write, negedge D[27], tDS, tDH, notify_d27);
    $setuphold(posedge CLK &&& check_write, negedge D[28], tDS, tDH, notify_d28);
    $setuphold(posedge CLK &&& check_write, negedge D[29], tDS, tDH, notify_d29);
    $setuphold(posedge CLK &&& check_write, negedge D[30], tDS, tDH, notify_d30);
    $setuphold(posedge CLK &&& check_write, negedge D[31], tDS, tDH, notify_d31);
    $setuphold(posedge CLK &&& check_write, posedge D[0], tDS, tDH, notify_d0);
    $setuphold(posedge CLK &&& check_write, posedge D[1], tDS, tDH, notify_d1);
    $setuphold(posedge CLK &&& check_write, posedge D[2], tDS, tDH, notify_d2);
    $setuphold(posedge CLK &&& check_write, posedge D[3], tDS, tDH, notify_d3);
    $setuphold(posedge CLK &&& check_write, posedge D[4], tDS, tDH, notify_d4);
    $setuphold(posedge CLK &&& check_write, posedge D[5], tDS, tDH, notify_d5);
    $setuphold(posedge CLK &&& check_write, posedge D[6], tDS, tDH, notify_d6);
    $setuphold(posedge CLK &&& check_write, posedge D[7], tDS, tDH, notify_d7);
    $setuphold(posedge CLK &&& check_write, posedge D[8], tDS, tDH, notify_d8);
    $setuphold(posedge CLK &&& check_write, posedge D[9], tDS, tDH, notify_d9);
    $setuphold(posedge CLK &&& check_write, posedge D[10], tDS, tDH, notify_d10);
    $setuphold(posedge CLK &&& check_write, posedge D[11], tDS, tDH, notify_d11);
    $setuphold(posedge CLK &&& check_write, posedge D[12], tDS, tDH, notify_d12);
    $setuphold(posedge CLK &&& check_write, posedge D[13], tDS, tDH, notify_d13);
    $setuphold(posedge CLK &&& check_write, posedge D[14], tDS, tDH, notify_d14);
    $setuphold(posedge CLK &&& check_write, posedge D[15], tDS, tDH, notify_d15);
    $setuphold(posedge CLK &&& check_write, posedge D[16], tDS, tDH, notify_d16);
    $setuphold(posedge CLK &&& check_write, posedge D[17], tDS, tDH, notify_d17);
    $setuphold(posedge CLK &&& check_write, posedge D[18], tDS, tDH, notify_d18);
    $setuphold(posedge CLK &&& check_write, posedge D[19], tDS, tDH, notify_d19);
    $setuphold(posedge CLK &&& check_write, posedge D[20], tDS, tDH, notify_d20);
    $setuphold(posedge CLK &&& check_write, posedge D[21], tDS, tDH, notify_d21);
    $setuphold(posedge CLK &&& check_write, posedge D[22], tDS, tDH, notify_d22);
    $setuphold(posedge CLK &&& check_write, posedge D[23], tDS, tDH, notify_d23);
    $setuphold(posedge CLK &&& check_write, posedge D[24], tDS, tDH, notify_d24);
    $setuphold(posedge CLK &&& check_write, posedge D[25], tDS, tDH, notify_d25);
    $setuphold(posedge CLK &&& check_write, posedge D[26], tDS, tDH, notify_d26);
    $setuphold(posedge CLK &&& check_write, posedge D[27], tDS, tDH, notify_d27);
    $setuphold(posedge CLK &&& check_write, posedge D[28], tDS, tDH, notify_d28);
    $setuphold(posedge CLK &&& check_write, posedge D[29], tDS, tDH, notify_d29);
    $setuphold(posedge CLK &&& check_write, posedge D[30], tDS, tDH, notify_d30);
    $setuphold(posedge CLK &&& check_write, posedge D[31], tDS, tDH, notify_d31);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[0], tBWS, tBWH, notify_bweb0);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[1], tBWS, tBWH, notify_bweb1);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[2], tBWS, tBWH, notify_bweb2);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[3], tBWS, tBWH, notify_bweb3);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[4], tBWS, tBWH, notify_bweb4);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[5], tBWS, tBWH, notify_bweb5);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[6], tBWS, tBWH, notify_bweb6);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[7], tBWS, tBWH, notify_bweb7);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[8], tBWS, tBWH, notify_bweb8);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[9], tBWS, tBWH, notify_bweb9);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[10], tBWS, tBWH, notify_bweb10);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[11], tBWS, tBWH, notify_bweb11);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[12], tBWS, tBWH, notify_bweb12);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[13], tBWS, tBWH, notify_bweb13);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[14], tBWS, tBWH, notify_bweb14);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[15], tBWS, tBWH, notify_bweb15);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[16], tBWS, tBWH, notify_bweb16);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[17], tBWS, tBWH, notify_bweb17);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[18], tBWS, tBWH, notify_bweb18);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[19], tBWS, tBWH, notify_bweb19);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[20], tBWS, tBWH, notify_bweb20);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[21], tBWS, tBWH, notify_bweb21);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[22], tBWS, tBWH, notify_bweb22);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[23], tBWS, tBWH, notify_bweb23);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[24], tBWS, tBWH, notify_bweb24);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[25], tBWS, tBWH, notify_bweb25);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[26], tBWS, tBWH, notify_bweb26);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[27], tBWS, tBWH, notify_bweb27);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[28], tBWS, tBWH, notify_bweb28);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[29], tBWS, tBWH, notify_bweb29);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[30], tBWS, tBWH, notify_bweb30);
    $setuphold(posedge CLK &&& check_write, negedge BWEB[31], tBWS, tBWH, notify_bweb31);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[0], tBWS, tBWH, notify_bweb0);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[1], tBWS, tBWH, notify_bweb1);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[2], tBWS, tBWH, notify_bweb2);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[3], tBWS, tBWH, notify_bweb3);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[4], tBWS, tBWH, notify_bweb4);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[5], tBWS, tBWH, notify_bweb5);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[6], tBWS, tBWH, notify_bweb6);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[7], tBWS, tBWH, notify_bweb7);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[8], tBWS, tBWH, notify_bweb8);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[9], tBWS, tBWH, notify_bweb9);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[10], tBWS, tBWH, notify_bweb10);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[11], tBWS, tBWH, notify_bweb11);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[12], tBWS, tBWH, notify_bweb12);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[13], tBWS, tBWH, notify_bweb13);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[14], tBWS, tBWH, notify_bweb14);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[15], tBWS, tBWH, notify_bweb15);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[16], tBWS, tBWH, notify_bweb16);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[17], tBWS, tBWH, notify_bweb17);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[18], tBWS, tBWH, notify_bweb18);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[19], tBWS, tBWH, notify_bweb19);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[20], tBWS, tBWH, notify_bweb20);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[21], tBWS, tBWH, notify_bweb21);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[22], tBWS, tBWH, notify_bweb22);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[23], tBWS, tBWH, notify_bweb23);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[24], tBWS, tBWH, notify_bweb24);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[25], tBWS, tBWH, notify_bweb25);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[26], tBWS, tBWH, notify_bweb26);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[27], tBWS, tBWH, notify_bweb27);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[28], tBWS, tBWH, notify_bweb28);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[29], tBWS, tBWH, notify_bweb29);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[30], tBWS, tBWH, notify_bweb30);
    $setuphold(posedge CLK &&& check_write, posedge BWEB[31], tBWS, tBWH, notify_bweb31);





    $setuphold (posedge CLK &&& check_noidle, posedge RTSEL[0], ttests, 0, notify_testpin); 
    $setuphold (posedge CLK &&& check_noidle, negedge RTSEL[0], ttests, 0, notify_testpin);
    $setuphold (posedge CLK &&& check_idle, posedge RTSEL[0], 0, ttesth, notify_testpin); 
    $setuphold (posedge CLK &&& check_idle, negedge RTSEL[0], 0, ttesth, notify_testpin);
    $setuphold (posedge CLK &&& check_noidle, posedge RTSEL[1], ttests, 0, notify_testpin); 
    $setuphold (posedge CLK &&& check_noidle, negedge RTSEL[1], ttests, 0, notify_testpin);
    $setuphold (posedge CLK &&& check_idle, posedge RTSEL[1], 0, ttesth, notify_testpin); 
    $setuphold (posedge CLK &&& check_idle, negedge RTSEL[1], 0, ttesth, notify_testpin);
    $setuphold (posedge CLK &&& check_noidle, posedge WTSEL[0], ttests, 0, notify_testpin); 
    $setuphold (posedge CLK &&& check_noidle, negedge WTSEL[0], ttests, 0, notify_testpin);
    $setuphold (posedge CLK &&& check_idle, posedge WTSEL[0], 0, ttesth, notify_testpin); 
    $setuphold (posedge CLK &&& check_idle, negedge WTSEL[0], 0, ttesth, notify_testpin);
    $setuphold (posedge CLK &&& check_noidle, posedge WTSEL[1], ttests, 0, notify_testpin); 
    $setuphold (posedge CLK &&& check_noidle, negedge WTSEL[1], ttests, 0, notify_testpin);
    $setuphold (posedge CLK &&& check_idle, posedge WTSEL[1], 0, ttesth, notify_testpin); 
    $setuphold (posedge CLK &&& check_idle, negedge WTSEL[1], 0, ttesth, notify_testpin);



endspecify
`endif    //end `ifdef TSMC_CM_UNIT_DELAY

initial begin
    read_flag = 0;
    write_flag = 0;
    idle_flag = 1;
    slp_mode = 0;
    dslp_mode = 0;
    sd_mode = 0;
    awt_mode = 0;
    awt_counter  = 0;
    wk_counter  = 0;
    invalid_slp = 1'b0;
    invalid_dslp = 1'b0;
    invalid_sd_dslp = 1'b0;
`ifdef TSMC_STUCKAT_FAULT
    #(0.001);
    for (i = 0; i < numStuckAt; i = i + 1) begin
        stuckAt0Addr[i] = {numWordAddr{1'bx}};
        stuckAt1Addr[i] = {numWordAddr{1'bx}};
        stuckAt0Bit[i] = {numBit{1'bx}};
        stuckAt1Bit[i] = {numBit{1'bx}};
    end
`endif
end

`ifdef TSMC_INITIALIZE_MEM_USING_DEFAULT_TASKS
initial begin
    #(INITIAL_MEM_DELAY) ;
`ifdef TSMC_MEM_LOAD_0
    zeroMemoryAll;
`else
 `ifdef TSMC_MEM_LOAD_1
    oneMemoryAll;
 `else
  `ifdef TSMC_MEM_LOAD_RANDOM
    randomMemoryAll;
  `else
    xMemoryAll;
  `endif
 `endif
`endif    
end
`endif //`ifdef TSMC_INITIALIZE_MEM_USING_DEFAULT_TASKS

 `ifdef TSMC_INITIALIZE_MEM
initial begin 
    #(INITIAL_MEM_DELAY) ;
    preloadData(cdeFileInit) ;
end
`endif //  `ifdef TSMC_INITIALIZE_MEM
   
`ifdef TSMC_INITIALIZE_FAULT
initial begin
`ifdef TSMC_INITIALIZE_FORMAT_BINARY
     #(INITIAL_FAULT_DELAY) $readmemb(cdeFileFault, PRELOAD2, 0, numWord-1);
`else
     #(INITIAL_FAULT_DELAY) $readmemh(cdeFileFault, PRELOAD2, 0, numWord-1);
`endif
    for (i = 0; i < numWord; i = i + 1) begin
        {row_tmp, col_tmp} = i;
        MEMORY_FAULT[row_tmp][col_tmp] = PRELOAD2[i];
    end
end
`endif //  `ifdef TSMC_INITIALIZE_FAULT


always @(RTSEL_i) begin
    if(SLP_i === 1'b0 && DSLP_i === 1'b0 && SD_i === 1'b0) begin
    if(($realtime > 0) && idle_flag === 1'b0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : input RTSEL should not be toggled when CEB is low at simulation time %t\n", $realtime);
`endif
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin    
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d = {numIOBit{1'bx}};        
        xMemoryAll;
    end
    end
    end
end
always @(WTSEL_i) begin
    if(SLP_i === 1'b0 && DSLP_i === 1'b0 && SD_i === 1'b0) begin
    if(($realtime > 0) && idle_flag === 1'b0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : input WTSEL should not be toggled when CEB is low at simulation time %t\n", $realtime);
`endif
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin    
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d = {numIOBit{1'bx}};        
        xMemoryAll;
    end
    end
    end
end

`ifdef TSMC_NO_TESTPINS_DEFAULT_VALUE_CHECK
`else
always @(CLK_i or RTSEL_i) begin
    if(SLP_i === 1'b0 && DSLP_i === 1'b0 && SD_i === 1'b0) begin
    if((RTSEL_i !== 2'b01) && ($realtime > 0)) begin
        $display("\tError %m : input RTSEL should be set to 2'b01 at simulation time %t\n", $realtime);
        $display("\tError %m : Please refer the datasheet for the RTSEL setting in the different segment and mux configuration\n");
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d = {numIOBit{1'bx}};
        xMemoryAll;
    end
    end
    end
end
always @(CLK_i or WTSEL_i) begin
    if(SLP_i === 1'b0 && DSLP_i === 1'b0 && SD_i === 1'b0) begin
    if((WTSEL_i !== 2'b01) && ($realtime > 0)) begin
        $display("\tError %m : input WTSEL should be set to 2'b01 at simulation time %t\n", $realtime);
        $display("\tError %m : Please refer the datasheet for the WTSEL setting in the different segment and mux configuration\n");
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d = {numIOBit{1'bx}};
        xMemoryAll;
    end
    end
    end
end
`endif

always @(SLP_b) begin
    `ifdef TSMC_ENABLE_POWERPIN_DELAY
    if(SLP_b == 1) begin
        SLP_i = SLP_b;
    end
    else begin
        SLP_i = #0.01 SLP_b;
    end
    `else
    SLP_i = SLP_b;
    `endif
end

always @(DSLP_b) begin
    `ifdef TSMC_ENABLE_POWERPIN_DELAY
    if(DSLP_b == 1) begin
        DSLP_i = DSLP_b;
    end
    else begin
        DSLP_i = #0.01 DSLP_b;
    end
    `else
    DSLP_i = DSLP_b;
    `endif
end


always @(CLK_i) begin : CLK_OPERATION
    if(SLP_i === 1'b0 && DSLP_i === 1'b0 && SD_i === 1'b0 && bDFTBYP === 1'b0 && bSE === 1'b0) begin
    if (CLK_i === 1'b1) begin
        read_flag=0;
        idle_flag=1;
        write_flag=0;
    end
    if (slp_mode === 1'b0 && dslp_mode === 1'b0 && sd_mode === 1'b0) begin
        if (CLK_i === 1'bx) begin
`ifdef TSMC_CM_NO_WARNING
`else
            $display("\tWarning %m : input CLK unknown/high-Z at simulation time %t\n", $realtime);
`endif
`ifdef TSMC_CM_UNIT_DELAY
            #(SRAM_DELAY);
`endif
            Q_d = {numIOBit{1'bx}};
            xMemoryAll;
        end
        else if ((CLK_i===1) && (clk_latch===0)) begin    //posedge
            iRowAddr = iA[numWordAddr-1:numCMAddr];
            iColAddr = iA[numCMAddr-1:0];
            if (iCEB === 1'b0) begin
                idle_flag = 0;
                if (iWEB === 1'b1) begin        // read
                        read_flag = 1;
                        if ( ^iA === 1'bx ) begin
`ifdef TSMC_CM_NO_WARNING
`else
  `ifndef TSMC_CM_NO_XADDR_WARNING
                            $display("\tWarning %m : input A unknown/high-Z in read cycle at simulation time %t\n", $realtime);
  `endif
`endif
`ifdef TSMC_CM_UNIT_DELAY
                            #(SRAM_DELAY);
`endif
                            Q_d = {numIOBit{1'bx}};
                            //xMemoryAll;
                        end 
                        else if (iA >= numWord) begin
`ifdef TSMC_CM_NO_WARNING
`else
                            $display("\tWarning %m : address exceed word depth in read cycle at simulation time %t\n", $realtime);
`endif
`ifdef TSMC_CM_UNIT_DELAY
                            #(SRAM_DELAY);
`endif
                            Q_d = {numIOBit{1'bx}};
                        end
                        else begin
`ifdef TSMC_CM_UNIT_DELAY
                            #(SRAM_DELAY);
    `ifdef TSMC_INITIALIZE_FAULT
                            Q_d = (MEMORY[iRowAddr][iColAddr] ^ MEMORY_FAULT[iRowAddr][iColAddr]);
    `else
                            Q_d =  MEMORY[iRowAddr][iColAddr];
    `endif
`else
                            Q_d = {numBit{1'bx}};    //transition to x first
  `ifdef TSMC_INITIALIZE_FAULT
                            #0.001 Q_d = (MEMORY[iRowAddr][iColAddr] ^ MEMORY_FAULT[iRowAddr][iColAddr]);
  `else
                            #0.001 Q_d =  MEMORY[iRowAddr][iColAddr];
  `endif
`endif
                        end // else: !if(iA >= numWord)
                end // if (iWEB === 1'b1)
                else if (iWEB === 1'b0) begin    // write
                    if ( ^iA === 1'bx ) begin
`ifdef TSMC_CM_NO_WARNING
`else
                        $display("\tWarning %m : input A unknown/high-Z in write cycle at simulation time %t\n", $realtime);
`endif
                        xMemoryAll;
                    end 
                    else if (iA >= numWord) begin
`ifdef TSMC_CM_NO_WARNING
`else
                        $display("\tWarning %m : address exceed word depth in write cycle at simulation time %t\n", $realtime);
`endif
                    end 
                    else begin
                        if ( ^iBWEB === 1'bx ) begin
`ifdef TSMC_CM_NO_WARNING
`else
                            $display("\tWarning %m : input BWEB unknown/high-Z in write cycle at simulation time %t\n", $realtime);
`endif
                        end
                        write_flag = 1;
                        begin
                            DIN_tmp = MEMORY[iRowAddr][iColAddr];
                            for (i = 0; i < numBit; i = i + 1) begin
                                DIN_tmp[i] = ((iBWEB[i] === 1'b0) ? iD[i] : ((iBWEB[i] === 1'bx) ? 1'bx : DIN_tmp[i])) ;
                            end
`ifdef TSMC_STUCKAT_FAULT
                            if ( isStuckAt0(iA) || isStuckAt1(iA) ) begin
                                combineErrors(iA, ERR_tmp);
                                for (j = 0; j < numBit; j = j + 1) begin
                                    DIN_tmp[j] = (ERR_tmp[j] !== 1'bx) ? ERR_tmp[j] : DIN_tmp[j] ;
                                end
                            end
`endif                            
                            MEMORY[iRowAddr][iColAddr] = DIN_tmp;
                        end
                    end //end of if ( ^iA === 1'bx ) begin
                end 
                else begin
`ifdef TSMC_CM_NO_WARNING
`else
                    $display("\tWarning %m : input WEB unknown/high-Z at simulation time %t\n", $realtime);
`endif
`ifdef TSMC_CM_UNIT_DELAY
                    #(SRAM_DELAY);
`endif
                    Q_d = {numIOBit{1'bx}};
                    xMemoryAll;
                end // else: !if(iWEB === 1'b0)
            end // if (iCEB === 1'b0)
            else if (iCEB === 1'b1) begin
                idle_flag = 1;
            end
            else begin    //CEB is 'x / 'Z
                idle_flag = 1'bx;                
`ifdef TSMC_CM_NO_WARNING
`else
                $display("\tWarning %m : input CEB unknown/high-Z at simulation time %t\n", $realtime);
`endif
`ifdef TSMC_CM_UNIT_DELAY
                #(SRAM_DELAY);
`endif
                Q_d = {numIOBit{1'bx}};
                xMemoryAll;
            end // else: !if(iCEB === 1'b1)
        end // if ((CLK_i===1) &&(clk_latch===0))
    end
    end
    clk_latch=CLK_i;    //latch CLK_i
end // always @(CLK_i)



always @(posedge CLK_i) begin
    if(SLP_i === 1'b0 && DSLP_i === 1'b0 && SD_i === 1'b0) begin
    if (CLK_i === 1'b1) begin
        CEBL = iCEB;
        WEBL = iWEB;
    end
    end
end

always @(negedge CLK_i) begin
    if(CLK_i === 1'b0 && SLP_i === 1'b0 && DSLP_i === 1'b0 && SD_i === 1'b0 && iCEB !== 1'b0) begin
        invalid_slp = 1'b1;
        invalid_dslp = 1'b1;
    end
end
always @(iCEB) begin
    if((iCEB === 1'b1 | iCEB === 1'bx) && RCEB === 1'b0) begin
        invalid_slp = 1'b0;
        invalid_dslp = 1'b0;
    end
    if((iCEB === 1'b0 || iCEB === 1'bx) && RCEB === 1'b1) begin
        #(0.001);
        invalid_sd_dslp = 1'b0;
    end    
    RCEB = iCEB;
end
always @(posedge SLP_i) begin
    if(SLP_i === 1'b1) begin
        #0.001;
        invalid_slp = 1'b0;
    end
end
always @(posedge DSLP_i) begin
    if(DSLP_i === 1'b1) begin
        #0.001;
        invalid_dslp = 1'b0;
    end
end

always @(SD_i) begin
    if (SD_i === 1'b1 && sd_mode === 1'b0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tInfo %m : Input pins can't be floating after SD goes high within tsdx time at simulation time %t\n", $realtime);
`endif   
    end
    if (SD_i === 1'b0 && DSLP_i === 1'b0 && SLP_i === 1'b0 && sd_mode === 1'b1) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tInfo %m : Input pins can't be floating before SD goes low within txsd time at simulation time %t\n", $realtime);
`endif   
    end
end
always @(DSLP_i) begin
    if (DSLP_i === 1'b1 && dslp_mode === 1'b0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tInfo %m : Input pins can't be floating after DSLP goes high within tdslpx time at simulation time %t\n", $realtime);
`endif   
    end
    if (SD_i === 1'b0 && DSLP_i === 1'b0 && SLP_i === 1'b0 && dslp_mode === 1'b1) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tInfo %m : Input pins can't be floating before DSLP goes low within txdslp time at simulation time %t\n", $realtime);
`endif   
    end
end
always @(SLP_i) begin
    if (SLP_i === 1'b1 && slp_mode === 1'b0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tInfo %m : Input pins can't be floating after SLP goes high within tslpx time at simulation time %t\n", $realtime);
`endif   
    end
    if (SD_i === 1'b0 && DSLP_i === 1'b0 && SLP_i === 1'b0 && slp_mode === 1'b1) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tInfo %m : Input pins can't be floating before SLP goes low within txslp time at simulation time %t\n", $realtime);
`endif   
    end
end

always @(SD_i or DSLP_i or SLP_i) begin
    idle_flag  = 1'b1;
    write_flag = 1'b0;
    read_flag  = 1'b0;
    if (SD_i === 1'bx && $realtime !=0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : input SD unknown/high-Z at simulation time %t\n", $realtime);
`endif
        slp_mode = 1'b0;
        dslp_mode = 1'b0;
        sd_mode = 1'b0;
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d={numIOBit{1'bx}};
        xMemoryAll;
    end
    else if (SD_i === 1'b0 && DSLP_i !== 1'b0 && sd_mode === 1'b1 && $realtime !=0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : Invalid Wake Up Sequence. DSLP must be low before wake up from shut down mode at simulation time %t", $realtime);
`endif
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d={numIOBit{1'bx}};
        xMemoryAll;
        invalid_sd_dslp = 1'b1;
    end        
    else if (SD_i === 1'b0 && sd_mode === 1'b1) begin
        sd_mode = 1'b0;
        slp_mode = SLP_i;
        dslp_mode = DSLP_i;
        if(slp_mode !== 1 && dslp_mode !== 1'b1) begin
`ifdef TSMC_MEM_LOAD_0
            Q_d={numIOBit{1'b0}};
`else
 `ifdef TSMC_MEM_LOAD_1
            Q_d={numIOBit{1'b1}};
 `else
  `ifdef TSMC_MEM_LOAD_RANDOM
            Q_d=$random;
  `else
            Q_d={numIOBit{1'bx}};
  `endif
 `endif
`endif

        end
    end
    else if (SD_i === 1'b1 && sd_mode === 1'b0) begin
`ifdef TSMC_MEM_LOAD_0
        zeroMemoryAll;
`else
 `ifdef TSMC_MEM_LOAD_1
        oneMemoryAll;
 `else
  `ifdef TSMC_MEM_LOAD_RANDOM
        randomMemoryAll;
  `else
        xMemoryAll;
  `endif
 `endif
`endif    
        sd_mode = 1'b1;
        dslp_mode = DSLP_i;
        slp_mode = SLP_i;
        if(|Q_d !== 1'b0 || dslp_mode !== 1'b1 || slp_mode !== 1'b1) begin
            Q_d={numIOBit{1'bx}};
`ifdef TSMC_CM_UNIT_DELAY
            #(SRAM_DELAY);
`else        
            #0.001;
`endif            
        end
        Q_d=0;
    end
    else if (SD_i === 1'b0 && sd_mode === 1'bx) begin
        sd_mode = 1'b0;
    end
    else if (SD_i === 1'b1 && sd_mode === 1'bx) begin
        sd_mode = 1'b1;
    end
    else if (DSLP_i === 1'bx && SLP_i === 1'b0 && SD_i === 1'b0 && $realtime !=0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : input DSLP unknown/high-Z at simulation time %t\n", $realtime);
`endif
        slp_mode = 1'b0;
        dslp_mode = 1'b0;
        sd_mode = 1'b0;
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d={numIOBit{1'bx}};
        xMemoryAll;
    end    
    else if (SD_i === 1'b0 && DSLP_i === 1'b1 && SLP_i === 1'b0 && iCEB !== 1'b1 && dslp_mode === 1'b0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : Invalid Deep Sleep Mode Sequence. Input CEB 0/unknown/high-Z while entering deep sleep mode at simulation time %t", $realtime);
`endif
        slp_mode = 1'b0;
        dslp_mode = 1'b0;
        sd_mode = 1'b0;
        Q_d={numIOBit{1'bx}};
        xMemoryAll;
    end
    else if (SD_i === 1'b0 && DSLP_i === 1'b0 && SLP_i === 1'b0 && iCEB !== 1'b1 && dslp_mode === 1'b1) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : Invalid Wake Up Sequence. Input CEB is 0/unknown/high-Z while exiting sleep mode at simulation time %t", $realtime);
`endif
        slp_mode = 1'b0;
        dslp_mode = 1'b0;
        sd_mode = 1'b0;
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d={numIOBit{1'bx}};
        xMemoryAll;
    end
    else if (DSLP_i === 1'b1 && (iCEB === 1'b1 || $realtime == 0) && dslp_mode === 1'b0) begin
        dslp_mode = 1'b1;
        if(|Q_d !== 1'b0 || (sd_mode !== 1'b1 && slp_mode !== 1'b1) ) begin
            Q_d={numIOBit{1'bx}};
`ifdef TSMC_CM_UNIT_DELAY
            #(SRAM_DELAY);
`else        
            #0.001;
`endif            
        end
        Q_d=0;
    end
    else if (DSLP_i === 1'b0 && iCEB === 1'b1 && dslp_mode === 1'b1) begin
        dslp_mode = 1'b0;
        if(sd_mode !== 1'b1 && slp_mode !== 1'b1) begin
            Q_d={numIOBit{1'bx}};
        end
    end
    else if (DSLP_i === 1'b0 && dslp_mode === 1'bx) begin  //power on
        dslp_mode = 1'b0;
    end
    else if (DSLP_i===1'b1 && dslp_mode === 1'bx) begin //power on
        dslp_mode = 1'b1;
    end
    if (SD_i === 1) begin
`ifdef TSMC_MEM_LOAD_0
        zeroMemoryAll;
`else
 `ifdef TSMC_MEM_LOAD_1
        oneMemoryAll;
 `else
  `ifdef TSMC_MEM_LOAD_RANDOM
        randomMemoryAll;
  `else
        xMemoryAll;
  `endif
 `endif
`endif
    end
    else if (SLP_i === 1'bx && DSLP_i === 1'b0 && SD_i === 1'b0 && $realtime !=0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : input SLP unknown/high-Z at simulation time %t\n", $realtime);
`endif
        slp_mode = 1'b0;
        dslp_mode = 1'b0;
        sd_mode = 1'b0;
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d={numIOBit{1'bx}};
        xMemoryAll;
    end    
    else if (SD_i === 1'b0 && DSLP_i === 1'b0 && SLP_i === 1'b1 && iCEB !== 1'b1 && slp_mode === 1'b0) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : Invalid Sleep Mode Sequence. Input CEB 0/unknown/high-Z while entering sleep mode at simulation time %t", $realtime);
`endif
        slp_mode = 1'b0;
        dslp_mode = 1'b0;
        sd_mode = 1'b0;
        Q_d={numIOBit{1'bx}};
        xMemoryAll;
    end
    else if (SD_i === 1'b0 && DSLP_i === 1'b0 && SLP_i === 1'b0 && iCEB !== 1'b1 && slp_mode === 1'b1) begin
`ifdef TSMC_CM_NO_WARNING
`else
        $display("\tWarning %m : Invalid Wake Up Sequence. Input CEB is 0/unknown/high-Z while exiting sleep mode at simulation time %t", $realtime);
`endif
        slp_mode = 1'b0;
        dslp_mode = 1'b0;
        sd_mode = 1'b0;
`ifdef TSMC_CM_UNIT_DELAY
        #(SRAM_DELAY);
`endif
        Q_d={numIOBit{1'bx}};
        xMemoryAll;
    end
    else if (SLP_i === 1'b1 && (iCEB === 1'b1 || $realtime == 0) && slp_mode === 1'b0) begin
        slp_mode = 1'b1;
        if(|Q_d !== 1'b0 || (sd_mode !== 1'b1 && dslp_mode !== 1'b1) ) begin
            Q_d={numIOBit{1'bx}};
`ifdef TSMC_CM_UNIT_DELAY
            #(SRAM_DELAY);
`else        
            #0.001;
`endif            
        end
        Q_d=0;
    end
    else if (SLP_i === 1'b0 && iCEB === 1'b1 && slp_mode === 1'b1) begin
        slp_mode = 1'b0;
        if(sd_mode !== 1'b1 && dslp_mode !== 1'b1) begin
            Q_d={numIOBit{1'bx}};
        end
    end
    else if (SLP_i === 1'b0 && slp_mode === 1'bx) begin  //power on
        slp_mode = 1'b0;
    end
    else if (SLP_i===1'b1 && slp_mode === 1'bx) begin //power on
        slp_mode = 1'b1;
    end
    if (SD_i === 1) begin
`ifdef TSMC_MEM_LOAD_0
        zeroMemoryAll;
`else
 `ifdef TSMC_MEM_LOAD_1
        oneMemoryAll;
 `else
  `ifdef TSMC_MEM_LOAD_RANDOM
        randomMemoryAll;
  `else
        xMemoryAll;
  `endif
 `endif
`endif
    end
end




`ifdef TSMC_CM_UNIT_DELAY
`else
always @(notify_sd_dslp) begin
    invalid_sd_dslp = 1'b1;
    Q_d = {numIOBit{1'bx}};
    xMemoryAll;
end

always @(notify_sd) begin
    #0.01;
    Q_d = {numIOBit{1'bx}};
    xMemoryAll;
end
always @(notify_dslp) begin
    #0.01;
    Q_d = {numIOBit{1'bx}};
    xMemoryAll;
end
always @(notify_slp) begin
    #0.01;
    Q_d = {numIOBit{1'bx}};
    xMemoryAll;
end
always @(notify_testpin) begin
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
      Q_d = {numIOBit{1'bx}};
      xMemoryAll;
    end
    else if(bDFTBYP === 1'b0) begin
      Q_d = {numIOBit{1'bx}};
    end
end


always @(notify_clk) begin
    disable CLK_OPERATION;
    if (bDFTBYP === 1'b0 && bSE === 1'b0) begin
        Q_d = {numIOBit{1'bx}};
        xMemoryAll;
    end
    else if(bDFTBYP === 1'b0) begin 
        Q_d = {numIOBit{1'bx}};
    end
end
always @(notify_bist) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
      Q_d = {numIOBit{1'bx}};
      xMemoryAll;
    end
    else if(bDFTBYP === 1'b0) begin
      Q_d = {numIOBit{1'bx}};
    end
end
always @(notify_ceb) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        Q_d = {numIOBit{1'bx}};
        xMemoryAll;
        read_flag = 0;
        write_flag = 0;
    end
    else if(bDFTBYP === 1'b0) begin
      Q_d = {numIOBit{1'bx}};
    end
end
always @(notify_web) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        Q_d = {numIOBit{1'bx}};
        xMemoryAll;
        read_flag = 0;
        write_flag = 0;
    end
end
always @(notify_addr) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if (iWEB === 1'b1) begin
            Q_d = {numIOBit{1'bx}};           
        end
        else if (iWEB === 1'b0) begin
        end
        else begin
            Q_d = {numIOBit{1'bx}};
        end        
        xMemoryAll;
        read_flag = 0;
        write_flag = 0;
    end
    else if(bDFTBYP === 1'b0) begin
        Q_d = {numIOBit{1'bx}};        
    end
end
always @(notify_d0) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 0);
        end
        write_flag = 0;
    end
end

always @(notify_bweb0) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 0);
        end
        write_flag = 0;
    end
end
always @(notify_d1) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 1);
        end
        write_flag = 0;
    end
end

always @(notify_bweb1) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 1);
        end
        write_flag = 0;
    end
end
always @(notify_d2) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 2);
        end
        write_flag = 0;
    end
end

always @(notify_bweb2) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 2);
        end
        write_flag = 0;
    end
end
always @(notify_d3) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 3);
        end
        write_flag = 0;
    end
end

always @(notify_bweb3) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 3);
        end
        write_flag = 0;
    end
end
always @(notify_d4) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 4);
        end
        write_flag = 0;
    end
end

always @(notify_bweb4) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 4);
        end
        write_flag = 0;
    end
end
always @(notify_d5) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 5);
        end
        write_flag = 0;
    end
end

always @(notify_bweb5) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 5);
        end
        write_flag = 0;
    end
end
always @(notify_d6) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 6);
        end
        write_flag = 0;
    end
end

always @(notify_bweb6) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 6);
        end
        write_flag = 0;
    end
end
always @(notify_d7) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 7);
        end
        write_flag = 0;
    end
end

always @(notify_bweb7) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 7);
        end
        write_flag = 0;
    end
end
always @(notify_d8) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 8);
        end
        write_flag = 0;
    end
end

always @(notify_bweb8) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 8);
        end
        write_flag = 0;
    end
end
always @(notify_d9) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 9);
        end
        write_flag = 0;
    end
end

always @(notify_bweb9) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 9);
        end
        write_flag = 0;
    end
end
always @(notify_d10) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 10);
        end
        write_flag = 0;
    end
end

always @(notify_bweb10) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 10);
        end
        write_flag = 0;
    end
end
always @(notify_d11) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 11);
        end
        write_flag = 0;
    end
end

always @(notify_bweb11) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 11);
        end
        write_flag = 0;
    end
end
always @(notify_d12) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 12);
        end
        write_flag = 0;
    end
end

always @(notify_bweb12) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 12);
        end
        write_flag = 0;
    end
end
always @(notify_d13) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 13);
        end
        write_flag = 0;
    end
end

always @(notify_bweb13) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 13);
        end
        write_flag = 0;
    end
end
always @(notify_d14) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 14);
        end
        write_flag = 0;
    end
end

always @(notify_bweb14) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 14);
        end
        write_flag = 0;
    end
end
always @(notify_d15) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 15);
        end
        write_flag = 0;
    end
end

always @(notify_bweb15) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 15);
        end
        write_flag = 0;
    end
end
always @(notify_d16) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 16);
        end
        write_flag = 0;
    end
end

always @(notify_bweb16) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 16);
        end
        write_flag = 0;
    end
end
always @(notify_d17) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 17);
        end
        write_flag = 0;
    end
end

always @(notify_bweb17) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 17);
        end
        write_flag = 0;
    end
end
always @(notify_d18) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 18);
        end
        write_flag = 0;
    end
end

always @(notify_bweb18) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 18);
        end
        write_flag = 0;
    end
end
always @(notify_d19) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 19);
        end
        write_flag = 0;
    end
end

always @(notify_bweb19) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 19);
        end
        write_flag = 0;
    end
end
always @(notify_d20) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 20);
        end
        write_flag = 0;
    end
end

always @(notify_bweb20) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 20);
        end
        write_flag = 0;
    end
end
always @(notify_d21) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 21);
        end
        write_flag = 0;
    end
end

always @(notify_bweb21) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 21);
        end
        write_flag = 0;
    end
end
always @(notify_d22) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 22);
        end
        write_flag = 0;
    end
end

always @(notify_bweb22) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 22);
        end
        write_flag = 0;
    end
end
always @(notify_d23) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 23);
        end
        write_flag = 0;
    end
end

always @(notify_bweb23) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 23);
        end
        write_flag = 0;
    end
end
always @(notify_d24) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 24);
        end
        write_flag = 0;
    end
end

always @(notify_bweb24) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 24);
        end
        write_flag = 0;
    end
end
always @(notify_d25) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 25);
        end
        write_flag = 0;
    end
end

always @(notify_bweb25) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 25);
        end
        write_flag = 0;
    end
end
always @(notify_d26) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 26);
        end
        write_flag = 0;
    end
end

always @(notify_bweb26) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 26);
        end
        write_flag = 0;
    end
end
always @(notify_d27) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 27);
        end
        write_flag = 0;
    end
end

always @(notify_bweb27) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 27);
        end
        write_flag = 0;
    end
end
always @(notify_d28) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 28);
        end
        write_flag = 0;
    end
end

always @(notify_bweb28) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 28);
        end
        write_flag = 0;
    end
end
always @(notify_d29) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 29);
        end
        write_flag = 0;
    end
end

always @(notify_bweb29) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 29);
        end
        write_flag = 0;
    end
end
always @(notify_d30) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 30);
        end
        write_flag = 0;
    end
end

always @(notify_bweb30) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 30);
        end
        write_flag = 0;
    end
end
always @(notify_d31) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin 
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 31);
        end
        write_flag = 0;
    end
end

always @(notify_bweb31) begin
    disable CLK_OPERATION;
    if(bDFTBYP === 1'b0 && bSE === 1'b0) begin
        if ( ^iA === 1'bx ) begin
            xMemoryAll;
        end
        else begin
            xMemoryBit(iA, 31);
        end
        write_flag = 0;
    end
end


`endif    //end `ifdef TSMC_CM_UNIT_DELAY


task xMemoryAll;
integer row;
integer col;
integer row_index;
integer col_index;
begin
    for (row_index = 0; row_index <= numRow-1; row_index = row_index + 1) begin
        for (col_index = 0; col_index <= numCM-1; col_index = col_index + 1) begin
            row=row_index;
            col=col_index;
            MEMORY[row][col] = {numBit{1'bx}};
        end
    end
    if( MES_ALL=="ON" && $realtime != 0) $display("\nInfo : Set Memory Content to all x at %t.>>", $realtime);
end
endtask

task zeroMemoryAll;
integer row;
integer col;
integer row_index;
integer col_index;
begin
    for (row_index = 0; row_index <= numRow-1; row_index = row_index + 1) begin
        for (col_index = 0; col_index <= numCM-1; col_index = col_index + 1) begin
            row=row_index;
            col=col_index;
            MEMORY[row][col] = {numBit{1'b0}};
        end
    end
    if( MES_ALL=="ON" && $realtime != 0) $display("\nInfo : Set Memory Content to all 0 at %t.>>", $realtime);
end
endtask

task oneMemoryAll;
integer row;
integer col;
integer row_index;
integer col_index;
begin
    for (row_index = 0; row_index <= numRow-1; row_index = row_index + 1) begin
        for (col_index = 0; col_index <= numCM-1; col_index = col_index + 1) begin
            row=row_index;
            col=col_index;
            MEMORY[row][col] = {numBit{1'b1}};
        end
    end
    if( MES_ALL=="ON" && $realtime != 0) $display("\nInfo : Set Memory Content to all 1 at %t.>>", $realtime);
end
endtask

task randomMemoryAll;
integer row;
integer col;
integer row_index;
integer col_index;
begin
    for (row_index = 0; row_index <= numRow-1; row_index = row_index + 1) begin
        for (col_index = 0; col_index <= numCM-1; col_index = col_index + 1) begin
            row=row_index;
            col=col_index;
            MEMORY[row][col] = $random;
        end
    end
    if( MES_ALL=="ON" && $realtime != 0) $display("\nInfo : Set Memory Content to random patterns at %t.>>", $realtime);
end
endtask

task xMemoryWord;
input [numWordAddr-1:0] addr;
reg [numRowAddr-1:0] row;
reg [numCMAddr-1:0] col;
begin
    {row, col} = addr;
    MEMORY[row][col] = {numBit{1'bx}};
end
endtask

task xMemoryBit;
input [numWordAddr-1:0] addr;
input integer abit;
reg [numRowAddr-1:0] row;
reg [numCMAddr-1:0] col;
begin
    {row, col} = addr;
    MEMORY[row][col][abit] = 1'bx;
end
endtask

task preloadData;
input [256*8:1] infile;  // Max 256 character File Name
reg [numWordAddr:0] w;
reg [numWordAddr-numCMAddr-1:0] row;
reg [numCMAddr-1:0] col;
begin
`ifdef TSMC_CM_NO_WARNING
`else
    $display("Preloading data from file %s", infile);
`endif
`ifdef TSMC_INITIALIZE_FORMAT_BINARY
        $readmemb(infile, PRELOAD);
`else
        $readmemh(infile, PRELOAD);
`endif
    for (w = 0; w < numWord; w = w + 1) begin
        {row, col} = w;
        MEMORY[row][col] = PRELOAD[w];
    end
end
endtask

/*
 * task injectSA - to inject a stuck-at error, please use hierarchical reference to call the injectSA task from the wrapper module
 *      input addr - the address location where the defect is to be introduced
 *      input bit - the bit location of the specified address where the defect is to occur
 *      input type - specify whether it's a s-a-0 (type = 0) or a s-a-1 (type = 1) fault
 *
 *      Multiple faults can be injected at the same address, regardless of the type.  This means that an address location can have 
 *      certain bits having stuck-at-0 faults while other bits have the stuck-at-1 defect.
 *
 * Examples:
 *      injectSA(0, 0, 0);  - injects a s-a-0 fault at address 0, bit 0
 *      injectSA(1, 0, 1);  - injects a s-a-1 fault at address 1, bit 0
 *      injectSA(1, 1, 0);  - injects a s-a-0 fault at address 1, bit 1
 *      injectSA(1, 2, 1);  - injects a s-a-1 fault at address 1, bit 2
 *      injectSA(1, 3, 1);  - injects a s-a-1 fault at address 1, bit 3
 *      injectSA(2, 2, 1);  - injects a s-a-1 fault at address 2, bit 2
 *      injectSA(14, 2, 0); - injects a s-a-0 fault at address 14, bit 2
 *
 */
`ifdef TSMC_STUCKAT_FAULT
task injectSA;
input [numWordAddr-1:0] addr;
input integer bitn;
input typen;
reg [numStuckAt:0] i;
reg [numBit-1:0] btmp;
begin
    j=bitn;
    if ( typen === 0 ) begin
        for (i = 0; i < numStuckAt; i = i + 1) begin
            if ( ^stuckAt0Addr[i] === 1'bx ) begin
                stuckAt0Addr[i] = addr;
                btmp = {numBit{1'bx}};
                btmp[j] = 1'b0;
                stuckAt0Bit[i] = btmp;
                i = numStuckAt;
`ifdef TSMC_CM_NO_WARNING
`else
                $display("First s-a-0 error injected at address location %d = %b", addr, btmp);
`endif
                i = numStuckAt;
            end
            else if ( stuckAt0Addr[i] === addr ) begin
                btmp = stuckAt0Bit[i];
                btmp[j] = 1'b0;
                stuckAt0Bit[i] = btmp;
`ifdef TSMC_CM_NO_WARNING
`else
                $display("More s-a-0 Error injected at address location %d = %b", addr, btmp);
`endif
                i = numStuckAt;
            end        
        end
    end
    else if (typen === 1) begin
        for (i = 0; i < numStuckAt; i = i + 1) begin
            if ( ^stuckAt1Addr[i] === 1'bx ) begin
                stuckAt1Addr[i] = addr;
                btmp = {numBit{1'bx}};
                btmp[j] = 1'b1;
                stuckAt1Bit[i] = btmp;
                i = numStuckAt;
`ifdef TSMC_CM_NO_WARNING
`else
                $display("First s-a-1 error injected at address location %d = %b", addr, btmp);
`endif
                i = numStuckAt;
            end
            else if ( stuckAt1Addr[i] === addr ) begin
                btmp = stuckAt1Bit[i];
                btmp[j] = 1'b1;
                stuckAt1Bit[i] = btmp;
`ifdef TSMC_CM_NO_WARNING
`else
                $display("More s-a-1 Error injected at address location %d = %b", addr, btmp);
`endif
                i = numStuckAt;
            end        
        end
    end
end
endtask

task combineErrors;
input [numWordAddr-1:0] addr;
output [numBit-1:0] errors;
integer j;
reg [numBit-1:0] btmp;
begin
    errors = {numBit{1'bx}};
    if ( isStuckAt0(addr) ) begin
        btmp = stuckAt0Bit[getStuckAt0Index(addr)];
        for ( j = 0; j < numBit; j = j + 1 ) begin
            if ( btmp[j] === 1'b0 ) begin
                errors[j] = 1'b0;
            end
        end
    end
    if ( isStuckAt1(addr) ) begin
        btmp = stuckAt1Bit[getStuckAt1Index(addr)];
        for ( j = 0; j < numBit; j = j + 1 ) begin
            if ( btmp[j] === 1'b1 ) begin
                errors[j] = 1'b1;
            end
        end
    end
end
endtask

function [numStuckAt-1:0] getStuckAt0Index;
input [numWordAddr-1:0] addr;
reg [numStuckAt:0] i;
begin
    for (i = 0; i < numStuckAt; i = i + 1) begin
        if (stuckAt0Addr[i] === addr) begin
            getStuckAt0Index = i;
        end
    end
end
endfunction

function [numStuckAt-1:0] getStuckAt1Index;
input [numWordAddr-1:0] addr;
reg [numStuckAt:0] i;
begin
    for (i = 0; i < numStuckAt; i = i + 1) begin
        if (stuckAt1Addr[i] === addr) begin
            getStuckAt1Index = i;
        end
    end
end
endfunction

function isStuckAt0;
input [numWordAddr-1:0] addr;
reg [numStuckAt:0] i;
reg flag;
begin
    flag = 0;
    for (i = 0; i < numStuckAt; i = i + 1) begin
        if (stuckAt0Addr[i] === addr) begin
            flag = 1;
            i = numStuckAt;
        end
    end
    isStuckAt0 = flag;
end
endfunction

function isStuckAt1;
input [numWordAddr-1:0] addr;
reg [numStuckAt:0] i;
reg flag;
begin
    flag = 0;
    for (i = 0; i < numStuckAt; i = i + 1) begin
        if (stuckAt1Addr[i] === addr) begin
            flag = 1;
            i = numStuckAt;
        end
    end
    isStuckAt1 = flag;
end
endfunction
`endif

task printMemory;
reg [numRowAddr-1:0] row;
reg [numCMAddr-1:0] col;
reg [numRowAddr:0] row_index;
reg [numCMAddr:0] col_index;
begin
    $display("\n\nDumping memory content at %t...\n", $realtime);
    for (row_index = 0; row_index <= numRow-1; row_index = row_index + 1) begin
        for (col_index = 0; col_index <= numCM-1; col_index = col_index + 1) begin
            row=row_index;
            col=col_index;
            $display("[%d] = %b", {row, col}, MEMORY[row][col]);
        end
    end    
    $display("\n\n");
end
endtask

task printMemoryFromTo;
input [numWordAddr-1:0] addr1;
input [numWordAddr-1:0] addr2;
reg [numWordAddr:0] addr;
reg [numRowAddr-1:0] row;
reg [numCMAddr-1:0] col;
begin
    $display("\n\nDumping memory content at %t...\n", $realtime);
    for (addr = addr1; addr < addr2; addr = addr + 1) begin
        {row, col} = addr;
        $display("[%d] = %b", addr, MEMORY[row][col]);
    end    
    $display("\n\n");
end
endtask




endmodule
`endcelldefine