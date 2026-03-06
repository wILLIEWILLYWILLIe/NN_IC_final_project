#!/usr/bin/env python3
"""
4-Layer MNIST Neural Network Training & Q14 Fixed-Point Hex Export
===================================================================
Trains a fully-connected network (784→128→64→32→10) on MNIST,
quantizes all parameters to Q14 fixed-point, and exports in the
same hex format used by the companion C / SystemVerilog implementation.

Output directory: ../neural_net_4layer/
  - layer_0_weights_biases.txt  (784×128 weights + 128 biases)
  - layer_1_weights_biases.txt  (128×64  weights +  64 biases)
  - layer_2_weights_biases.txt  (64×32   weights +  32 biases)
  - layer_3_weights_biases.txt  (32×10   weights +  10 biases)
  - x_test.txt                  (784 pixel values, one test sample)
  - y_test.txt                  (true label)
  - neural_net.c                (updated C reference for 4 layers)

Usage:
    python train.py
"""

import os
import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms

# ──────────────────────────────────────────────────────────────────
# Hyperparameters
# ──────────────────────────────────────────────────────────────────
NUM_EPOCHS   = 15
BATCH_SIZE   = 128
LEARNING_RATE = 1e-3
QUANT_BITS   = 12                       # Q12 fixed-point
QUANT_SCALE  = 1 << QUANT_BITS          # 4096

# Network layer sizes  (input, hidden1, hidden2, hidden3, output)
LAYER_SIZES = [784, 32, 16, 16, 10]
NUM_LAYERS  = len(LAYER_SIZES) - 1      # 4

# Paths
SCRIPT_DIR  = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)
OUTPUT_DIR  = os.path.join(PROJECT_DIR, "neural_net_4layer")
DATA_DIR    = os.path.join(SCRIPT_DIR, "data")


# ──────────────────────────────────────────────────────────────────
# Model definition
# ──────────────────────────────────────────────────────────────────
class MNISTNet(nn.Module):
    """4-layer fully-connected network with ReLU activations."""

    def __init__(self, layer_sizes):
        super().__init__()
        layers = []
        for i in range(len(layer_sizes) - 1):
            layers.append(nn.Linear(layer_sizes[i], layer_sizes[i + 1]))
            if i < len(layer_sizes) - 2:      # ReLU on all but last layer
                layers.append(nn.ReLU())
        self.net = nn.Sequential(*layers)

    def forward(self, x):
        x = x.view(x.size(0), -1)             # flatten 28×28 → 784
        return self.net(x)


# ──────────────────────────────────────────────────────────────────
# Quantization helpers
# ──────────────────────────────────────────────────────────────────
def float_to_q12(value: float) -> int:
    """Convert a float to Q12 fixed-point (signed 16-bit integer)."""
    q = int(round(value * QUANT_SCALE))
    # Clamp to 16-bit signed range (-32768 to 32767)
    q = max(-(1 << 15), min((1 << 15) - 1, q))
    return q


def int_to_hex16(value: int) -> str:
    """Convert a signed 16-bit integer to 4-digit uppercase hex (two's complement)."""
    if value < 0:
        value = value + (1 << 16)              # two's complement
    return f"{value & 0xFFFF:04X}"


# ──────────────────────────────────────────────────────────────────
# Export helpers
# ──────────────────────────────────────────────────────────────────
def export_layer(weights_2d, biases_1d, layer_idx, output_dir):
    """
    Export one layer's weights & biases to a text file.

    File format (matches existing project):
      - All weights first, row-major: for each output neuron, list all input weights
      - Then all biases
      - One 8-digit hex value per line
    """
    filepath = os.path.join(output_dir, f"layer_{layer_idx}_weights_biases.txt")
    with open(filepath, "w") as f:
        # Weights: shape = (out_features, in_features) — row-major
        for out_i in range(weights_2d.shape[0]):
            for in_j in range(weights_2d.shape[1]):
                q = float_to_q12(weights_2d[out_i, in_j].item())
                f.write(int_to_hex16(q) + "\n")
        # Biases
        for b in biases_1d:
            q = float_to_q12(b.item())
            f.write(int_to_hex16(q) + "\n")

    num_w = weights_2d.shape[0] * weights_2d.shape[1]
    num_b = biases_1d.shape[0]
    print(f"  ✅ {filepath}  ({num_w} weights + {num_b} biases = {num_w + num_b} lines)")


