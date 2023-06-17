#!/bin/bash
xsim  tb_top_snapshot --log simulation.log --tclbatch xsim_cfg.tcl --testplusarg UVM_TESTNAME=tb_parallel_test
#xsim --nolog --gui tb_top_snapshot.wdb
