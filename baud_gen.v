`timescale 1ns / 1ns

//BAUD--GEN----MODULE....
module baud_gen (
    input wire clk,            // actual system clk(10ns full-cycle)
    input wire reset,         // reset
    input wire [1:0] sel,     // Baud rate selector...
    output reg out_clk       // Output baud clock...
    
);

    // Clock divisor values...
    parameter DIV_115200 = 434;    
    parameter DIV_38400  = 1302;
    parameter DIV_19200  = 2604;
    parameter DIV_9600   = 5208;

    reg [15:0] counter;
    reg [15:0] div_value;

   always @(posedge clk or posedge reset) begin
  if (reset) begin
    counter <= 0;
    out_clk <= 0;
    div_value <= DIV_115200;  // Default on reset...
  end else begin
    case (sel)
      2'b00: div_value <= DIV_115200;
      2'b01: div_value <= DIV_38400;
      2'b10: div_value <= DIV_19200;
      2'b11: div_value <= DIV_9600;
      default: div_value <= DIV_115200;
    endcase

    if (counter == div_value - 1) begin
      counter <= 0;
      out_clk <= ~out_clk;
    end else begin
      counter <= counter + 1;
    end
  end
end


endmodule