def export_test_sample(dataset, output_dir, class_label, sample_idx):
    """Export one test image + label in hex format for a specific class."""
    img, label = dataset[sample_idx]
    assert label == class_label
    pixels = img.view(-1)                      # 784 values in [0, 1]

    x_path = os.path.join(output_dir, f"x_test_class{class_label}.txt")
    with open(x_path, "w") as f:
        for p in pixels:
            q = float_to_q12(p.item())
            f.write(int_to_hex16(q) + "\n")

    y_path = os.path.join(output_dir, f"y_test_class{class_label}.txt")
    with open(y_path, "w") as f:
        f.write(f"{class_label}\n")

    return pixels, label


def export_all_class_samples(dataset, output_dir):
    """
    Export one test sample per class (0-9) into test_samples/ subdirectory.
    Returns a dict: {class_label: (pixels_tensor, label)}.
    """
    samples_dir = os.path.join(output_dir, "test_samples")
    os.makedirs(samples_dir, exist_ok=True)

    # Find the first occurrence of each class in the test set
    class_indices = {}  # {label: index}
    for idx in range(len(dataset)):
        _, label = dataset[idx]
        if label not in class_indices:
            class_indices[label] = idx
        if len(class_indices) == 10:
            break

    print(f"\n  📂 Exporting test samples to {samples_dir}")
    results = {}
    for cls in range(10):
        idx = class_indices[cls]
        pixels, label = export_test_sample(dataset, samples_dir, cls, idx)
        results[cls] = (pixels, label)
        print(f"    Class {cls}: sample index {idx} → x_test_class{cls}.txt")

    # Also write a labels summary file
    summary_path = os.path.join(samples_dir, "labels.txt")
    with open(summary_path, "w") as f:
        f.write("# Test sample labels (one per class for Verilog verification)\n")
        f.write("# Format: class_label  dataset_index\n")
        for cls in range(10):
            f.write(f"{cls}  {class_indices[cls]}\n")
    print(f"    ✅ Summary: {summary_path}")

    # Also keep a default x_test.txt / y_test.txt (class 7) for backwards compat
    import shutil
    shutil.copy2(os.path.join(samples_dir, "x_test_class7.txt"),
                 os.path.join(output_dir, "x_test.txt"))
    shutil.copy2(os.path.join(samples_dir, "y_test_class7.txt"),
                 os.path.join(output_dir, "y_test.txt"))
    print(f"    ✅ Default x_test.txt / y_test.txt (class 7) copied to {output_dir}")

    return results


