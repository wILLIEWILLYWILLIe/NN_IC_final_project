# ============================================================
# Genus Synthesis Script for NPU
# ============================================================

# 1. Setup Libraries
set_db library /vol/ece303/genus_tutorial/NangateOpenCellLibrary_typical.lib
set_db lef_library /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef

# 2. Read HDL Files (Order matters for packages)
read_hdl -sv {
    ../../frontend/sv/nn_pkg.sv
    ../../frontend/sv/weight_pkg.sv
    ../../frontend/sv/fifo.sv
    ../../frontend/sv/npu_mac.sv
    ../../frontend/sv/argmax.sv
    ../../frontend/sv/nn_top.sv
}

# 3. Elaborate Design
elaborate
current_design nn_top

# 4. Read Constraints
read_sdc ./constraints.sdc

# 5. Synthesis Steps
# Preserve FSM and key control signals for GLS visibility/debugging
# Use standard 'preserve' attribute on instances
set_db [get_db insts *u_input_fifo] .preserve true
set_db [get_db insts *u_input_fifo] .boundary_opto false
set_db [get_db insts *u_argmax] .preserve true

syn_generic
syn_map
syn_opt

# 6. Generate Reports
report_timing > timing.rep
report_area   > area.rep
report_gates  > gates.rep
report_power  > power.rep

# 7. Write Netlist
write_hdl > nn_top_syn.v

# 8. Finish
puts "Synthesis Finished Successfully"
quit
