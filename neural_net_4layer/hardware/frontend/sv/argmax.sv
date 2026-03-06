// =============================================================
// Argmax Module — Iterative find-max (Two-Process)
// =============================================================
// Processes one score per cycle instead of all-at-once.
// Latency = NUM_CLASSES + 1 cycles, but much shorter critical path.
// =============================================================
module argmax
    import nn_pkg::*;
#(
    parameter NUM_CLASSES = 10
)
(
    input  logic                          clk,
    input  logic                          reset,
    input  logic                          start,          // pulse: begin comparison
    input  logic signed [DATA_WIDTH-1:0]  scores [NUM_CLASSES],
    output logic                          valid_out,
    output logic [3:0]                    predicted_class,
    output logic signed [DATA_WIDTH-1:0]  max_score
);

    // State registers
    logic                          active,      active_next;
    logic [3:0]                    idx,         idx_next;
    logic [3:0]                    best_idx,    best_idx_next;
    logic signed [DATA_WIDTH-1:0] best_val,    best_val_next;
    logic                          valid_out_r, valid_out_next;

    // ---------------------------------------------------------
    // Process 1: Combinational next-state logic
    // ---------------------------------------------------------
    always_comb begin
        active_next    = active;
        idx_next       = idx;
        best_idx_next  = best_idx;
        best_val_next  = best_val;
        valid_out_next = 1'b0;

        if (start) begin
            // Initialize with first element
            active_next   = 1'b1;
            idx_next      = 4'd1;       // start comparing from index 1
            best_idx_next = 4'd0;
            best_val_next = scores[0];
        end

        if (active) begin
            // Compare current element with running best
            if (scores[idx] > best_val) begin
                best_val_next = scores[idx];
                best_idx_next = idx;
            end

            if (idx == NUM_CLASSES - 1) begin
                active_next    = 1'b0;
                valid_out_next = 1'b1;
            end else begin
                idx_next = idx + 1;
            end
        end
    end

    // ---------------------------------------------------------
    // Process 2: Sequential state register update
    // ---------------------------------------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            active      <= 1'b0;
            idx         <= '0;
            best_idx    <= '0;
            best_val    <= '0;
            valid_out_r <= 1'b0;
        end else begin
            active      <= active_next;
            idx         <= idx_next;
            best_idx    <= best_idx_next;
            best_val    <= best_val_next;
            valid_out_r <= valid_out_next;
        end
    end

    assign valid_out       = valid_out_r;
    assign predicted_class = best_idx;
    assign max_score       = best_val;

endmodule