def generate_c_reference(output_dir, layer_sizes):
    """Generate an updated neural_net.c with correct #defines for 4 layers."""
    num_layers = len(layer_sizes) - 1
    max_neurons = max(layer_sizes[1:])         # largest hidden/output size
    max_weights = max(layer_sizes[i] * layer_sizes[i + 1] for i in range(num_layers))

    layer_in_str  = ", ".join(str(s) for s in layer_sizes[:-1])
    layer_out_str = ", ".join(str(s) for s in layer_sizes[1:])

    c_code = f"""\
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


// quantization
#define BITS            {QUANT_BITS}
#define QUANT_VAL       (1 << BITS)

// Neural Network
#define NUM_INPUTS  {layer_sizes[0]}
#define NUM_OUTPUTS {layer_sizes[-1]}
#define NUM_LAYERS  {num_layers}
#define MAX_WEIGHTS {max_weights}
#define MAX_NEURONS {max_neurons}


// ──────────────────────────────────────────────────────────────────
// Neuron: computes one output in Q14 fixed-point.
// Neuron: computes one output in Q12 fixed-point.
//   acc = bias (Q12)
//   acc += (input_q12[i] * weight_q12[i]) >> BITS   (Q12*Q12 = Q24, >> 12 = Q12)
//   output = acc   (stays in Q12 for next layer)
// ──────────────────────────────────────────────────────────────────
void neuron(int *inputs, int *weights, int bias, int input_size, int *output)
{{
    long long acc = (long long)bias;
    for (int i = 0; i < input_size; i++)
    {{
        acc += ((long long)inputs[i] * (long long)weights[i]) >> BITS;
    }}
    // Clamp to 16-bit range
    if (acc > 32767)  acc = 32767;
    if (acc < -32768) acc = -32768;
    *output = (int)acc;   // Q12 output
}}

void relu(int *input, int size, int *output)
{{
    for (int i = 0; i < size; i++)
    {{
        output[i] = input[i] > 0 ? input[i] : 0;
    }}
}}

int argmax(int *input, int size)
{{
    int max_val = input[0];
    int index = 0;

    printf("Output layer values (Q12):\\n");
    for (int i = 0; i < size; i++)
        printf("  Class %d: %d  (float ~%.4f)\\n", i, input[i],
               (double)input[i] / QUANT_VAL);

    for (int i = 1; i < size; i++)
    {{
        if (input[i] > max_val)
        {{
            max_val = input[i];
            index = i;
        }}
    }}
    return index;
}}

void layer_compute(int *inputs, int *weights, int *biases,
                   int input_size, int output_size, int *outputs)
{{
    for (int j = 0; j < output_size; j++)
    {{
        neuron(inputs, &weights[j * input_size], biases[j], input_size, &outputs[j]);
    }}
}}

int deep_network(int *inputs, int num_layers,
                 int *layer_in_sizes, int *layer_out_sizes,
                 int weights[NUM_LAYERS][MAX_WEIGHTS],
                 int biases[NUM_LAYERS][MAX_NEURONS],
                 int *output)
{{
    int *in_ptr = inputs;

    for (int l = 0; l < num_layers; l++)
    {{
        int *out_ptr = (int *)malloc(layer_out_sizes[l] * sizeof(int));
        layer_compute(in_ptr, weights[l], biases[l],
                      layer_in_sizes[l], layer_out_sizes[l], out_ptr);
        relu(out_ptr, layer_out_sizes[l], out_ptr);
        if (l > 0) free(in_ptr);
        in_ptr = out_ptr;
    }}
    int sel = argmax(in_ptr, layer_out_sizes[num_layers - 1]);
    free(in_ptr);
    return sel;
}}

int main()
{{
    int inputs[NUM_INPUTS];
    int outputs[NUM_OUTPUTS];
    int weights[NUM_LAYERS][MAX_WEIGHTS];
    int biases[NUM_LAYERS][MAX_NEURONS];
    int layer_in_sizes[NUM_LAYERS]  = {{{layer_in_str}}};
    int layer_out_sizes[NUM_LAYERS] = {{{layer_out_str}}};

    // 1. Load Inputs (Q12 hex format)
    printf("Loading %d inputs from x_test.txt ...\\n", NUM_INPUTS);
    FILE *f_in = fopen("x_test.txt", "r");
    if (!f_in) {{ printf("ERROR: Could not open x_test.txt\\n"); return 1; }}
    for (int i = 0; i < NUM_INPUTS; i++)
    {{
        unsigned int tmp;
        if (fscanf(f_in, "%04x", &tmp) != 1) {{
            printf("ERROR: Failed to read input %d\\n", i);
            return 1;
        }}
        inputs[i] = (short)tmp;   // reinterpret as signed 16-bit
    }}
    fclose(f_in);

    // 2. Load Weights & Biases for each layer
    for (int l = 0; l < NUM_LAYERS; l++)
    {{
        char filename[256];
        snprintf(filename, sizeof(filename), "layer_%d_weights_biases.txt", l);
        printf("Loading Layer %d from %s ...\\n", l, filename);
        FILE *f = fopen(filename, "r");
        if (!f) {{ printf("ERROR: Could not open %s\\n", filename); return 1; }}

        int num_w = layer_in_sizes[l] * layer_out_sizes[l];
        for (int i = 0; i < num_w; i++) {{
            unsigned int tmp;
            if (fscanf(f, "%04x", &tmp) != 1) {{
                printf("ERROR: Failed reading weight %d in Layer %d\\n", i, l);
                return 1;
            }}
            weights[l][i] = (short)tmp;
        }}

        for (int i = 0; i < layer_out_sizes[l]; i++) {{
            unsigned int tmp;
            if (fscanf(f, "%04x", &tmp) != 1) {{
                printf("ERROR: Failed reading bias %d in Layer %d\\n", i, l);
                return 1;
            }}
            biases[l][i] = (short)tmp;
        }}
        fclose(f);
        printf("  Loaded %d weights + %d biases\\n", num_w, layer_out_sizes[l]);
    }}

    // 3. Run Inference
    int best_class = deep_network(inputs, NUM_LAYERS,
                                  layer_in_sizes, layer_out_sizes,
                                  weights, biases, outputs);

    printf("\\n=> Predicted Class: %d\\n", best_class);

    FILE *f_label = fopen("y_test.txt", "r");
    if (f_label) {{
        int true_label;
        if (fscanf(f_label, "%d", &true_label) == 1) {{
            printf("=> True Label:      %d\\n", true_label);
            if (best_class == true_label)
                printf("=> ✓ CORRECT\\n");
            else
                printf("=> ✗ INCORRECT\\n");
        }}
        fclose(f_label);
    }}

    return 0;
}}
"""
    c_path = os.path.join(output_dir, "neural_net.c")
    with open(c_path, "w") as f:
        f.write(c_code)
    print(f"  ✅ {c_path}")


