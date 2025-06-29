`timescale 1ns / 1ns
//TOP----MODULE...
module uart_top (
    input wire clk,                 // System clock...
    input wire reset,               // Reset signal...
    input wire [1:0] sel,           // Baud rate selector...
    input wire tx_start,            // Start signal for TX...
    input wire [7:0] tx_data,       // Data to transmit...
    output wire tx,                 // UART TX line...
    output wire [7:0] rx_data,      // Received data...
    output wire rx_done             // High when RX completes a byte...
);

    wire out_clk;       // Baud clock shared between TX and RX...
    wire tx_busy;       // Indicates TX is transmitting...

    // ---------------------------------------
    // Baud Generator Instance (shared clock)...
    // ---------------------------------------
    baud_gen baud_inst (
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .out_clk(out_clk)
    );

    // ---------------------------------------
    // TX Module...
    // ---------------------------------------
    tx tx_inst (
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .out_clk(out_clk)
    );

    // ---------------------------------------
    // RX Module...
    // ---------------------------------------
    rx rx_inst (
        .clk(clk),
        .reset(reset),
        .out_clk(out_clk),
        .tx(tx),            // Connected to TX output
        .tx_busy(tx_busy),  // Reference to start RX
        .rx_data(rx_data),
        .shift_reg(),       // Unused here
        .rx_done(rx_done)
    );

endmodule
