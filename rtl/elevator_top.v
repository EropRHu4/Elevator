`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2022 10:57:04
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(

input        clk,
             rst_n,
       [3:0] SW,

output [7:0] HEX,    
       [7:0] AN,
       [7:0] LED

    );

    reset_n reset
    (
     .clk           (clk),
     .reset_n       (reset_n)
    );
    
    elevator el
    (
      .clk              (clk),
      .rst_n            (reset_n * rst_n),   
      .SW               (SW),
      .HEX              (HEX),
      .AN               (AN),
      .LED              (LED)
    );
    

endmodule
