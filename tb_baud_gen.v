`timescale 1ns / 1ns


module tb_baud_gen;

  reg clk = 0;
  reg reset;
  reg [1:0] sel;
  wire out_clk;
  

  
  baud_gen uut (
    .clk(clk),
    .reset(reset),
    .sel(sel),
    .out_clk(out_clk)
   
  );

  
  always #5 clk = ~clk;

  initial begin
    // Apply reset...115200
    reset = 1;
    sel = 2'b00;

    
    #20;
    reset = 0;

    // Observe for some time...
    #20000; 
    
    // Apply reset...38400
    reset = 1;
    sel = 2'b01;
    
    #20;
    reset = 0;
    // Observe for some time...
    #40000; 
    // Apply reset...19200
    reset = 1;
    sel = 2'b10;
    
    #20;
    reset = 0;
    #400000; 
    // Apply reset...9600
    reset = 1;
    sel = 2'b11;
    
    #20;
    reset = 0;
    // Observe for some time...
    #400000;
    
    
  end

  // Monitor The values...
  initial begin
    $display("Time\t\tclk\treset\tsel\tcounter\tout_clk");
    $monitor("%0t\t%b\t%b\t%b\t%0d\t%b", $time, clk, reset, sel, counter, out_clk);
  end

endmodule
