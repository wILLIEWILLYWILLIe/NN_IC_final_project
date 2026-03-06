# MNIST 4-Layer Neural Network — Python Training & SystemVerilog Export

## Overview

This project trains a 4-layer fully-connected neural network on the MNIST handwritten digit dataset in Python (PyTorch), then exports all parameters in **Q14 fixed-point hex format** for SystemVerilog implementation.

## Network Architecture

```
Input (28×28 = 784) → FC+ReLU (128) → FC+ReLU (64) → FC+ReLU (32) → FC (10) → argmax
```

| Layer | Input → Output | Parameters |
|-------|---------------|------------|
| 0     | 784 → 128     | 100,480    |
| 1     | 128 → 64      | 8,256      |
| 2     | 64 → 32       | 2,080      |
| 3     | 32 → 10       | 330        |

**Total parameters:** 111,146

## Directory Structure

```
NN_Project/
├── python_train/
│   ├── train.py                    # Training & export script
│   ├── data/                       # MNIST dataset (auto-downloaded)
│   └── README.md                   # This file
│
├── neural_net_4layer/              # ← Generated output
│   ├── layer_0_weights_biases.txt  # Layer 0: 100,480 lines
│   ├── layer_1_weights_biases.txt  # Layer 1: 8,256 lines
│   ├── layer_2_weights_biases.txt  # Layer 2: 2,080 lines
│   ├── layer_3_weights_biases.txt  # Layer 3: 330 lines
│   ├── x_test.txt                  # Default test input (class 7)
│   ├── y_test.txt                  # Default true label
│   ├── neural_net.c                # C reference implementation
│   └── test_samples/               # ← One sample per class
│       ├── x_test_class0.txt       # Pixels for digit 0
│       ├── y_test_class0.txt       # Label = 0
│       ├── x_test_class1.txt       # Pixels for digit 1
│       ├── ...                     # ... (classes 2-8)
│       ├── x_test_class9.txt       # Pixels for digit 9
│       ├── y_test_class9.txt       # Label = 9
│       └── labels.txt              # Summary of all test samples
│
└── neural_net/                     # Original 2-layer reference
    ├── neural_net.c
    ├── layer_0_weights_biases.txt
    ├── layer_1_weights_biases.txt
    ├── x_test.txt
    └── y_test.txt
```

## Quick Start

### Prerequisites

```bash
pip3 install torch torchvision
```

### Train & Export

```bash
cd python_train
python3 train.py
```

This will:
1. Download MNIST dataset (first run only)
2. Train the 4-layer network for 15 epochs using MPS GPU
3. Export all weights/biases as Q14 hex files
4. Export 10 test samples (one per digit class 0-9)
5. Generate a C reference implementation
6. Verify quantized inference on all 10 classes

### Verify with C Reference

```bash
cd neural_net_4layer
gcc -o neural_net neural_net.c -lm
./neural_net
```

### Test All 10 Classes in C

To test a specific class, copy the test sample before running:

```bash
cd neural_net_4layer
# Test class 3
cp test_samples/x_test_class3.txt x_test.txt
cp test_samples/y_test_class3.txt y_test.txt
./neural_net
```

## Hex File Format

All `.txt` files use **8-digit uppercase hexadecimal**, one value per line, 32-bit two's complement for negatives:

| Type | Format | Example |
|------|--------|---------|
| Positive | `0000XXXX` | `0000095D` = +2397 |
| Negative | `FFFFXXXX` | `FFFFBF0A` = -16630 |

### Weight File Layout

Each `layer_N_weights_biases.txt` contains:

1. **Weights first** (row-major: for each output neuron, all input weights)
2. **Biases** after all weights

```
weight[out=0][in=0]      ← first weight
weight[out=0][in=1]
...
weight[out=0][in=N-1]
weight[out=1][in=0]      ← second neuron's weights
...
bias[0]                  ← first bias
bias[1]
...
bias[M-1]                ← last bias
```

## Q14 Fixed-Point Quantization

All values are stored in **Q14 format**: `integer_value = round(float_value × 2^14)`

- **Scale factor:** 16384 (2^14)
- **Input pixels:** [0.0, 1.0] → [0, 16384] in Q14
- **Neuron computation:** `acc = bias_q14 + Σ(input_q14 × weight_q14) >> 14`
- All intermediate layer values stay in Q14 (no dequantization between layers)
- 64-bit accumulator recommended to avoid overflow
