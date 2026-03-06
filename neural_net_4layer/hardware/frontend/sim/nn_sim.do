
vlib work
vmap work work

# Compile source files
vlog -sv ../sv/nn_pkg.sv
vlog -sv ../sv/fifo.sv
vlog -sv ../sv/neuron.sv
vlog -sv ../sv/layer.sv
vlog -sv ../sv/argmax.sv
vlog -sv ../sv/nn_top.sv

# Compile UVM environment
vlog -sv +incdir+../uvm ../uvm/my_uvm_pkg.sv
vlog -sv +incdir+../uvm ../uvm/nn_if.sv
vlog -sv +incdir+../uvm ../uvm/my_uvm_tb.sv

# Elaborate and load simulation
vsim -voptargs="+acc" my_uvm_tb +UVM_TESTNAME=my_uvm_test

# Log all signals for waveform viewing
log -r /*

# Load waveform if in GUI mode
if {[batch_mode]} {
    # batch mode: skip wave commands
} else {
    view wave
    delete wave *
    do nn_wave.do
}

# Run simulation
run -all

# Zoom full if in GUI mode
if {![batch_mode]} {
    wave zoom full
}

