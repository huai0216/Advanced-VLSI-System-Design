#spyglass shell source tcl code
#In the Spyglass shell type "source ../script/Spyglass_CDC.tcl" to execute script

#import design
read_file -type sgdc ../script/Spyglass.sgdc
read_file -type verilog ../src/top.sv
read_file -type verilog ../sim/SRAM/TS1N16ADFPCLLLVTA512X45M4SWSHOD.sv
set_option enableSV yes
set_option stop {TS1N16ADFPCLLLVTA512X45M4SWSHOD}
#set_option ignoredu {tag_array data_array SRAM}
set_option incdir {../include ../src ../src/AXI ../sim ../sim/SRAM}

#read design
current_goal Design_Read -alltop
link_design -force

#start CDC verification
current_goal cdc/cdc_setup_check -alltop
run_goal

current_goal cdc/clock_reset_integrity -alltop
run_goal

current_goal cdc/cdc_verify_struct -alltop
run_goal

current_goal cdc/cdc_verify -alltop
run_goal

current_goal cdc/cdc_abstrast -alltop
run_goal