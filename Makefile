
TEST ?= fifo_rand_test

RTL = rtl/fifo.sv
TB  = tb/fifo_pkg.sv tb/fifo_if.sv tb/tb_top.sv tb/fifo_assertion.sv

INCDIR = +incdir+tb
COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert

.PHONY: all compile sim regress cov clean

# Compile and run all tests
all: compile regress

# Compile
compile:
	vcs -sverilog -full64 -timescale=1ns/1ps $(INCDIR) \
	    -ntb_opts uvm -debug_access+all $(COV_FLAGS) \
	    $(RTL) $(TB) -o simv

# Run one test
sim:
	./simv $(COV_FLAGS) +UVM_TESTNAME=$(TEST) -cm_name $(TEST)

# Run all five tests
regress:
	./simv $(COV_FLAGS) +UVM_TESTNAME=fifo_rand_test -cm_name fifo_rand_test
	./simv $(COV_FLAGS) +UVM_TESTNAME=fifo_full_empty_test -cm_name fifo_full_empty_test
	./simv $(COV_FLAGS) +UVM_TESTNAME=fifo_override_test -cm_name fifo_override_test
	./simv $(COV_FLAGS) +UVM_TESTNAME=fifo_reset_test -cm_name fifo_reset_test
	./simv $(COV_FLAGS) +UVM_TESTNAME=fifo_full_simultaneous_test -cm_name fifo_full_simultaneous_test

# Generate coverage report
cov:
	urg -dir simv.vdb -report cov_report

# Clean generated files
clean:
	rm -rf simv simv.daidir simv.vdb cov_report csrc ucli.key *.log
