# ============================================================
# SDC Constraints for NN_TOP (100 MHz)
# ============================================================

# 1. Define Clock (10ns = 100MHz)
create_clock -name clk -period 10 [get_ports clk]

# 2. Input Delays (Assuming 20% of period)
set_input_delay 2.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]

# 3. Output Delays (Assuming 20% of period)
set_output_delay 2.0 -clock clk [all_outputs]

# 4. Environment Constraints
set_load 0.1 [all_outputs]
set_max_transition 0.5 [current_design]