# ──────────────────────────────────────────────────────────────────
# Training
# ──────────────────────────────────────────────────────────────────
def get_device():
    """Pick the best available device (MPS on Apple Silicon, else CPU)."""
    if torch.backends.mps.is_available():
        print("🖥  Using Apple MPS GPU")
        return torch.device("mps")
    elif torch.cuda.is_available():
        print("🖥  Using CUDA GPU")
        return torch.device("cuda")
    else:
        print("🖥  Using CPU")
        return torch.device("cpu")


def train(model, device, train_loader, optimizer, criterion, epoch):
    model.train()
    running_loss = 0.0
    correct = 0
    total = 0
    for batch_idx, (data, target) in enumerate(train_loader):
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        output = model(data)
        loss = criterion(output, target)
        loss.backward()
        optimizer.step()

        running_loss += loss.item() * data.size(0)
        pred = output.argmax(dim=1)
        correct += pred.eq(target).sum().item()
        total += data.size(0)

    avg_loss = running_loss / total
    acc = 100.0 * correct / total
    print(f"  Epoch {epoch:2d}  |  Loss: {avg_loss:.4f}  |  Train Acc: {acc:.2f}%")


def evaluate(model, device, test_loader):
    model.eval()
    correct = 0
    total = 0
    with torch.no_grad():
        for data, target in test_loader:
            data, target = data.to(device), target.to(device)
            output = model(data)
            pred = output.argmax(dim=1)
            correct += pred.eq(target).sum().item()
            total += data.size(0)
    acc = 100.0 * correct / total
    print(f"  Test Accuracy: {acc:.2f}%  ({correct}/{total})")
    return acc


def run_quantized_inference(model, sample_pixels, true_label):
    """
    Run a single-sample inference using Q14 quantized weights in Python,
    exactly replicating the updated C code's arithmetic:
        neuron:  acc = bias_q14 + Σ(input_q14 * weight_q14) >> 14   → Q14 output
        relu:    out = max(out, 0)
    All intermediate values stay in Q14 throughout all layers.
    """
    import numpy as np

    linear_layers = [m for m in model.net if isinstance(m, nn.Linear)]

    # Quantize input pixels to Q12 (same as x_test.txt values)
    x = np.array([float_to_q12(p.item()) for p in sample_pixels], dtype=np.int64)

    for i, lin in enumerate(linear_layers):
        W = lin.weight.detach().cpu().numpy()     # (out, in)
        b = lin.bias.detach().cpu().numpy()       # (out,)
        out_size, in_size = W.shape

        W_q = np.array([[float_to_q12(W[o, j]) for j in range(in_size)]
                         for o in range(out_size)], dtype=np.int64)
        b_q = np.array([float_to_q12(b[o]) for o in range(out_size)], dtype=np.int64)

        # ── Proper Q14 computation (matches updated C code) ──
        # acc  = bias_q14
        # acc += (input_q14 * weight_q14) >> 14    → keeps result in Q14
        # output = acc  (Q14, no further dequantization)
        y = np.zeros(out_size, dtype=np.int64)
        for o in range(out_size):
            acc = int(b_q[o])
            for j in range(in_size):
                prod = int(x[j]) * int(W_q[o, j])  # Q14 × Q14 = Q28
                acc += prod >> QUANT_BITS            # Q28 >> 14 = Q14
            # Clamp to 16-bit signed range
            acc = max(-32768, min(32767, acc))
            y[o] = acc

        # ReLU
        y = np.maximum(y, 0)
        x = y                                      # next layer input (Q14)

    # Final output is in Q14 — argmax works the same regardless of scale
    predicted = int(np.argmax(x))
    print(f"\n  🔢 Quantized inference result:")
    print(f"      Predicted: {predicted}  |  True label: {true_label}")
    print(f"      Output values (Q14): {x.tolist()}")
    float_vals = [round(v / QUANT_SCALE, 4) for v in x.tolist()]
    print(f"      Output values (float): {float_vals}")
    if predicted == true_label:
        print("  ✅ Quantized prediction matches true label!")
    else:
        print("  ⚠️  Quantized prediction differs from true label.")
    return predicted


