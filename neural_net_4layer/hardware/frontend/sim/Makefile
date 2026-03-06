# ============================================================
# Makefile for Neural Network Simulation (Cadence Xcelium xrun)
# ============================================================
# Usage:
#   make sim         — Run direct testbench
#   make sim_gui     — Run with waveform GUI
#   make clean       — Remove xcelium artifacts
# ============================================================

SV_DIR   := ../sv

XFLAGS   := -sv -access +rwc -timescale 1ns/1ps -64bit

# Package
PKG      := $(SV_DIR)/nn_pkg.sv

# Source files (order: package → leaf modules → top → testbench)
ALL_SRC  := $(PKG) \
            $(SV_DIR)/fifo.sv \
            $(SV_DIR)/neuron.sv \
            $(SV_DIR)/layer.sv \
            $(SV_DIR)/argmax.sv \
            $(SV_DIR)/nn_top.sv \
            $(SV_DIR)/nn_tb.sv

# -------------------------------------------------------
.PHONY: sim sim_gui clean test_all

# Run direct testbench
sim:
	xrun $(XFLAGS) $(ALL_SRC)

# Run with GUI for waveforms
sim_gui:
	xrun $(XFLAGS) -gui $(ALL_SRC)

# Clean
clean:
	rm -rf xcelium.d INCA_libs xrun.log xrun.history waves.shm *.key
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
