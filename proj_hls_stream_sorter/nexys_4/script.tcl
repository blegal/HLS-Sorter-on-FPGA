############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
############################################################
open_project proj_hls_stream_sorter
set_top stream_sorter
add_files hls_src/stream_sorter.cpp
open_solution "nexys_4" -flow_target vivado
set_part {xc7a100tcsg324-1}
create_clock -period 10 -name default
#source "./proj_hls_stream_sorter/nexys_4/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -format ip_catalog
