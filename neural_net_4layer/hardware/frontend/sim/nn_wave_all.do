
# Top-level signals + Class marker
add wave -noupdate -group "TOP" -position insertpoint sim:/nn_tb_all/clk
add wave -noupdate -group "TOP" -position insertpoint sim:/nn_tb_all/reset
add wave -noupdate -group "TOP" -position insertpoint -radix unsigned -color Yellow sim:/nn_tb_all/current_class

# DUT I/O
add wave -noupdate -group "DUT_IO" -position insertpoint sim:/nn_tb_all/wr_en
add wave -noupdate -group "DUT_IO" -position insertpoint -radix hexadecimal sim:/nn_tb_all/din
add wave -noupdate -group "DUT_IO" -position insertpoint sim:/nn_tb_all/in_full
add wave -noupdate -group "DUT_IO" -position insertpoint sim:/nn_tb_all/inference_done
add wave -noupdate -group "DUT_IO" -position insertpoint -radix unsigned sim:/nn_tb_all/predicted_class
add wave -noupdate -group "DUT_IO" -position insertpoint -radix decimal sim:/nn_tb_all/max_score

# Results
add wave -noupdate -group "RESULTS" -position insertpoint -radix unsigned sim:/nn_tb_all/pass_count
add wave -noupdate -group "RESULTS" -position insertpoint -radix unsigned sim:/nn_tb_all/fail_count

# DUT FSM State
add wave -noupdate -group "FSM" -position insertpoint sim:/nn_tb_all/u_dut/state
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/nn_tb_all/u_dut/img_cnt
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/nn_tb_all/u_dut/layer_idx
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/nn_tb_all/u_dut/pass_idx
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/nn_tb_all/u_dut/in_cnt
add wave -noupdate -group "FSM" -position insertpoint -radix unsigned sim:/nn_tb_all/u_dut/drain_cnt

# Input FIFO
add wave -noupdate -group "FIFO" -position insertpoint sim:/nn_tb_all/u_dut/fifo_empty
add wave -noupdate -group "FIFO" -position insertpoint sim:/nn_tb_all/u_dut/fifo_rd_en
add wave -noupdate -group "FIFO" -position insertpoint -radix decimal sim:/nn_tb_all/u_dut/fifo_dout

# MAC Control
add wave -noupdate -group "MAC_CTRL" -position insertpoint sim:/nn_tb_all/u_dut/mac_start_in
add wave -noupdate -group "MAC_CTRL" -position insertpoint sim:/nn_tb_all/u_dut/mac_valid_in
add wave -noupdate -group "MAC_CTRL" -position insertpoint sim:/nn_tb_all/u_dut/mac_last_in

# Argmax
add wave -noupdate -group "ARGMAX" -position insertpoint sim:/nn_tb_all/u_dut/argmax_start
add wave -noupdate -group "ARGMAX" -position insertpoint sim:/nn_tb_all/u_dut/argmax_valid_out

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
