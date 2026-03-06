import os

layer_sizes = [(784, 128), (128, 64), (64, 32), (32, 10)]

def main():
    os.makedirs("../source", exist_ok=True)
    os.makedirs("../hardware/frontend/sv", exist_ok=True)
    
    for L, (in_size, out_size) in enumerate(layer_sizes):
        filename = f"../source/layer_{L}_weights_biases.txt"
        with open(filename, "r") as f:
            tokens = f.read().split()
        
        num_w = in_size * out_size
        weights = tokens[:num_w]
        biases = tokens[num_w:num_w+out_size]
        
        # Write individual neuron weight files
        for N in range(out_size):
            neuron_weights = weights[N*in_size : (N+1)*in_size]
            with open(f"../source/layer{L}_neuron{N}_weights.txt", "w") as fw:
                for w in neuron_weights:
                    fw.write(f"{w}\n")
        
        # Write bias file
        with open(f"../source/layer{L}_biases.txt", "w") as fb:
            for b in biases:
                fb.write(f"{b}\n")
                
        print(f"Layer {L} done: {out_size} neurons, {len(biases)} biases.")

    # Generate layer.sv
    with open("../hardware/frontend/sv/layer.sv", "w") as f:
        f.write("""// =============================================================
// Auto-generated Parameterized Dense Layer Module (4 Layers)
// =============================================================
module layer
    import nn_pkg::*;
#(
    parameter int    NUM_NEURONS   = 10,
    parameter int    INPUT_SIZE    = 784,
    parameter int    LAYER_ID      = 0,
    parameter string BIAS_FILE     = ""
)
(
    input  logic                          clk,
    input  logic                          reset,
    input  logic                          start,
    input  logic                          valid_in,
    input  logic signed [DATA_WIDTH-1:0]  data_in,
    output logic                          valid_out,
    output logic signed [DATA_WIDTH-1:0]  results [0:NUM_NEURONS-1]
);

    // ---------------------------------------------------------
    // Bias ROM
    // ---------------------------------------------------------
    logic signed [DATA_WIDTH-1:0] biases [0:200]; // Max size to prevent out of bounds
    initial begin
        if (BIAS_FILE != "") $readmemh(BIAS_FILE, biases);
    end

    // ---------------------------------------------------------
    // Neuron array (generate loop)
    // ---------------------------------------------------------
    logic                          neuron_valid [NUM_NEURONS];
    logic signed [DATA_WIDTH-1:0]  neuron_out   [NUM_NEURONS];

    genvar i;
    generate
        for (i = 0; i < NUM_NEURONS; i++) begin : gen_neurons
""")
        for L in range(4):
            out_size = layer_sizes[L][1]
            l_prefix = "if" if L == 0 else "else if"
            f.write(f"            {l_prefix} (LAYER_ID == {L}) begin : l{L}\n")
            for N in range(out_size):
                n_prefix = "if" if N == 0 else "else if"
                f.write(f"                {n_prefix} (i == {N}) begin : n{N}\n")
                f.write(f'                    neuron #(.INPUT_SIZE(INPUT_SIZE), .WEIGHT_FILE("../../../source/layer{L}_neuron{N}_weights.txt")) u_n(\n')
                f.write(f'                        .clk(clk), .reset(reset), .start(start), .bias(biases[i]), .valid_in(valid_in), .data_in(data_in), .valid_out(neuron_valid[i]), .data_out(neuron_out[i]));\n')
                f.write(f"                end\n")
            f.write(f"            end\n")

        f.write("""        end
    endgenerate

    // ---------------------------------------------------------
    // ReLU activation (combinational)
    // ---------------------------------------------------------
    assign valid_out = neuron_valid[0];

    always_comb begin
        for (int j = 0; j < NUM_NEURONS; j++)
            results[j] = (neuron_out[j] > 0) ? neuron_out[j] : '0;
    end

endmodule
""")
    print("layer.sv generated.")

if __name__ == "__main__":
    main()
