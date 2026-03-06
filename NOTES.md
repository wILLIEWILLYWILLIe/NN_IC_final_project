# NOTES — MNIST 4-Layer NN Implementation Notes

## Q14 Quantization Scheme — Key Difference from 2-Layer Version

The original 2-layer `neural_net/` code uses a **double-dequantization** scheme:
```c
// ORIGINAL 2-layer (DON'T use this for 4+ layers)
acc += DEQUANTIZE_I(inputs[i] * weights[i]);  // Q14×Q14 / 2^14 = Q14
*output = acc >> BITS;                         // dequantize again → integer
```

This works for 2 layers because the signal only gets shifted twice. But for 4 layers, each `>> 14` dequantization halves the dynamic range, and values quickly collapse to zero.

### New Scheme (4-Layer)

All intermediate values **stay in Q14** throughout:
```c
// NEW 4-layer scheme
long long acc = (long long)bias;                          // Q14 bias
acc += ((long long)inputs[i] * (long long)weights[i]) >> BITS;  // Q14×Q14 >> 14 = Q14
*output = (int)acc;                                       // stays Q14!
```

**No `>> BITS` at the output.** Values flow Q14 → Q14 → Q14 → Q14 across all 4 layers.
The final argmax works directly on Q14 values (scale doesn't affect comparison).

---

## SystemVerilog Implementation Notes

### Data Path

```
                    Q14         Q14         Q14         Q14
  x_test  ──→ [Layer 0] ──→ [Layer 1] ──→ [Layer 2] ──→ [Layer 3] ──→ argmax
  (784)      ReLU (128)   ReLU (64)    ReLU (32)                    (10→class)
```

### Neuron MAC Unit

```
For each output neuron j:
    acc = bias[j]                           // signed 32-bit Q14
    for i = 0 to input_size-1:
        acc += (input[i] * weight[j][i]) >>> 14  // arithmetic right shift
    output[j] = acc                         // Q14
```

**Critical: use a 64-bit accumulator** for the multiply-accumulate:
- `input[i]` is 32-bit signed (Q14)
- `weight[j][i]` is 32-bit signed (Q14)
- Product is 64-bit signed (Q28)
- After `>>> 14`, you get Q14 result
- Accumulating many such values still needs 64-bit to avoid overflow

### ReLU

Trivial in hardware:
```verilog
assign relu_out = (signed_input > 0) ? signed_input : 32'd0;
// Or equivalently: check MSB (sign bit)
assign relu_out = signed_input[31] ? 32'd0 : signed_input;
```

### Argmax (Output Layer)

Compare 10 Q14 values, select the index of the largest. No division/softmax needed.

### Memory Requirements

| Layer | Weights (words) | Biases (words) | Input Buffer | Output Buffer |
|-------|-----------------|----------------|-------------|--------------|
| 0     | 100,352         | 128            | 784         | 128          |
| 1     | 8,192           | 64             | 128         | 64           |
| 2     | 2,048           | 32             | 64          | 32           |
| 3     | 320             | 10             | 32          | 10           |

**Total weight storage:** ~111K × 32-bit = ~444 KB

### Suggested Hardware Approaches

1. **Fully Parallel:** Instantiate all neurons simultaneously. Fastest (1-cycle per layer)
   but requires enormous area. Only feasible for smaller layers (2, 3).

2. **Time-Multiplexed:** One MAC unit per layer, iterate over neurons and inputs.
   Much smaller area, but slower (`input_size × output_size` cycles per layer).

3. **Hybrid:** Parallelize within a layer (e.g., 10-way parallel for output neurons)
   and serialize across inputs. Good balance of speed vs. area.

---

## Testing Strategy

10 test vectors are provided (`test_samples/x_test_class0.txt` through `x_test_class9.txt`),
one for each digit class. This ensures full coverage:

| Class | Expected Output | Test File |
|-------|----------------|-----------|
| 0     | argmax = 0     | `x_test_class0.txt` |
| 1     | argmax = 1     | `x_test_class1.txt` |
| 2     | argmax = 2     | `x_test_class2.txt` |
| 3     | argmax = 3     | `x_test_class3.txt` |
| 4     | argmax = 4     | `x_test_class4.txt` |
| 5     | argmax = 5     | `x_test_class5.txt` |
| 6     | argmax = 6     | `x_test_class6.txt` |
| 7     | argmax = 7     | `x_test_class7.txt` |
| 8     | argmax = 8     | `x_test_class8.txt` |
| 9     | argmax = 9     | `x_test_class9.txt` |

### Verilog Testbench Flow

```
1. $readmemh("layer_X_weights_biases.txt", weight_mem);
2. $readmemh("test_samples/x_test_class0.txt", input_mem);
3. Run inference
4. Check: output_class == 0
5. Repeat for classes 1-9
```

### C Verification

```bash
cd neural_net_4layer

# Quick test all 10 classes
for i in $(seq 0 9); do
  cp test_samples/x_test_class${i}.txt x_test.txt
  cp test_samples/y_test_class${i}.txt y_test.txt
  echo "--- Testing class $i ---"
  ./neural_net
done
```

---

## Training Details

- **Framework:** PyTorch 2.8.0
- **Device:** Apple MPS GPU (MacBook Pro)
- **Optimizer:** Adam, lr=1e-3
- **Epochs:** 15
- **Batch size:** 128
- **Loss:** CrossEntropyLoss
- **Float test accuracy:** ~97.5%
- **Quantized accuracy:** Tested per-class on all 10 digits
