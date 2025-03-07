#####CLK PERIOD CAN BE ADJUSTED UP TO 5.0 IF SYNTHESIS GOES WRONG#####
set cpu_clk_period 1.0

set axi_clk_period 2.5
set rom_clk_period 50.1
set dram_clk_period 5.0

create_clock -name cpu_clk  -period $cpu_clk_period  [get_ports cpu_clk]
create_clock -name axi_clk  -period $axi_clk_period  [get_ports axi_clk]
create_clock -name rom_clk  -period $rom_clk_period  [get_ports rom_clk]
create_clock -name dram_clk -period $dram_clk_period  [get_ports dram_clk]
set_clock_groups -asynchronous -group {cpu_clk} -group {axi_clk} -group {rom_clk} -group {dram_clk}

set_dont_touch_network      [all_clocks]
set_fix_hold                [all_clocks]
set_clock_uncertainty  0.1  [all_clocks]
set_clock_latency      0.5  [all_clocks]
set_input_transition   0.2  [all_inputs]
set_clock_transition   0.1  [all_clocks]
set_ideal_network           [all_clocks]
set_ideal_network           [get_pins ipad_cpu_clk/C]
set_ideal_network           [get_pins ipad_axi_clk/C]
set_ideal_network           [get_pins ipad_rom_clk/C]
set_ideal_network           [get_pins ipad_dram_clk/C]

set_operating_conditions -min_library N16ADFP_StdCellff0p88v125c -min ff0p88v125c \
                         -max_library N16ADFP_StdCellss0p72vm40c -max ss0p72vm40c
# cpu_clk
set input_max_cpu_clk   [expr {double(round(1000*$cpu_clk_period * 0.6))/1000}]
set input_min_cpu_clk   [expr {double(round(1000*$cpu_clk_period * 0.0))/1000}]
set output_max_cpu_clk  [expr {double(round(1000*$cpu_clk_period * 0.1))/1000}]
set output_min_cpu_clk  [expr {double(round(1000*$cpu_clk_period * 0.0))/1000}]

set_input_delay  -max $input_max_cpu_clk  -clock cpu_clk [remove_from_collection [all_inputs] [get_ports {cpu_clk}]]
set_input_delay  -min $input_min_cpu_clk  -clock cpu_clk [remove_from_collection [all_inputs] [get_ports {cpu_clk}]]
set_output_delay -max $output_max_cpu_clk -clock cpu_clk [all_outputs]
set_output_delay -min $output_min_cpu_clk -clock cpu_clk [all_outputs]

# axi_clk
set input_max_axi_clk   [expr {double(round(1000*$axi_clk_period * 0.6))/1000}]
set input_min_axi_clk   [expr {double(round(1000*$axi_clk_period * 0.0))/1000}]
set output_max_axi_clk  [expr {double(round(1000*$axi_clk_period * 0.1))/1000}]
set output_min_axi_clk  [expr {double(round(1000*$axi_clk_period * 0.0))/1000}]

set_input_delay  -max $input_max_axi_clk  -clock axi_clk [remove_from_collection [all_inputs] [get_ports {axi_clk}]]
set_input_delay  -min $input_min_axi_clk  -clock axi_clk [remove_from_collection [all_inputs] [get_ports {axi_clk}]]
set_output_delay -max $output_max_axi_clk -clock axi_clk [all_outputs]
set_output_delay -min $output_min_axi_clk -clock axi_clk [all_outputs]

# rom_clk
set input_max_rom_clk   [expr {double(round(1000*$rom_clk_period * 0.6))/1000}]
set input_min_rom_clk   [expr {double(round(1000*$rom_clk_period * 0.0))/1000}]
set output_max_rom_clk  [expr {double(round(1000*$rom_clk_period * 0.1))/1000}]
set output_min_rom_clk  [expr {double(round(1000*$rom_clk_period * 0.0))/1000}]

set_input_delay  -max $input_max_rom_clk  -clock rom_clk [remove_from_collection [all_inputs] [get_ports {rom_clk}]]
set_input_delay  -min $input_min_rom_clk  -clock rom_clk [remove_from_collection [all_inputs] [get_ports {rom_clk}]]
set_output_delay -max $output_max_rom_clk -clock rom_clk [all_outputs]
set_output_delay -min $output_min_rom_clk -clock rom_clk [all_outputs]

# dram_clk
set input_max_dram_clk   [expr {double(round(1000*$dram_clk_period * 0.6))/1000}]
set input_min_dram_clk   [expr {double(round(1000*$dram_clk_period * 0.0))/1000}]
set output_max_dram_clk  [expr {double(round(1000*$dram_clk_period * 0.1))/1000}]
set output_min_dram_clk  [expr {double(round(1000*$dram_clk_period * 0.0))/1000}]

set_input_delay  -max $input_max_dram_clk  -clock dram_clk [remove_from_collection [all_inputs] [get_ports {dram_clk}]]
set_input_delay  -min $input_min_dram_clk  -clock dram_clk [remove_from_collection [all_inputs] [get_ports {dram_clk}]]
set_output_delay -max $output_max_dram_clk -clock dram_clk [all_outputs]
set_output_delay -min $output_min_dram_clk -clock dram_clk [all_outputs]



#set_driving_cell -library fsa0m_a_t33_generic_io_ss1p62v125c -lib_cell XMD -pin {O} [all_inputs]
#set_drive 0.1  [all_inputs]
set_load [load_of "N16ADFP_StdIOss0p72v1p62v125c/PDCDG_H/PAD"] [all_outputs]
set_load [load_of "N16ADFP_StdIOss0p72v1p62v125c/PDCDG_V/PAD"] [all_outputs]


#set_driving_cell -library N16ADFP_StdCellss0p72vm40c -lib_cell BUFFD4BWP16P90LVT -pin {Z} [get_ports {cpu_clk axi_clk rom_clk dram_clk}]
#set_driving_cell -library N16ADFP_StdCellss0p72vm40c -lib_cell DFQD1BWP16P90LVT  -pin {Q} [remove_from_collection [all_inputs] [get_ports {cpu_clk axi_clk rom_clk dram_clk}]]
set_driving_cell -library N16ADFP_StdIOss0p72v1p62v125c -lib_cell PDCDG_H -pin {C} [all_inputs]
set_driving_cell -library N16ADFP_StdIOss0p72v1p62v125c -lib_cell PDCDG_V -pin {C} [all_inputs]

set auto_wire_load_selection

set_wire_load_model -name ZeroWireload -library N16ADFP_StdCellss0p72vm40c
#set_timing_derate -max -late -net_delay 1.1

set_max_area     310000
set_max_fanout       10 [all_inputs]
set_max_transition  0.1 [all_inputs]
set_max_capacitance 0.1 [all_inputs]

####Naming Rule#######
set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
change_names -hierarchy -rule verilog
define_name_rules name_rule -allowed "A-Z a-z 0-9 _" -max_length 255 -type cell
define_name_rules name_rule -allowed "A-Z a-z 0-9 _[]" -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule
