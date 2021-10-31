############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project proj_hls_stream_sorter
set_top stream_sorter
add_files bytestrm_dwordproc.h
add_files bytestrm_util.h
add_files hls_src/stream_sorter.cpp
add_files -tb stream_sorter_test.cpp -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
open_solution "nexys_4"
set_part {xc7a100tcsg324-1}
create_clock -period 10 -name default
#source "./proj_hls_stream_sorter/nexys_4/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -rtl vhdl -format ip_catalog
