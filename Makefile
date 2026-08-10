TEST ?= fifo_rand_test

RTL  = rtl/fifo.sv
TB   = tb/fifo_pkg.sv tb/fifo_if.sv tb/tb_top.sv
INCDIR = +incdir+tb

COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert 

.PHONY: all compile sim clean cov

all: compile sim

compile:
	vcs -sverilog -full64 -timescale=1ns/1ps $(INCDIR) -ntb_opts uvm -debug_access+all $(COV_FLAGS) $(RTL) $(TB) -o simv

sim:
	./simv $(COV_FLAGS) +UVM_TESTNAME=$(TEST) -cm_name $(TEST)

cov:
	urg -dir simv.vdb -report cov_report

clean:
	rm -rf simv* csrc *.key *.log DVEfiles AN.DB ucli.key *.vdb cov_report urgReport *.xml vc_hdrs.h