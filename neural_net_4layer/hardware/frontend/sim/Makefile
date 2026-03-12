# ============================================================
# Makefile for Neural Network Simulation (Cadence Xcelium xrun)
# ============================================================
# Usage:
#   make sim         — Run direct testbench
#   make sim_gui     — Run with waveform GUI
#   make uvm_sim     — Run UVM testbench
#   make uvm_sim_gui — Run UVM testbench with GUI
#   make clean       — Remove xcelium artifacts
# ============================================================

SV_DIR   := ../sv
UVM_DIR  := ../uvm

XFLAGS   := -sv -access +rwc -timescale 1ns/1ps -64bit
UVM_XFLAGS := -sv -uvm -access +rwc -timescale 1ns/1ps -64bit -coverage all -covoverwrite +incdir+$(UVM_DIR)

# Package
PKG      := $(SV_DIR)/nn_pkg.sv
W_PKG    := $(SV_DIR)/weight_pkg.sv
UVM_PKG  := $(UVM_DIR)/my_uvm_pkg.sv

# Direct Testbench Source files
ALL_SRC  := $(PKG) \
            $(W_PKG) \
            $(SV_DIR)/fifo.sv \
            $(SV_DIR)/npu_mac.sv \
            $(SV_DIR)/argmax.sv \
            $(SV_DIR)/nn_top.sv \
            $(SV_DIR)/nn_tb.sv

# UVM Testbench Source files
UVM_SRC  := $(PKG) \
            $(W_PKG) \
            $(SV_DIR)/fifo.sv \
            $(SV_DIR)/npu_mac.sv \
            $(SV_DIR)/argmax.sv \
            $(SV_DIR)/nn_top.sv \
            $(UVM_DIR)/nn_if.sv \
            $(UVM_PKG) \
            $(UVM_DIR)/my_uvm_tb.sv

# Gate Level Simulation (GLS) Source files
GENUS_DIR := ../../backend/genus
LIB_V     := /vol/ece303/genus_tutorial/NangateOpenCellLibrary.v

GLS_SRC  := $(PKG) \
            $(W_PKG) \
            $(GENUS_DIR)/nn_top_syn.v \
            $(LIB_V) \
            $(SV_DIR)/nn_tb.sv

INNOVUS_DIR := ../../backend/innovus
GLS_APR_SRC  := $(PKG) \
            $(W_PKG) \
            $(INNOVUS_DIR)/nn_top_final_nophy.v \
            $(LIB_V) \
            $(SV_DIR)/nn_tb.sv

# -------------------------------------------------------
.PHONY: sim sim_gui uvm_sim uvm_sim_gui clean test_all gls gls_gui

# Run direct testbench
sim:
	xrun $(XFLAGS) $(ALL_SRC)

# Gate Level Simulation (functional, zero-delay, no timing checks)
# -delay_mode zero: zeroes all path delays
# -notimingchecks: suppresses $setuphold/$recovery/$width NOTIFIER toggling
# -input gls_init.tcl: forces all uninitialized FFs to 0 at T=0
gls:
	tcsh -c "source /vol/ece303/genus_tutorial/cadence.env && xrun $(XFLAGS) -warnmax 0 -delay_mode zero -notimingchecks -input gls_init.tcl $(GLS_SRC)" 

# Gate Level Simulation with Unit Delays (to check for basic race conditions)
gls_delay:
	tcsh -c "source /vol/ece303/genus_tutorial/cadence.env && xrun $(XFLAGS) -warnmax 0 -input gls_init.tcl $(GLS_SRC)" 

# Post-Route Gate Level Simulation (with SDF + strict timing checks)
gls_apr:
	tcsh -c "source /vol/ece303/genus_tutorial/cadence.env && xrun $(XFLAGS) -warnmax 0 +define+POST_ROUTE -maxdelays $(GLS_APR_SRC)"

# Post-Route Gate Level Simulation (functional, zero-delay)
# +delay_mode_zero: removes all SDF delays for purely functional GLS
#   This avoids NOTIFIER X-propagation in NangateOpenCellLibrary scan FFs
# +define+NTC: tells NangateOpenCellLibrary cells to use conditioned timing
#              paths, preventing NOTIFIER from corrupting flip-flop outputs
# +no_notifier: completely suppresses NOTIFIER-driven X propagation in UDPs
# 	tcsh -c "source /vol/ece303/genus_tutorial/cadence.env && xrun $(XFLAGS) -warnmax 0 +define+POST_ROUTE +define+NTC +no_notifier -maxdelays -notimingchecks $(GLS_APR_SRC)"
gls_apr_notiming:
	tcsh -c "source /vol/ece303/genus_tutorial/cadence.env && xrun $(XFLAGS) -warnmax 0 +define+POST_ROUTE +delay_mode_zero -notimingchecks $(GLS_APR_SRC)"

# Gate Level Simulation with GUI
gls_gui:
	xrun $(XFLAGS) -gui -warnmax 0 -delay_mode zero $(GLS_SRC)

# Run with GUI for waveforms
sim_gui:
	xrun $(XFLAGS) -gui $(ALL_SRC)

# Run UVM testbench
uvm_sim:
	xrun $(UVM_XFLAGS) $(UVM_SRC) +UVM_TESTNAME=my_uvm_test

# Run UVM testbench with GUI
uvm_sim_gui:
	xrun $(UVM_XFLAGS) -gui $(UVM_SRC) +UVM_TESTNAME=my_uvm_test

# Clean
clean:
	rm -rf xcelium.d INCA_libs xrun.log xrun.history waves.shm *.key cov_work
	@echo "Cleaned."

# Test all 10 classes one by one
test_all:
	@echo "============================================="
	@echo "Starting Batch Simulation for All 10 Classes"
	@echo "============================================="
	@for i in 0 1 2 3 4 5 6 7 8 9; do \
		echo ""; \
		echo ">>> Testing Class $$i <<<"; \
		cp ../../../source/test_samples/x_test_class$$i.txt ../../../source/x_test.txt; \
		cp ../../../source/test_samples/y_test_class$$i.txt ../../../source/y_test.txt; \
		xrun $(XFLAGS) $(ALL_SRC) | grep -E "(TEST PASSED|TEST FAILED|Predicted Class|True Label|Max Score|Output Probabilities)"; \
	done
