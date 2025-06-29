`timescale 1ns / 1ns
//RX----MODULE....
module rx (
    input wire clk,               // System clock...
    input wire reset,             // Reset...
    input wire out_clk,           // Baud clock (same as TX)...
                                  //out_clk(Direct port instance insted of whole module(baud_gen) instance)...  
    input wire tx,                // Serial input line from TX to connect with rx module...
    input wire tx_busy,           // TX busy signal (used as reference to start and end the receving process)...
    output reg [7:0] rx_data,     // Final recived data...
    output reg [7:0] shift_reg,   // actual in-module reg but declared as output to observe the timing...
    output reg rx_done            // High when a byte is fully received...
);

    // FSM states...
    localparam WAIT   = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam DONE    = 2'b10;

    reg [1:0] state = WAIT;
    reg [3:0] bit_index = 0;
    

    always @(posedge out_clk or posedge reset) begin
        if (reset) begin
            state <= WAIT;
            bit_index <= 0;
            shift_reg <= 0;
            rx_done <= 0;
        end else begin
            case (state)
                WAIT: begin
                    rx_done <= 0;
                    if (tx_busy == 1 && tx == 1'b0) begin // Wait for start bit...
                        bit_index <= 0;
                        state <= RECEIVE;
                    end
                end

                RECEIVE: begin
                    shift_reg[bit_index] <= tx;
                    bit_index <= bit_index + 1;
                    if (bit_index == 7) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    rx_data <= shift_reg;
                    rx_done <= 1;
                    state <= WAIT;
                end
            endcase
        end
    end

endmodule
