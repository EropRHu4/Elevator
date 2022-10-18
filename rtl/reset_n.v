`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2022 12:02:55
// Design Name: 
// Module Name: reset_n
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


module reset_n
#(
  parameter SIMULATION = 1'b0
  )
(

input clk,
      rst_n,

output reg reset_n = 0  // 10000 

    );

parameter RESET_TIMER_MS = 10000;
parameter TIMER_MAX = SIMULATION ? 10 : RESET_TIMER_MS;

reg [13:0] count = 'b0;

always @(posedge clk) begin
    if (rst_n) begin
        if (count != TIMER_MAX)
            count <= count + 'b1;
        else begin
            reset_n <= 1;
            count <= 0;
        end
    end
    else begin
            reset_n <= rst_n;
            count <= 0;
    end
end

endmodule
