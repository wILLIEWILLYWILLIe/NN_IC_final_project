# ==============================================================
# nn_sim_all.do — Batch Simulation: All 10 MNIST Classes
# ==============================================================
# All 10 inferences run in ONE simulation — waveform shows all!
#
# Usage:
#   GUI:     vsim -do nn_sim_all.do
#   Batch:   vsim -c -do nn_sim_all.do
# ==============================================================

vlib work
vmap work work

# Compile source files
vlog -sv ../sv/nn_pkg.sv
vlog -sv ../sv/weight_pkg.sv
vlog -sv ../sv/fifo.sv
vlog -sv ../sv/npu_mac.sv
vlog -sv ../sv/argmax.sv
vlog -sv ../sv/nn_top.sv
vlog -sv ../sv/nn_tb_all.sv

# Elaborate
vsim -voptargs="+acc" nn_tb_all

# Log all signals for waveform viewing
log -r /*

# Load waveform if GUI mode
if {[batch_mode]} {
    # batch mode: skip wave commands
} else {
    view wave
    delete wave *
    do nn_wave_all.do
}

# Run entire batch simulation
run -all

# Zoom full in GUI mode
if {![batch_mode]} {
    wave zoom full
}