# ──────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────
def main():
    print("=" * 60)
    print("  4-Layer MNIST Training & Q12 Hex Export")
    print("=" * 60)

    device = get_device()

    # ── Data ──────────────────────────────────────────────────────
    transform = transforms.Compose([
        transforms.ToTensor(),                 # [0, 255] → [0.0, 1.0]
    ])

    print("\n📥 Downloading / loading MNIST …")
    train_dataset = datasets.MNIST(DATA_DIR, train=True,  download=True, transform=transform)
    test_dataset  = datasets.MNIST(DATA_DIR, train=False, download=True, transform=transform)

    train_loader = torch.utils.data.DataLoader(train_dataset, batch_size=BATCH_SIZE, shuffle=True)
    test_loader  = torch.utils.data.DataLoader(test_dataset,  batch_size=BATCH_SIZE, shuffle=False)

    # ── Model ─────────────────────────────────────────────────────
    model = MNISTNet(LAYER_SIZES).to(device)
    print(f"\n🏗  Model architecture: {' → '.join(map(str, LAYER_SIZES))}")
    print(model)

    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=LEARNING_RATE)

    # ── Train ─────────────────────────────────────────────────────
    print(f"\n🚀 Training for {NUM_EPOCHS} epochs …")
    for epoch in range(1, NUM_EPOCHS + 1):
        train(model, device, train_loader, optimizer, criterion, epoch)

    # ── Evaluate ──────────────────────────────────────────────────
    print("\n📊 Evaluating on test set …")
    test_acc = evaluate(model, device, test_loader)

    # ── Export ────────────────────────────────────────────────────
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print(f"\n📦 Exporting to {OUTPUT_DIR}")

    # Move model to CPU for export
    model = model.cpu()

    # Export weights & biases per layer
    linear_layers = [m for m in model.net if isinstance(m, nn.Linear)]
    for i, layer in enumerate(linear_layers):
        export_layer(layer.weight.data, layer.bias.data, i, OUTPUT_DIR)

    # Export test samples (one per class 0-9)
    class_samples = export_all_class_samples(test_dataset, OUTPUT_DIR)

    # Generate C reference
    generate_c_reference(OUTPUT_DIR, LAYER_SIZES)

    # ── Quantized verification on ALL 10 classes ──────────────────
    print("\n🔍 Verifying quantized inference on all 10 classes …")
    correct_count = 0
    for cls in range(10):
        pixels, label = class_samples[cls]
        pred = run_quantized_inference(model, pixels, label)
        if pred == label:
            correct_count += 1
    print(f"\n  📊 Quantized verification: {correct_count}/10 classes predicted correctly")

    print("\n" + "=" * 60)
    print(f"  ✅ Done!  Files exported to: {OUTPUT_DIR}")
    print(f"  📈 Float test accuracy: {test_acc:.2f}%")
    print(f"  🔢 Quantized single-sample: {correct_count}/10 correct")
    print("=" * 60)


if __name__ == "__main__":
    main()
