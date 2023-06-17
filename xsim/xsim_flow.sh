#!/bin/bash
rm -r *webtalk* *.log *.pb *.jou *.vcd *.wdb *.dir .xil 
xvlog --nolog --sv --incr -L uvm -f ./sim_filelist
xelab --nolog  --incr -L uvm -debug all -top tb_top -snapshot tb_top_snapshot 
#xsim --nolog tb_top_snapshot --tclbatch xsim_cfg.tcl --testplusarg UVM_TESTNAME=tb_rand_test
#xsim --nolog --gui tb_top_snapshot.wdb

exit 0
