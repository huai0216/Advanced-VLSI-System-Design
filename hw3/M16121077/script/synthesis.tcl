#   Read in top module
#read_file -autoread -top CHIP {../src/ ../include}
read_file -format sverilog {../src/top.sv}

# SET POWER INTENT and ENVIRONMENT ###################################
current_design top
link

#   Set Design Environment
set_host_options -max_core 8
source ../script/DC.sdc
check_design
uniquify
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
set_max_area 0


#   Synthesize circuit
compile -map_effort high -area_effort high
#compile -map_effort high -area_effort high -inc

#   Create Report
#timing report(setup time)
report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 4 -sort_by group > ../syn/timing_max_rpt.txt
#timing report(hold time)
report_timing -path full -delay min -nworst 1 -max_paths 1 -significant_digits 4 -sort_by group > ../syn/timing_min_rpt.txt
#area report
report_area -nosplit > ../syn/area_rpt.txt
#report power
report_power -analysis_effort low > ../syn/power_rpt.txt

#   Save syntheized file
write -hierarchy -format verilog -output {../syn/top_syn.v}
#write_sdf -version 1.0 -context verilog {../syn/top_syn.sdf}
write_sdf -version 3.0 -context verilog {../syn/top_syn.sdf}

