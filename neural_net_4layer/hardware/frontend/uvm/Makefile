# ============================================================
# Makefile for Neural Network UVM Simulation (Xcelium xrun)
# ============================================================

SV_DIR   := ../sv
UVM_DIR  := .

XFLAGS   := -sv -uvm -access +rwc -timescale 1ns/1ps -64bit \
            -coverage all -covoverwrite

PKG      := $(SV_DIR)/nn_pkg.sv
UVM_PKG  := $(UVM_DIR)/my_uvm_pkg.sv

ALL_SRC  := $(PKG) \
            $(SV_DIR)/fifo.sv \
            $(SV_DIR)/neuron.sv \
            $(SV_DIR)/layer.sv \
            $(SV_DIR)/argmax.sv \
            $(SV_DIR)/nn_top.sv \
            $(UVM_DIR)/nn_if.sv \
            $(UVM_PKG) \
            $(UVM_DIR)/my_uvm_tb.sv

.PHONY: sim sim_gui clean

sim:
	xrun $(XFLAGS) $(ALL_SRC) +UVM_TESTNAME=my_uvm_test

sim_gui:
	xrun $(XFLAGS) -gui $(ALL_SRC) +UVM_TESTNAME=my_uvm_test

clean:
	rm -rf xcelium.d INCA_libs xrun.log xrun.history waves.shm *.key cov_work
	@echo "Cleaned."
