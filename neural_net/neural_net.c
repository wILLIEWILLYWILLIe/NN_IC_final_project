#include <stdio.h>
#include <stdlib.h>
#include <math.h>


// quantization
#define BITS            14
#define QUANT_VAL       (1 << BITS)
#define QUANTIZE_F(f)   (int)(((int)(f) * (int)QUANT_VAL))
#define QUANTIZE_I(i)   (int)((int)(i) * (int)QUANT_VAL)
#define DEQUANTIZE_I(i) (int)((int)(i) / (int)QUANT_VAL)
#define DEQUANTIZE_F(i) (int)((int)(i) / (int)QUANT_VAL)

// Neural Network
#define NUM_INPUTS 784
#define NUM_OUTPUTS 10
#define NUM_LAYERS 2
#define NUM_WEIGHTS 7840 
#define MAX_NEURONS 10


void neuron(int *inputs, int *weights, int bias, int input_size, int *output) 
{
    int acc = bias;
    for (int i = 0; i < input_size; i++)
    {
        acc += DEQUANTIZE_I(inputs[i] * weights[i]);
    }
    *output = acc >> BITS; // Dequantize output by shifting right by number of bits
}

void relu(int *input, int size, int *output) 
{
    for (int i = 0; i < size; i++) 
    {
        output[i] = input[i] > 0 ? input[i] : 0;
    }
}

int softmax(int *input, int size, int *output) 
{
    int max_val = input[0];
    int index = 0;

    printf("Softmax Inputs:\n");
    for (int i = 0; i < size; i++) printf("  Class %d: %d\n", i, input[i]);

    for (int i = 1; i < size; i++) 
    {
        if (input[i] > max_val) 
        {
            max_val = input[i];
            index = i;
        }
    }
    *output =  max_val;
    return index;
}

void layer(int *inputs, int *weights, int *biases, int input_size, int output_size, int *outputs) 
{
    for (int j = 0; j < output_size; j++) 
    {
        neuron(inputs, &weights[j * input_size], biases[j], input_size, &outputs[j]);
    }
}

int deep_newtwork(int *inputs, int num_layers, int *layer_in_sizes, int *layer_out_sizes, int weights[NUM_LAYERS][NUM_WEIGHTS], int biases[NUM_LAYERS][MAX_NEURONS], int *output) 
{
    int *in_ptr = inputs;

    for (int l = 0; l < num_layers; l++) 
    {
        int *out_ptr = (int *)malloc(layer_out_sizes[l] * sizeof(int));
        layer(in_ptr, weights[l], biases[l], layer_in_sizes[l], layer_out_sizes[l], out_ptr);
        relu(out_ptr, layer_out_sizes[l], out_ptr);
        in_ptr = out_ptr;
    }
    int sel = softmax(in_ptr, layer_out_sizes[num_layers - 1], (int *)output);
    return sel;
}

int main() 
{
    int inputs[NUM_INPUTS]; 
    int outputs[NUM_OUTPUTS]; 
    int weights[NUM_LAYERS][NUM_WEIGHTS];
    int biases[NUM_LAYERS][MAX_NEURONS];
    int layer_in_sizes[NUM_LAYERS] = {NUM_INPUTS, 10};
    int layer_out_sizes[NUM_LAYERS] = {10, 10};
    
    // 1. Load Inputs
    printf("Loading %d inputs from x_test.txt...\n", NUM_INPUTS);
    FILE *f_in = fopen("x_test.txt", "r");
    if (!f_in) {
        printf("ERROR: Could not open x_test.txt\n");
        return 1;
    }
    for (int i = 0; i < NUM_INPUTS; i++) 
    {
        if (fscanf(f_in, "%08x", &inputs[i]) != 1) {
            printf("ERROR: Failed to read int at input line %d\n", i + 1);
            return 1;
        }
    }
    fclose(f_in);

    // 2. Load Weights & Biases
    for (int l = 0; l < NUM_LAYERS; l++) 
    {
        char filename[256];
        snprintf(filename, sizeof(filename), "layer_%d_weights_biases.txt", l);
        printf("Loading weights and biases for Layer %d from %s...\n", l, filename);
        FILE *f = fopen(filename, "r");
        if (!f) {
            printf("ERROR: Could not open %s\n", filename);
            return 1;
        }
        
        // load weights (should be the same as number of inputs * number of outputs)
        int num_w = layer_in_sizes[l] * layer_out_sizes[l];
        for (int i = 0; i < num_w; i++) {
            if (fscanf(f, "%08x", &weights[l][i]) != 1) {
                printf("ERROR: Failed reading weight %d in Layer %d\n", i, l);
                return 1;
            }
        }

        // load biases (should be the same as number of outputs)
        for (int i = 0; i < layer_out_sizes[l]; i++) {
            if (fscanf(f, "%08x", &biases[l][i]) != 1) {
                printf("ERROR: Failed reading bias %d in Layer %d\n", i, l);
                return 1;
            }
        }
        fclose(f);
        printf("Successfully loaded %s\n", filename);
    }

    // 3. Run Inference
    int best_class = deep_newtwork(inputs, NUM_LAYERS, layer_in_sizes, layer_out_sizes, weights, biases, outputs);

    printf("\n=> Predicted Class: %d\n", best_class);

    FILE *f_label = fopen("y_test.txt", "r");
    if (f_label) {
        int true_label;
        if (fscanf(f_label, "%d", &true_label) == 1) {
            printf("=> True Label: %d\n", true_label);
        }
        fclose(f_label);
    }

    return 0;
}
