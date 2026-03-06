
# Top-level signals
add wave -noupdate -group "TOP" -position insertpoint sim:/my_uvm_tb/clock
add wave -noupdate -group "TOP" -position insertpoint sim:/my_uvm_tb/reset

# Interface signals (UVM VIF)
add wave -noupdate -group "VIF" -position insertpoint sim:/my_uvm_tb/vif/wr_en
add wave -noupdate -group "VIF" -position insertpoint -radix decimal sim:/my_uvm_tb/vif/din
add wave -noupdate -group "VIF" -position insertpoint sim:/my_uvm_tb/vif/in_full
add wave -noupdate -group "VIF" -position insertpoint sim:/my_uvm_tb/vif/inference_done
add wave -noupdate -group "VIF" -position insertpoint -radix unsigned sim:/my_uvm_tb/vif/predicted_class
add wave -noupdate -group "VIF" -position insertpoint -radix decimal sim:/my_uvm_tb/vif/max_score

# DUT FSM State
add wave -noupdate -group "FSM" -position insertpoint sim:/my_uvm_tb/dut/state
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/my_uvm_tb/dut/cnt
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/my_uvm_tb/dut/l1_cnt

# Input FIFO
add wave -noupdate -group "FIFO" -position insertpoint sim:/my_uvm_tb/dut/fifo_empty
add wave -noupdate -group "FIFO" -position insertpoint sim:/my_uvm_tb/dut/fifo_rd_en
add wave -noupdate -group "FIFO" -position insertpoint -radix decimal sim:/my_uvm_tb/dut/fifo_dout
add wave -noupdate -group "FIFO" -position insertpoint -radix decimal sim:/my_uvm_tb/dut/fifo_dout_reg

# Layer 0 Control
add wave -noupdate -group "L0" -position insertpoint sim:/my_uvm_tb/dut/l0_start
add wave -noupdate -group "L0" -position insertpoint sim:/my_uvm_tb/dut/l0_valid_in
add wave -noupdate -group "L0" -position insertpoint -radix decimal sim:/my_uvm_tb/dut/l0_data_in

# Layer 0 Neuron 0 Pipeline
add wave -noupdate -group "L0_N0_PIPE" -position insertpoint {sim:/my_uvm_tb/dut/u_layer0/gen_neurons[0]/l0/n0/u_n/active}
add wave -noupdate -group "L0_N0_PIPE" -position insertpoint -radix unsigned {sim:/my_uvm_tb/dut/u_layer0/gen_neurons[0]/l0/n0/u_n/cnt}
add wave -noupdate -group "L0_N0_PIPE" -position insertpoint {sim:/my_uvm_tb/dut/u_layer0/gen_neurons[0]/l0/n0/u_n/s0_valid}
add wave -noupdate -group "L0_N0_PIPE" -position insertpoint {sim:/my_uvm_tb/dut/u_layer0/gen_neurons[0]/l0/n0/u_n/s1_valid}
add wave -noupdate -group "L0_N0_PIPE" -position insertpoint -radix decimal {sim:/my_uvm_tb/dut/u_layer0/gen_neurons[0]/l0/n0/u_n/acc}
add wave -noupdate -group "L0_N0_PIPE" -position insertpoint {sim:/my_uvm_tb/dut/u_layer0/gen_neurons[0]/l0/n0/u_n/done_pending}
add wave -noupdate -group "L0_N0_PIPE" -position insertpoint {sim:/my_uvm_tb/dut/u_layer0/gen_neurons[0]/l0/n0/u_n/valid_out}

# Layer 0 Results (after ReLU)
add wave -noupdate -group "L0_RESULT" -position insertpoint -radix decimal sim:/my_uvm_tb/dut/l0_relu

# Layer 1 Control
add wave -noupdate -group "L1" -position insertpoint sim:/my_uvm_tb/dut/l1_start
add wave -noupdate -group "L1" -position insertpoint sim:/my_uvm_tb/dut/l1_valid_in
add wave -noupdate -group "L1" -position insertpoint -radix decimal sim:/my_uvm_tb/dut/l1_data_in

# Argmax
add wave -noupdate -group "ARGMAX" -position insertpoint sim:/my_uvm_tb/dut/argmax_start
add wave -noupdate -group "ARGMAX" -position insertpoint sim:/my_uvm_tb/dut/u_argmax/active
add wave -noupdate -group "ARGMAX" -position insertpoint -radix unsigned sim:/my_uvm_tb/dut/u_argmax/idx
add wave -noupdate -group "ARGMAX" -position insertpoint -radix decimal sim:/my_uvm_tb/dut/u_argmax/best_val
add wave -noupdate -group "ARGMAX" -position insertpoint -radix unsigned sim:/my_uvm_tb/dut/u_argmax/best_idx
add wave -noupdate -group "ARGMAX" -position insertpoint sim:/my_uvm_tb/dut/argmax_valid_out

configure wave -namecolwidth 280
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
