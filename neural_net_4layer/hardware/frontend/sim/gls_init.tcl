# Xcelium initialization script for Gate-Level Simulation (GLS)
# This forces all uninitialized flip-flops in the synthesized netlist
# to start at 0 (or a known logic value) at T=0.
# It prevents pessimistic X-propagation through Nangate logic cells
# without requiring massive physical ASIC area overhead from adding
# hardware resets to every datapath pipeline register.

deposit -value 0 -r /*
run
