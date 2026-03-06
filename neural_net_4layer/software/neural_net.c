#include <math.h>
#include <stdio.h>
#include <stdlib.h>

// quantization
#define BITS 12
#define QUANT_VAL (1 << BITS)

// Neural Network
#define NUM_INPUTS 784
#define NUM_OUTPUTS 10
#define NUM_LAYERS 4
#define MAX_WEIGHTS 30000
#define MAX_NEURONS 32

// ──────────────────────────────────────────────────────────────────
// Neuron: computes one output in Q12 fixed-point.
// ──────────────────────────────────────────────────────────────────
void neuron(int *inputs, int *weights, int bias, int input_size, int *output) {
  long long acc = (long long)bias
                  << BITS; // Scale bias to match product range (Q24)
  for (int i = 0; i < input_size; i++) {
    acc += (long long)inputs[i] * weights[i]; // Q12 * Q12 = Q24
  }

  // Dequantize (Shift once after accumulation)
  long long shifted = acc >> BITS;

  // Saturation (16-bit signed)
  if (shifted > 32767)
    shifted = 32767;
  if (shifted < -32768)
    shifted = -32768;

  *output = (int)shifted;
}

void relu(int *input, int size, int *output) {
  for (int i = 0; i < size; i++) {
    output[i] = input[i] > 0 ? input[i] : 0;
  }
}

int argmax(int *input, int size, int class_idx) {
  int max_val = input[0];
  int index = 0;

  printf("Sample Class %d | Output layer values (Q12):\n", class_idx);
  for (int i = 0; i < size; i++)
    printf("  Class %d: %d  (float ~%.4f)\n", i, input[i],
           (double)input[i] / QUANT_VAL);

  for (int i = 1; i < size; i++) {
    if (input[i] > max_val) {
      max_val = input[i];
      index = i;
    }
  }
  return index;
}

void layer_compute(int *inputs, int *weights, int *biases, int input_size,
                   int output_size, int *outputs) {
  for (int j = 0; j < output_size; j++) {
    neuron(inputs, &weights[j * input_size], biases[j], input_size,
           &outputs[j]);
  }
}

int deep_network(int *inputs, int num_layers, int *layer_in_sizes,
                 int *layer_out_sizes, int weights[NUM_LAYERS][MAX_WEIGHTS],
                 int biases[NUM_LAYERS][MAX_NEURONS], int class_idx) {
  int *in_ptr = inputs;

  for (int l = 0; l < num_layers; l++) {
    int *out_ptr = (int *)malloc(layer_out_sizes[l] * sizeof(int));
    layer_compute(in_ptr, weights[l], biases[l], layer_in_sizes[l],
                  layer_out_sizes[l], out_ptr);
    relu(out_ptr, layer_out_sizes[l], out_ptr);

    if (l > 0)
      free(in_ptr);
    in_ptr = out_ptr;
  }
  int sel = argmax(in_ptr, layer_out_sizes[NUM_LAYERS - 1], class_idx);
  free(in_ptr);
  return sel;
}

int main() {
  int inputs[NUM_INPUTS];
  int weights[NUM_LAYERS][MAX_WEIGHTS];
  int biases[NUM_LAYERS][MAX_NEURONS];
  int layer_in_sizes[NUM_LAYERS] = {784, 32, 16, 16};
  int layer_out_sizes[NUM_LAYERS] = {32, 16, 16, 10};

  // 1. Load Weights & Biases for each layer (Once)
  for (int l = 0; l < NUM_LAYERS; l++) {
    char filename[256];
    snprintf(filename, sizeof(filename),
             "../source/layer_%d_weights_biases.txt", l);
    FILE *f = fopen(filename, "r");
    if (!f) {
      printf("ERROR: Could not open %s\n", filename);
      return 1;
    }

    int num_w = layer_in_sizes[l] * layer_out_sizes[l];
    for (int i = 0; i < num_w; i++) {
      unsigned int tmp;
      if (fscanf(f, "%04x", &tmp) !=
          1) { // Weights are 4 hex digits (16-bit) but train.py might use 8 if
               // not updated properly, checking x_test
        printf("ERROR: Failed reading weight %d in Layer %d\n", i, l);
        return 1;
      }
      weights[l][i] = (short)tmp;
    }

    for (int i = 0; i < layer_out_sizes[l]; i++) {
      unsigned int tmp;
      if (fscanf(f, "%04x", &tmp) != 1) {
        printf("ERROR: Failed reading bias %d in Layer %d\n", i, l);
        return 1;
      }
      biases[l][i] = (short)tmp;
    }
    printf("Layer %d First Bias (Q12): %d (0x%04x)\n", l, biases[l][0], (unsigned short)biases[l][0]);
    fclose(f);
  }

  // 2. Loop through 10 samples
  int correct_count = 0;
  for (int c = 0; c < 10; c++) {
    char x_path[256], y_path[256];
    snprintf(x_path, sizeof(x_path),
             "../source/test_samples/x_test_class%d.txt", c);
    snprintf(y_path, sizeof(y_path),
             "../source/test_samples/y_test_class%d.txt", c);

    FILE *f_in = fopen(x_path, "r");
    if (!f_in) {
      printf("ERROR: Could not open %s\n", x_path);
      continue;
    }
    for (int i = 0; i < NUM_INPUTS; i++) {
      unsigned int tmp;
      if (fscanf(f_in, "%04x", &tmp) != 1) {
        printf("ERROR: Failed to read input %d in %s\n", i, x_path);
        break;
      }
      inputs[i] = (short)tmp;
    }
    fclose(f_in);

    int true_label = -1;
    FILE *f_label = fopen(y_path, "r");
    if (f_label) {
      fscanf(f_label, "%d", &true_label);
      fclose(f_label);
    }

    int predicted = deep_network(inputs, NUM_LAYERS, layer_in_sizes,
                                 layer_out_sizes, weights, biases, c);

    printf("=> Sample %d | Predicted: %d | True: %d | %s\n\n", c, predicted,
           true_label, (predicted == true_label) ? "CORRECT" : "INCORRECT");

    if (predicted == true_label)
      correct_count++;
  }

  printf("==========================================\n");
  printf("FINAL ACCURACY: %d/10 (%d%%)\n", correct_count, correct_count * 10);
  printf("==========================================\n");

  return 0;
}
