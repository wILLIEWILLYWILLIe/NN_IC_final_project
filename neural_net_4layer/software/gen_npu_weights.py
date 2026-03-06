import os

L_SIZES = [(784, 128), (128, 64), (64, 32), (32, 10)]
LANES = 32

def parse_txt(filename):
    with open(filename, 'r') as f:
        return [line.strip() for line in f if line.strip()]

def get_weights_biases(layer_id):
    in_size, out_size = L_SIZES[layer_id]
    weights = []
    biases = parse_txt(f"../source/weights_and_biases/layer{layer_id}_biases.txt")
    
    for n in range(out_size):
        w_row = parse_txt(f"../source/weights_and_biases/layer{layer_id}_neuron{n}_weights.txt")
        weights.append(w_row)
    return weights, biases

os.makedirs("../source/npu_weights", exist_ok=True)

all_w = [get_weights_biases(l) for l in range(4)]

for b in range(LANES):
    bank_w = []
    bank_b = []
    
    # L0
    out_size = L_SIZES[0][1]
    passes = out_size // LANES
    for p in range(passes):
        n_idx = p * LANES + b
        bank_w.extend(all_w[0][0][n_idx])
        bank_b.append(all_w[0][1][n_idx])
        
    # L1
    out_size = L_SIZES[1][1]
    passes = out_size // LANES
    for p in range(passes):
        n_idx = p * LANES + b
        bank_w.extend(all_w[1][0][n_idx])
        bank_b.append(all_w[1][1][n_idx])
        
    # L2
    out_size = L_SIZES[2][1]
    passes = out_size // LANES
    for p in range(passes):
        n_idx = p * LANES + b
        bank_w.extend(all_w[2][0][n_idx])
        bank_b.append(all_w[2][1][n_idx])
        
    # L3
    out_size = L_SIZES[3][1]
    # L3 has 10 neurons, which is < 32 (1 pass)
    n_idx = b
    if n_idx < out_size:
        bank_w.extend(all_w[3][0][n_idx])
        bank_b.append(all_w[3][1][n_idx])
    else:
        bank_w.extend(["00000000"] * L_SIZES[3][0])
        bank_b.append("00000000")
        
    with open(f"../source/npu_weights/bank{b}_weights.txt", "w") as f:
        f.write("\n".join(bank_w) + "\n")
    with open(f"../source/npu_weights/bank{b}_biases.txt", "w") as f:
        f.write("\n".join(bank_b) + "\n")

print("NPU banks generated successfully from weights_and_biases directory!")
