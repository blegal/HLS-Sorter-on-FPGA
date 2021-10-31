############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project proj_hls_stream_sorter
set_top stream_sorter
add_files hls_src/stream_sorter.cpp
add_files hls_src/bytestrm_util.h
add_files bytestrm_dwordproc.h
add_files -tb hls_src/stream_sorter_test.cpp -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
open_solution "nexys_4"
set_part {xc7a100t-csg324-1}
create_clock -period 10 -name default
create_clock -period 5 -name default
config_sdx -target none
config_export -format ip_catalog -rtl vhdl -version 1.1 -vivado_optimization_level 2 -vivado_phys_opt place -vivado_report_level 0
config_schedule -effort high -enable_dsp_full_reg=0 -relax_ii_for_timing=0 -verbose=0
set_clock_uncertainty 12.5%
#source "./proj_hls_stream_sorter/nexys_4/directives.tcl"
csim_design
csynth_design
cosim_design -rtl vhdl
export_design -rtl vhdl -format ip_catalog -version "1.1"
