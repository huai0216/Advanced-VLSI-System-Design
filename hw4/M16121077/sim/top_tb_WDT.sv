`include "monitor.sv"
`include "CYCLE_MAX.sv"
`timescale 1ns/10ps
// clock define (don't modify)
`define DRAM_CYCLE    5.0    // 200Mhz
`define ROM_CYCLE     50.1   // 100Mhz
`define AXI_CYCLE     2.5    // 200Mhz



`ifdef SYN
`include "CHIP_syn.v"
`include "data_array/data_array_rtl.sv"
`include "tag_array/tag_array_rtl.sv"
`include "SRAM/SRAM_rtl.sv"
`timescale 1ns/10ps
`include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v"
`include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdio/N16ADFP_StdIO/VERILOG/N16ADFP_StdIO.v"
`elsif PR
`include "../pr/CHIP_pr.v"
`include "SRAM/SRAM_rtl.sv"
`include "data_array/data_array_rtl.sv"
`include "tag_array/tag_array_rtl.sv"
`timescale 1ns/10ps
`include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v"
`include "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdio/N16ADFP_StdIO/VERILOG/N16ADFP_StdIO.v"																						  
`else
//`include "top.sv"
`include "CHIP.v"
`include "SRAM/SRAM_rtl.sv"
`include "data_array/data_array_rtl.sv"
`include "tag_array/tag_array_rtl.sv"
`endif

`include "ROM/ROM.v"
`include "DRAM/DRAM.sv"

`define ismem_word(addr) \
  {chip.u_TOP.DM1.i_SRAM.MEMORY[addr >> 5][(addr&6'b011111)]}

`define mem_word(addr) \
  {chip.u_TOP.DM1.i_SRAM.MEMORY[addr >> 5][(addr&6'b011111)]}

`define dram_word(addr) \
  {i_DRAM.Memory_byte3[addr], \
  i_DRAM.Memory_byte2[addr], \
  i_DRAM.Memory_byte1[addr], \
  i_DRAM.Memory_byte0[addr]}

`define SIM_END 'h3fff
`define SIM_END_CODE -32'd1
`define TEST_START 'h40000
`define BOOT_END 'h40002	//DRAM
`define BOOT_END_CODE -32'd1 //flag
`define FOR_LOOP_ADDR 'h153 //SRAM 1054C
`define FOR_LOOP_DEAD_LOOP 'h6f
`define FOR_LOOP_COUNT_INIT 'ha00793
`define mask  2000

module top_tb;

  logic cpu_clk;
  logic axi_clk;
  logic dram_clk;
  logic rom_clk;
  logic rst;
  logic [31:0] GOLDEN[4096];
  logic [7:0] Memory_byte0[16383:0];
  logic [7:0] Memory_byte1[16383:0];
  logic [7:0] Memory_byte2[16383:0];
  logic [7:0] Memory_byte3[16383:0];
  logic [31:0] Memory_word[16383:0];
  //HW4
  logic [31:0] ROM_out;
  logic [31:0] DRAM_Q;
  logic ROM_enable;
  logic ROM_read;
  logic [11:0] ROM_address;
  logic DRAM_CSn;
  logic [3:0]DRAM_WEn;
  logic DRAM_RASn;
  logic DRAM_CASn;
  logic [10:0] DRAM_A;
  logic [31:0] DRAM_D; 
  logic DRAM_valid;

  logic [31:0] sensor_mem [0:511];  
  logic [9:0] data_counter;  
  //HW4
  integer gf, i, num,delay_c;
  logic [31:0] temp;
  integer err;
  string prog_path;
  logic cpu_rst ;
  logic axi_rst ;
  logic rom_rst ;
  logic dram_rst;
  
  always #(`CPU_CYCLE/2)    cpu_clk     = ~cpu_clk;
  always #(`AXI_CYCLE/2)    axi_clk     = ~axi_clk;
  always #(`DRAM_CYCLE/2)   dram_clk    = ~dram_clk;
  always #(`ROM_CYCLE/2)    rom_clk     = ~rom_clk;


  // module instantiation
  CHIP chip(
    .cpu_clk		(cpu_clk    ),      //  
    .axi_clk		(axi_clk    ),      //  
    .rom_clk        (rom_clk    ),      //  
    .dram_clk       (dram_clk   ),      //  
    .cpu_rst		(cpu_rst    ),      //  
    .axi_rst		(axi_rst    ),      //  
    .rom_rst        (rom_rst    ),      //  
    .dram_rst       (dram_rst   ),      //  
    .ROM_out        (ROM_out    ),      //  
    .DRAM_valid     (DRAM_valid ),      //  
    .DRAM_Q         (DRAM_Q     ),      //  
    .ROM_read       (ROM_read   ),      //  
    .ROM_enable     (ROM_enable ),      //  
    .ROM_address    (ROM_address),      //  
    .DRAM_CSn       (DRAM_CSn   ),      //  
    .DRAM_WEn       (DRAM_WEn   ),      //  
    .DRAM_RASn      (DRAM_RASn  ),      //  
    .DRAM_CASn      (DRAM_CASn  ),      //  
    .DRAM_A         (DRAM_A     ),      //  
    .DRAM_D         (DRAM_D     )       //  
  );

  
  ROM i_ROM(
    .CK             (rom_clk      ), // ROM CLOCK DOMAIN
    .CS             (ROM_enable   ),
    .OE             (ROM_read     ),
    .A              (ROM_address  ),
    .DO             (ROM_out      )
  );

   DRAM i_DRAM(
    .CK             (dram_clk     ), // DRAM CLOCK DOMAIN
    .Q              (DRAM_Q       ),
    .RST            (dram_rst     ),
    .CSn            (DRAM_CSn     ),
    .WEn            (DRAM_WEn     ),
    .RASn           (DRAM_RASn    ),
    .CASn           (DRAM_CASn    ),
    .A              (DRAM_A       ),
    .D              (DRAM_D       ),
    .VALID          (DRAM_valid   )
  );
  
  initial begin
    int boot_end_flag = 0;
    int only_pose1 = 0;
    int only_pose2 = 0;
    int cycle_number = 0;
    while (1) begin
      #(`CPU_CYCLE)
      if (`dram_word(`TEST_START) != only_pose1 && `dram_word(`TEST_START) == `BOOT_END_CODE && boot_end_flag == 0) begin
        $display("`dram_word(`TEST_START) = %x, cycle_number = %d",`dram_word(`TEST_START),cycle_number);
        boot_end_flag = 1;
        `ismem_word(`FOR_LOOP_ADDR) = `FOR_LOOP_DEAD_LOOP;
        $display("`ismem_word(`FOR_LOOP_ADDR) = %x",`ismem_word(`FOR_LOOP_ADDR));
        $display($time);
      end else if (`dram_word(`TEST_START) != only_pose1 && `dram_word(`TEST_START) == `BOOT_END_CODE && boot_end_flag == 1) begin
        $display("`dram_word(`TEST_START)2 = %x, cycle_number = %d",`dram_word(`TEST_START),cycle_number);
        boot_end_flag = 2;
        `ismem_word(`FOR_LOOP_ADDR) = `FOR_LOOP_COUNT_INIT;
        $display($time);
      end
      cycle_number = cycle_number + 1;
      only_pose1 = `dram_word(`TEST_START);
    end
  end
  
  // reset release sequence (DRAM -> ROM -> SRAM -> AXI -> CPU)
  initial begin
    dram_rst = 1;
    rom_rst  = 1;
    axi_rst  = 1;
    cpu_rst  = 1;
	// mask     = 0;
	#(`mask)
	// mask     = 1;
    @(posedge dram_clk)
    #(1); // small number 
    dram_rst = 0;
    @(posedge rom_clk)
    #(1); // small number 
    rom_rst = 0;
    @(posedge axi_clk)
    #(1); // small number 
    axi_rst = 0;
    @(posedge cpu_clk)
    #(15); // small number 
    cpu_rst = 0;
  end
  
  initial
  begin
    // reset
    cpu_clk         = 0;  	
    axi_clk         = 0;
    dram_clk        = 0;
    rom_clk         = 0;
    data_counter    = 0;
    $value$plusargs("prog_path=%s", prog_path);
    // wait for dram reset = 0 
    wait(dram_rst)
    wait(~dram_rst)
    $readmemh({prog_path, "/rom0.hex"}, i_ROM.Memory_byte0);
    $readmemh({prog_path, "/rom1.hex"}, i_ROM.Memory_byte1);
    $readmemh({prog_path, "/rom2.hex"}, i_ROM.Memory_byte2);
    $readmemh({prog_path, "/rom3.hex"}, i_ROM.Memory_byte3);
    $readmemh({prog_path, "/dram0.hex"}, i_DRAM.Memory_byte0);
    $readmemh({prog_path, "/dram1.hex"}, i_DRAM.Memory_byte1);
    $readmemh({prog_path, "/dram2.hex"}, i_DRAM.Memory_byte2);
    $readmemh({prog_path, "/dram3.hex"}, i_DRAM.Memory_byte3);

    num = 0;
    gf = $fopen({prog_path, "/golden.hex"}, "r");
    while (!$feof(gf)) begin
      $fscanf(gf, "%h\n", GOLDEN[num]);
      num++;
    end
    $fclose(gf);

    while (1) begin
      @(negedge cpu_clk)
      if (`mem_word(`SIM_END) == `SIM_END_CODE) break;

    end	
    $display("\nDone\n");
    err = 0;

    for (i = 0; i < num; i++) begin
      if (`dram_word(`TEST_START + i) !== GOLDEN[i]) begin
        $display("DRAM[%4d] = %h, expect = %h", `TEST_START + i, `dram_word(`TEST_START + i), GOLDEN[i]);
        err = err + 1;
      end else begin
        $display("DRAM[%4d] = %h, pass", `TEST_START + i, `dram_word(`TEST_START + i));
      end
    end
    result(err, num);
    // mem_monitor; // get memory value
    $finish;
  end

  `ifdef SYN
    initial $sdf_annotate("../syn/CHIP_syn.sdf", chip);
  `elsif PR
    initial $sdf_annotate("../pr/CHIP_pr.sdf", chip);
  `endif

  initial begin
    `ifdef FSDB
      $fsdbDumpfile("chip.fsdb");
      //$fsdbDumpvars(0, TOP);
    $fsdbDumpvars;
    `elsif FSDB_ALL
      $fsdbDumpfile("chip.fsdb");
      $fsdbDumpvars("+struct", "+mda", chip);
      $fsdbDumpvars("+struct", "+mda", i_DRAM);
      // $fsdbDumpvars("+struct", i_DRAM);
    `endif
    // if reach maximum simulation time
    #(`CPU_CYCLE*`MAX)
    for (i = 0; i < num; i++) begin
      if (`dram_word(`TEST_START + i) !== GOLDEN[i]) begin
        $display("DRAM[%4d] = %h, expect = %h", `TEST_START + i, `dram_word(`TEST_START + i), GOLDEN[i]);
        err=err+1;
      end else begin
        $display("DRAM[%4d] = %h, pass", `TEST_START + i, `dram_word(`TEST_START + i));
      end
    end
    $display("SIM_END(%5d) = %h, expect = %h", `SIM_END, `dram_word(`SIM_END), `SIM_END_CODE);
    result(num, num);
    // mem_monitor; // get memory value
    $finish;
  end
  
  task result;
    input integer err;
    input integer num;
    integer rf;
    begin
      `ifdef SYN
        rf = $fopen({prog_path, "/result_syn.txt"}, "w");
      `elsif PR
        rf = $fopen({prog_path, "/result_pr.txt"}, "w");
      `else
        rf = $fopen({prog_path, "/result_rtl.txt"}, "w");
      `endif
      $fdisplay(rf, "%d,%d", num - err, num);
      if (err === 0) begin
        $display("\n");
        $display("\n");
        $display("        **************************               ");
        $display("        *                        *       |\__||  ");
        $display("        *  Congratulations !!    *      / O.O  | ");
        $display("        *                        *    /_____   | ");
        $display("        *  Simulation PASS!!     *   /^ ^ ^ \\  |");
        $display("        *                        *  |^ ^ ^ ^ |w| ");
        $display("        **************************   \\m___m__|_|");
        $display("\n");
      end else begin
        $display("\n");
        $display("\n");
        $display("        **************************               ");
        $display("        *                        *       |\__||  ");
        $display("        *  OOPS!!                *      / X,X  | ");
        $display("        *                        *    /_____   | ");
        $display("        *  Simulation Failed!!   *   /^ ^ ^ \\  |");
        $display("        *                        *  |^ ^ ^ ^ |w| ");
        $display("        **************************   \\m___m__|_|");
        $display("         Totally has %d errors                     ", err); 
        $display("\n");
      end
      $display("                  %10s %10s", "CYCLE", "FREQ");
      $display("        DRAM    : %10f %10f", `DRAM_CYCLE, (1000/`DRAM_CYCLE));
      $display("        ROM     : %10f %10f", `ROM_CYCLE, (1000/`ROM_CYCLE));
      $display("        CPU     : %10f %10f", `CPU_CYCLE, (1000/`CPU_CYCLE));
      $display("        AXI     : %10f %10f", `AXI_CYCLE, (1000/`AXI_CYCLE));
    end
  endtask
  
  
endmodule