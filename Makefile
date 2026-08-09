TEST ?= fifo_rand_test

RTL  = rtl/fifo.sv
TB   = tb/fifo_pkg.sv tb/fifo_if.sv tb/tb_top.sv
INCDIR = +incdir+tb

.PHONY: all compile sim clean

all: compile sim

compile:
	vcs -sverilog -full64 -timescale=1ns/1ps $(INCDIR) -ntb_opts uvm -debug_access+all $(RTL) $(TB) -o simv

sim:
	./simv +UVM_TESTNAME=$(TEST)

clean:
	rm -rf simv* csrc *.key *.log DVEfiles AN.DB ucli.key