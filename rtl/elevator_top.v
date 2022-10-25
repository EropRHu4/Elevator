`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2022 11:37:54
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


`define COLOR_BITS          'd4

module top
#(
  parameter SIMULATION = 1'b0
 )
 (
input                                  CLK,
input                                  RESET_N,
input           [3:0]                  SW,

output          [7:0]                  HEX,    
output          [7:0]                  AN,
output          [7:0]                  LED,
output          [`COLOR_BITS - 1 : 0 ] RED, 
output          [`COLOR_BITS - 1 : 0 ] GREEN, 
output          [`COLOR_BITS - 1 : 0 ] BLUE,
output   wire                          HSYNC, 
output   wire                          VSYNC

    );

reg rst_n_1;  // for metastability
reg rst_n_2;  // for metastability
wire rst_n_db; // after debounce
wire rst_n; // after reset_n module

always @(posedge CLK) begin
    rst_n_1 <= RESET_N;
    rst_n_2 <= rst_n_1;
end

    button_debouncer 
    button_debouncer_rst
    (
      .clk              (CLK),
      .rst_n            (rst_n_2),
      .rst_n_db         (rst_n_db)
    );
    
    reset_n_rst 
    #(
    .SIMULATION         (SIMULATION)
    )
    reset
    (
      .clk              (CLK),
      .rst_n            (rst_n_db),
      .reset_n          (rst_n)
    );
   
    elevator el
    (
      .clk              (CLK),
      .rst_n            (rst_n),   
      .SW               (SW),
      .HEX              (HEX),
      .AN               (AN),
      .LED              (LED),
      .red              (RED),
      .green            (GREEN),
      .blue             (BLUE),
      .hsync            (HSYNC),
      .vsync            (VSYNC)
    );
    
endmodule
