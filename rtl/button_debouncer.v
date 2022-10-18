`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2022 14:01:06
// Design Name: 
// Module Name: button_debouncer
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


module button_debouncer(
input   clk,
        rst_n,

output  reg rst_n_db = 0
    );

reg prev = 0;

reg [9:0] count = 0; //1000

initial prev = rst_n;

always @(posedge clk) begin
    if (prev != rst_n) begin
        if (count != 'd1000) begin
            count <= count + 1;
        end
        else begin
            prev <= rst_n;
            rst_n_db <= rst_n;
            count <= 0;
        end
    end
    else begin
        rst_n_db <= rst_n;
        count <= 0;
    end
end
    
endmodule
