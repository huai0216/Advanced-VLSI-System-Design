read_file -autoread -top CHIP {../src ../include ../src/AXI}
current_design CHIP
link
uniquify
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]


set_host_options -max_core 16
source ../script/DC.sdc

compile -exact_map -map_effort high
optimize_registers
remove_unconnected_ports -blast_buses [get_cells * -hier]


set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true

change_names -hierarchy -rule verilog

define_name_rules name_rule -allowed "A-Z a-z 0-9 _" -max_length 255 -type cell
define_name_rules name_rule -allowed "A-Z a-z 0-9 _[]" -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule





write_file -format verilog -hier -output ../syn/CHIP_syn.v
write_sdf -version 2.1 -context verilog -load_delay net ../syn/CHIP_syn.sdf
report_timing > ../syn/timing.log
report_area > ../syn/area.log
report_power > ../syn/power.log

report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group > ../syn/timing_max_rpt.txt
report_timing -path full -delay min -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group > ../syn/timing_min_rpt.txt

#exit



