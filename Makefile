TEST ?= fifo_rand_test

TESTS = fifo_rand_test \
        fifo_full_empty_test \
        fifo_override_test \
        fifo_reset_test \
		fifo_full_simultaneous_test

RTL = rtl/fifo.sv
TB  = tb/fifo_pkg.sv tb/fifo_if.sv tb/tb_top.sv tb/fifo_assertion.sv
INCDIR = +incdir+tb

COV_FLAGS = -cm line+cond+fsm+tgl+branch+assert

.PHONY: all compile sim regress cov clean

all: compile regress

compile:
	vcs -sverilog -full64 -timescale=1ns/1ps $(INCDIR) \
	    -ntb_opts uvm -debug_access+all $(COV_FLAGS) \
	    $(RTL) $(TB) -o simv

# Run a single test
sim:
	./simv $(COV_FLAGS) +UVM_TESTNAME=$(TEST) -cm_name $(TEST)

# Run all five tests
regress:
	@set -e; for test in $(TESTS); do \
	    echo "===== Running $$test ====="; \
	    ./simv $(COV_FLAGS) +UVM_TESTNAME=$$test -cm_name $$test; \
	done

# Generate merged coverage report
cov:
	urg -dir simv.vdb -report cov_report

clean:
	rm -rf simv simv.daidir simv.vdb cov_report csrc \
	       ucli.key *.log \
		   sim.log