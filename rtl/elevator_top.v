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


module elevator_top
#(
  parameter SIMULATION = 1'b0
 )
 (
input        clk,
             reset_n,
       [3:0] SW,

output [7:0] HEX,    
       [7:0] AN,
       [7:0] LED

    );

reg rst_n_1;  // for metastability
reg rst_n_2;  // for metastability
reg rst_n_db; // after debounce
reg rst_n; // after reset_n module

always @(posedge clk) begin
    rst_n_1 <= reset_n;
    rst_n_2 <= rst_n_1;
end

    button_debouncer debounce
    (
      .clk              (clk),
      .rst_n            (rst_n_2),
      .rst_n_db         (rst_n_db)
    );
    
    reset_n 
    #(
    .SIMULATION(SIMULATION)
    )
    reset
    (
      .clk              (clk),
      .rst_n            (rst_n_db),
      .reset_n          (rst_n)
    );
   
    elevator el
    (
      .clk              (clk),
      .rst_n            (rst_n),   
      .SW               (SW),
      .HEX              (HEX),
      .AN               (AN),
      .LED              (LED)
    );
    
    vga_controller vga
    (
     .clk               (clk),
     .rst               (rst_n),
     .VGA_R             (VGA_R),
     .VGA_G             (VGA_G),
     .VGA_B             (VGA_B),
     .VGA_HS            (VGA_HS),
     .VGA_VS            (VGA_VS)
    );

endmodule
