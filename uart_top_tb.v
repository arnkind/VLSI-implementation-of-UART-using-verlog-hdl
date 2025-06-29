`timescale 1ns / 1ns

module uart_top_tb;

    // Testbench signals
    reg clk = 0;
    reg reset ;
    reg [1:0] sel;         
    reg tx_start = 0;
    reg [7:0] tx_data ;     

    wire tx;
    wire [7:0] rx_data;
    wire rx_done;

    
    always #5 clk = ~clk;

    // Instantiate UART top module...
    uart_top uut (
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Test process begin...
    initial begin
        $dumpfile("uart_top.vcd");       // For GTKWave...
        $dumpvars(0, uart_top_tb);
        $display("Starting UART Top Test...");
         reset =1;
         tx_start=0;
         sel=2'b00;
         tx_data = 8'hA8;
        // Done Applying reset and load data
        #20 reset = 0;

        // Wait some cycles, then start transmission...
        #40;
        tx_start = 1;
        

        // Wait for RX to complete...
        wait(rx_done == 1);
        #10000;
        $display("Actual input data: %h",tx_data );
        $display("RX done! Received data: %h", rx_data);
        if (rx_data === tx_data)
            $display("UART test passed.");
        else
            $display("UART test failed.");
        
        
        reset =1;
         tx_start=0;
         sel=2'b01;
         tx_data = 8'hC8;
        // Done Applying reset and load data...
        #20 reset = 0;

        // Wait some cycles, then start transmission...
        #40;
        tx_start = 1;
        

        // Wait for RX to complete...
        wait(rx_done == 1);
        #10000;
        $display("Actual input data: %h",tx_data );
        $display("RX done! Received data: %h", rx_data);
        
        if (rx_data === tx_data)
            $display("UART test passed.");
        else
            $display("UART test failed.");

        #50;
        $finish;
    end

endmodule
