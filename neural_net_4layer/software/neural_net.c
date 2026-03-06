#include <stdio.h>
#include <stdlib.h>
#include <math.h>


// quantization
#define BITS            14
#define QUANT_VAL       (1 << BITS)

// Neural Network
#define NUM_INPUTS  784
#define NUM_OUTPUTS 10
#define NUM_LAYERS  4
#define MAX_WEIGHTS 100352
#define MAX_NEURONS 128


// ──────────────────────────────────────────────────────────────────
// Neuron: computes one output in Q14 fixed-point.
//   acc = bias (Q14)
//   acc += (input_q14[i] * weight_q14[i]) >> BITS   (Q14*Q14 = Q28, >> 14 = Q14)
//   output = acc   (stays in Q14 for next layer)
// ──────────────────────────────────────────────────────────────────
void neuron(int *inputs, int *weights, int bias, int input_size, int *output)
{
    long long acc = (long long)bias;   // use 64-bit to avoid overflow
    for (int i = 0; i < input_size; i++)
    {
        acc += ((long long)inputs[i] * (long long)weights[i]) >> BITS;
    }
    // Clamp to 32-bit range
    if (acc > 0x7FFFFFFF)  acc = 0x7FFFFFFF;
    if (acc < -0x80000000LL) acc = -0x80000000LL;
    *output = (int)acc;   // Q14 output
}

void relu(int *input, int size, int *output)
{
    for (int i = 0; i < size; i++)
    {
        output[i] = input[i] > 0 ? input[i] : 0;
    }
}

int argmax(int *input, int size)
{
    int max_val = input[0];
    int index = 0;

    printf("Output layer values (Q14):\n");
    for (int i = 0; i < size; i++)
        printf("  Class %d: %d  (float ~%.4f)\n", i, input[i],
               (double)input[i] / QUANT_VAL);

    for (int i = 1; i < size; i++)
    {
        if (input[i] > max_val)
        {
            max_val = input[i];
            index = i;
        }
    }
    return index;
}

void layer_compute(int *inputs, int *weights, int *biases,
                   int input_size, int output_size, int *outputs)
{
    for (int j = 0; j < output_size; j++)
    {
        neuron(inputs, &weights[j * input_size], biases[j], input_size, &outputs[j]);
    }
}

int deep_network(int *inputs, int num_layers,
                 int *layer_in_sizes, int *layer_out_sizes,
                 int weights[NUM_LAYERS][MAX_WEIGHTS],
                 int biases[NUM_LAYERS][MAX_NEURONS],
                 int *output)
{
    int *in_ptr = inputs;

    for (int l = 0; l < num_layers; l++)
    {
        int *out_ptr = (int *)malloc(layer_out_sizes[l] * sizeof(int));
        layer_compute(in_ptr, weights[l], biases[l],
                      layer_in_sizes[l], layer_out_sizes[l], out_ptr);
        relu(out_ptr, layer_out_sizes[l], out_ptr);
        
        // Print the first 3 values for tracing
        printf("DEBUG Layer %d out: [%d, %d, %d...]\n", l, out_ptr[0], out_ptr[1], out_ptr[2]);
        
        if (l > 0) free(in_ptr);
        in_ptr = out_ptr;
    }
    int sel = argmax(in_ptr, layer_out_sizes[num_layers - 1]);
    free(in_ptr);
    return sel;
}

int main()
{
    int inputs[NUM_INPUTS];
    int outputs[NUM_OUTPUTS];
    int weights[NUM_LAYERS][MAX_WEIGHTS];
    int biases[NUM_LAYERS][MAX_NEURONS];
    int layer_in_sizes[NUM_LAYERS]  = {784, 128, 64, 32};
    int layer_out_sizes[NUM_LAYERS] = {128, 64, 32, 10};

    // 1. Load Inputs (Q14 hex format)
    printf("Loading %d inputs from ../source/x_test.txt ...\n", NUM_INPUTS);
    FILE *f_in = fopen("../source/x_test.txt", "r");
    if (!f_in) { printf("ERROR: Could not open ../source/x_test.txt\n"); return 1; }
    for (int i = 0; i < NUM_INPUTS; i++)
    {
        unsigned int tmp;
        if (fscanf(f_in, "%08x", &tmp) != 1) {
            printf("ERROR: Failed to read input %d\n", i);
            return 1;
        }
        inputs[i] = (int)tmp;   // reinterpret as signed
    }
    fclose(f_in);

    // 2. Load Weights & Biases for each layer
    for (int l = 0; l < NUM_LAYERS; l++)
    {
        char filename[256];
        snprintf(filename, sizeof(filename), "../source/weights_and_biases/layer_%d_weights_biases.txt", l);
        printf("Loading Layer %d from %s ...\n", l, filename);
        FILE *f = fopen(filename, "r");
        if (!f) { printf("ERROR: Could not open %s\n", filename); return 1; }

        int num_w = layer_in_sizes[l] * layer_out_sizes[l];
        for (int i = 0; i < num_w; i++) {
            unsigned int tmp;
            if (fscanf(f, "%08x", &tmp) != 1) {
                printf("ERROR: Failed reading weight %d in Layer %d\n", i, l);
                return 1;
            }
            weights[l][i] = (int)tmp;
        }

        for (int i = 0; i < layer_out_sizes[l]; i++) {
            unsigned int tmp;
            if (fscanf(f, "%08x", &tmp) != 1) {
                printf("ERROR: Failed reading bias %d in Layer %d\n", i, l);
                return 1;
            }
            biases[l][i] = (int)tmp;
        }
        fclose(f);
        printf("  Loaded %d weights + %d biases\n", num_w, layer_out_sizes[l]);
    }

    // 3. Run Inference
    int best_class = deep_network(inputs, NUM_LAYERS,
                                  layer_in_sizes, layer_out_sizes,
                                  weights, biases, outputs);

    printf("\n=> Predicted Class: %d\n", best_class);

    FILE *f_label = fopen("../source/y_test.txt", "r");
    if (f_label) {
        int true_label;
        if (fscanf(f_label, "%d", &true_label) == 1) {
            printf("=> True Label:      %d\n", true_label);
            if (best_class == true_label)
                printf("=> ✓ CORRECT\n");
            else
                printf("=> ✗ INCORRECT\n");
        }
        fclose(f_label);
    }

    return 0;
}
