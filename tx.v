`timescale 1ns / 1ns
//TX----MODULE....
module tx (
    input wire clk,               // System clock...
    input wire reset,             // Reset...
    input wire [1:0] sel,         // Baud selector...
    input wire tx_start,          // Start signal...
    input wire [7:0] tx_data,     // Data to transmit...
    output wire tx,               // Output serial line to connect with rx module...
    output reg tx_busy,           // High when transmitting...
    output wire out_clk           // Baud clock (declared as output to observe the timing of baud clock)
                                  
);

    // Baud generator instance in tx module...
    baud_gen baud_inst (
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .out_clk(out_clk)
    );

    // FSM States...
    localparam START = 2'b00;
    localparam DATA  = 2'b01;
    localparam STOP  = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [9:0] shift_reg;
    reg [3:0] bit_index;

    reg tx_stage1, tx_stage2;
    assign tx = tx_stage2;// Final assinging of transmitted bit to a wire named tx...
    //(which is futher connected to rx module) 

    reg tx_busy_next;

    // --------------------------------------------
    // Separate Reset Logic...
    // --------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 10'b1111111111;
            bit_index <= 0;
            tx_busy <= 0;
            state <= START;
        end
    end

    // --------------------------------------------
    // Seperate FSM on baud clock to transmit...
    // --------------------------------------------
    always @(posedge out_clk ) begin
        case (state)
            START: begin
                if (tx_start && !reset) begin
                    shift_reg <= {1'b1, tx_data, 1'b0};  // Stop + Data + Start...
                    tx_stage1 <= 1'b0;                   // Start bit...
                    tx_busy_next <= 1;
                    bit_index <= 1;
                    state <= DATA;
                end else begin
                    tx_stage1 <= 1'b1;                   // Idle line...
                    tx_busy_next <= 0;
                end
            end

            DATA: begin
                tx_stage1 <= shift_reg[bit_index];
                bit_index <= bit_index + 1;
                if (bit_index == 8)
                    state <= STOP;
            end

            STOP: begin
                tx_stage1 <= shift_reg[9];  // Stop bit...
                tx_busy_next <= 0;
                state <= DONE;
            end

            DONE: begin
                tx_stage1 <= 1'b1;
            end
        endcase
    end

    // --------------------------------------------
    // Output Buffer (used two reg method to obtain the glitch free transmission)
    // --------------------------------------------
    always @(posedge out_clk) begin
        tx_stage2 <= tx_stage1;       // Final tx output...
        tx_busy <= tx_busy_next;      // Now aligned with tx_stage2...
    end

endmodule
