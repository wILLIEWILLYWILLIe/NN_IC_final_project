# MNIST 4-Layer NPU (16-bit Q12 TDM Architecture)

This repository contains a 4-layer Neural Network Processor (NPU) implementation for MNIST digit classification, optimized for ASIC synthesis.

## Architecture Overview
- **Topology**: `784 (Input) -> 32 (Hidden) -> 16 (Hidden) -> 16 (Hidden) -> 10 (Output)`
- **Precision**: 16-bit Fixed-point (Q12) quantization.
- **Hardware Architecture**: **32-Lane Time-Multiplexed (TDM)** design with Resource Sharing.
- **Activation Function**: Hardware-friendly **ReLU**.
- **Performance**: 100% Bit-true match with C reference model.

## Key Implementation Details

### 1. Synthesis-Friendly Weight Initialization
Instead of `$readmemh`, we use a SystemVerilog package (`weight_pkg.sv`) containing parameters. This allows for:
- **Constant Propagation**: Cadence Genus can optimize weights into logic-based ROMs.
- **Register Merging**: Massive reduction in area by sharing common weight patterns.

### 2. Instruction & Usage
- **Weight Generation**: 
  ```bash
  python3 software/gen_npu_weights.py  # Generates weight_pkg.sv
  ```
- **Simulation (ModelSim)**:
  ```bash
  cd hardware/frontend/sim
  vsim -c -do nn_sim.do
  ```
- **Synthesis (Cadence Genus)**:
  ```bash
  cd hardware/backend/genus
  genus -files synthesis.tcl
  ```

## Performance Metrics (ASIC Synthesis)
Synthesis results using **NangateOpenCellLibrary** (typical conditions):

| Metric | Result |
| :--- | :--- |
| **Total Area** | 654,006 µm² |
| **Cell Count** | 177,266 |
| **Clock Frequency** | 100 MHz (Target) |
| **Timing Slack** | +5,044 ps (MET) |
| **Total Power** | 84.6 mW |

## Hardware/Software Co-Verification
The RTL implementation achieves **10/10 (100%) accuracy** across MNIST test samples, perfectly matching the C-based reference model outputs.
