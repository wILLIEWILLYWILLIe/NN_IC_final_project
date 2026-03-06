import os

# Updated architecture: 784-32-16-16-10
L_SIZES = [(784, 32), (32, 16), (16, 16), (16, 10)]
LANES = 32
DATA_WIDTH = 16

def parse_txt(filename):
    if not os.path.exists(filename):
        print(f"Warning: {filename} not found.")
        return []
    with open(filename, 'r') as f:
        return [line.strip() for line in f if line.strip()]

def get_weights_biases(layer_id):
    in_size, out_size = L_SIZES[layer_id]
    filename = f"../source/layer_{layer_id}_weights_biases.txt"
    tokens = parse_txt(filename)

    if not tokens:
        print(f"Warning: No data found in {filename}.")
        return [], []

    num_w = in_size * out_size
    weights_flat = tokens[:num_w]
    biases = tokens[num_w:]

    weights = []
    for n in range(out_size):
        start_idx = n * in_size
        end_idx = start_idx + in_size
        w_row = weights_flat[start_idx:end_idx]
        if len(w_row) != in_size:
            print(f"Warning: Layer {layer_id} Neuron {n} weight size mismatch. Expected {in_size}, got {len(w_row)}")
            w_row.extend(["0000"] * (in_size - len(w_row)))
        weights.append(w_row)
    
    return weights, biases

os.makedirs("../source/npu_weights", exist_ok=True)

all_w = [get_weights_biases(l) for l in range(len(L_SIZES))]

all_banks_w = []
all_banks_b = []

for b in range(LANES):
    bank_w = []
    bank_b = []
    
    # Layer 0 (784 -> 32)
    # 32 neurons mapped to 32 lanes.
    if b < L_SIZES[0][1]:
        bank_w.extend(all_w[0][0][b])
        bank_b.append(all_w[0][1][b])
    else:
        bank_w.extend(["0000"] * L_SIZES[0][0])
        bank_b.append("0000")

    # Layer 1 (32 -> 16)
    # 16 neurons mapped to first 16 lanes. Remaining 16 lanes get 0s for this layer's slice.
    if b < L_SIZES[1][1]:
        bank_w.extend(all_w[1][0][b])
        bank_b.append(all_w[1][1][b])
    else:
        bank_w.extend(["0000"] * L_SIZES[1][0])
        bank_b.append("0000")

    # Layer 2 (16 -> 16)
    if b < L_SIZES[2][1]:
        bank_w.extend(all_w[2][0][b])
        bank_b.append(all_w[2][1][b])
    else:
        bank_w.extend(["0000"] * L_SIZES[2][0])
        bank_b.append("0000")

    # Layer 3 (16 -> 10)
    if b < L_SIZES[3][1]:
        bank_w.extend(all_w[3][0][b])
        bank_b.append(all_w[3][1][b])
    else:
        bank_w.extend(["0000"] * L_SIZES[3][0])
        bank_b.append("0000")
        
    with open(f"../source/npu_weights/bank{b}_weights.txt", "w") as f:
        f.write("\n".join(bank_w) + "\n")
    with open(f"../source/npu_weights/bank{b}_biases.txt", "w") as f:
        f.write("\n".join(bank_b) + "\n")

    all_banks_w.append(bank_w)
    all_banks_b.append(bank_b)

# Generate SystemVerilog Package for Synthesis
pkg_path = "../hardware/frontend/sv/weight_pkg.sv"
total_w = sum(l[0] for l in L_SIZES) # 784 + 32 + 16 + 16 = 848
total_b = len(L_SIZES)              # 4

with open(pkg_path, "w") as f:
    f.write("// =============================================================\n")
    f.write("// Generated Weight Package for Synthesis\n")
    f.write("// =============================================================\n")
    f.write("package weight_pkg;\n")
    f.write("    import nn_pkg::*;\n\n")
    
    # Weights
    f.write(f"    parameter signed [DATA_WIDTH-1:0] ALL_WEIGHTS [32][{total_w}] = '{{\n")
    for b in range(LANES):
        formatted_w = [f"16'h{w}" for w in all_banks_w[b]]
        f.write("        '{" + ", ".join(formatted_w) + "}")
        if b < LANES - 1: f.write(",")
        f.write("\n")
    f.write("    };\n\n")

    # Biases
    f.write(f"    parameter signed [DATA_WIDTH-1:0] ALL_BIASES [32][{total_b}] = '{{\n")
    for b in range(LANES):
        formatted_b = [f"16'h{b_val}" for b_val in all_banks_b[b]]
        f.write("        '{" + ", ".join(formatted_b) + "}")
        if b < LANES - 1: f.write(",")
        f.write("\n")
    f.write("    };\n")
    f.write("endpackage\n")

print(f"NPU banks (16-bit) and SV package generated successfully!")
