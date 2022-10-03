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


module reset_n(

input clk,
      rst_n,

output reg reset_n = 0  // 10000 

    );

reg [13:0] count = 'b0;

always @(posedge clk) begin
    if (rst_n) begin
        if (count != 'd10_000)
            count <= count + 'b1;
        else
            reset_n <= 1;
    end
    else
            reset_n <= rst_n;
end

endmodule
