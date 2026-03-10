
# Top-level signals
add wave -noupdate -group "TOP" -position insertpoint sim:/my_uvm_tb/clock
add wave -noupdate -group "TOP" -position insertpoint sim:/my_uvm_tb/reset

# Interface signals (UVM VIF)
add wave -noupdate -group "VIF" -position insertpoint sim:/my_uvm_tb/vif/wr_en
add wave -noupdate -group "VIF" -position insertpoint -radix hexadecimal sim:/my_uvm_tb/vif/din
add wave -noupdate -group "VIF" -position insertpoint sim:/my_uvm_tb/vif/in_full
add wave -noupdate -group "VIF" -position insertpoint sim:/my_uvm_tb/vif/inference_done
add wave -noupdate -group "VIF" -position insertpoint -radix unsigned sim:/my_uvm_tb/vif/predicted_class
add wave -noupdate -group "VIF" -position insertpoint -radix decimal sim:/my_uvm_tb/vif/max_score

# DUT FSM State
add wave -noupdate -group "FSM" -position insertpoint sim:/my_uvm_tb/dut/state
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/my_uvm_tb/dut/img_cnt
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/my_uvm_tb/dut/layer_idx
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/my_uvm_tb/dut/pass_idx
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/my_uvm_tb/dut/in_cnt
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/my_uvm_tb/dut/drain_cnt

# Input FIFO
add wave -noupdate -group "FIFO" -position insertpoint sim:/my_uvm_tb/dut/fifo_empty
add wave -noupdate -group "FIFO" -position insertpoint sim:/my_uvm_tb/dut/fifo_rd_en
add wave -noupdate -group "FIFO" -position insertpoint -radix decimal sim:/my_uvm_tb/dut/fifo_dout

# MAC Control
add wave -noupdate -group "MAC_CTRL" -position insertpoint sim:/my_uvm_tb/dut/mac_start_in
add wave -noupdate -group "MAC_CTRL" -position insertpoint sim:/my_uvm_tb/dut/mac_valid_in
add wave -noupdate -group "MAC_CTRL" -position insertpoint sim:/my_uvm_tb/dut/mac_last_in
add wave -noupdate -group "MAC_CTRL" -position insertpoint sim:/my_uvm_tb/dut/mac_relu_en

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
