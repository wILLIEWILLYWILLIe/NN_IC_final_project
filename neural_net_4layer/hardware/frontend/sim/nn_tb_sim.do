# =============================================================
# ModelSim/QuestaSim simulation script for Neural Network
# =============================================================
# Usage: do nn_sim.do
# Run from imp/sim/ directory
# =============================================================

# Create work library
vlib work

# Compile (package first, then leaf → top → testbench)
vlog -sv ../sv/nn_pkg.sv
vlog -sv ../sv/fifo.sv
vlog -sv ../sv/neuron.sv
vlog -sv ../sv/layer.sv
vlog -sv ../sv/argmax.sv
vlog -sv ../sv/nn_top.sv
vlog -sv ../sv/nn_tb.sv

# Load simulation
vsim -voptargs="+acc" work.nn_tb

# Log all signals (for waveform viewing)
log -r /*

# Run simulation
run -all
