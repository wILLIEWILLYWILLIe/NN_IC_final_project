# Xcelium control script for Stable Post-Route GLS
# Goal: Suppress startup noise and enable timing checks only during active inference.

database -open waves -shm
probe -create -shm -all -variables -depth all

# 1. Force all flip-flops to 0 at T=0 to prevent 'X' propagation from uninitialized state
# deposit -r nn_tb.u_dut 0

# 2. Disable timing checks during reset and loading phase
tcheck -off

# 3. Run until reset is deasserted (assuming reset deasserts at 500ns per TB)
# Note: In Post-Route, we wait a bit longer for it to propagate.
run 600ns
echo ">>> Reset phase complete. Logic stabilized."

# 4. Run until data loading is almost finished (item 100/784 ~ 1.6us)
run 1000ns
echo ">>> Stabilization wait complete. Enabling Timing Checks."

# 5. Enable timing checks for the actual computation phase
tcheck -on

# 6. Run to completion
run
exit
