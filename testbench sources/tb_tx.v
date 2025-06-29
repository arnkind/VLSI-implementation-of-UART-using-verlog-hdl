`timescale 1ns / 1ns

module tb_tx;

    reg clk;
    reg reset;
    reg [1:0] sel;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx;
    wire tx_busy;
    wire out_clk;

    // Instantiate tx module...
    tx uut (
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .out_clk(out_clk)
    );

    // Clock generation...
    initial clk = 0;
    always #5 clk = ~clk; 

   
    initial begin
        // Initial values...
        reset = 1;
        sel = 2'b01;      // Select any baud rate (adjust as needed)...
        tx_start = 0;
        tx_data = 8'hA5;  // Test byte...

        // Release reset...
        #100;
        reset = 0;

        // Level tx_start...
        #50;
        tx_start = 1;
       
        
        

        // Wait for transmission...
        #2000000;

        // End simulation...
        $finish;
    end

    // Monitor the values...
    initial begin
        $monitor("Time=%0t | tx=%b | tx_busy=%b | state=%b", $time, tx, tx_busy, uut.state);
    end

endmodule
