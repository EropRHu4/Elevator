`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2022 11:09:26
// Design Name: 
// Module Name: hex_controller
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


module hex_controller(
input             clk,
                  rst_n,
         [2:0]    elev_f_o,

output   [7:0]    HEX,    
         [7:0]    AN
    );
  
reg [7:0] assist_hex;

reg [7:0] assist_an;

assign AN = assist_an;
assign HEX = assist_hex;

always @(posedge clk) begin
    assist_an <= 8'b1111_1110;
    case(elev_f_o)
        'b001: assist_hex <= 8'b1111_1001; //1
        'b010: assist_hex <= 8'b1010_0100; //2
        'b011: assist_hex <= 8'b1011_0000; //3
        'b100: assist_hex <= 8'b1001_1001; //4
        'b101: assist_hex <= 8'b1001_0010; //5
        'b110: assist_hex <= 8'b1000_0010; //6
        'b111: assist_hex <= 8'b1111_1000; //7
        default: assist_hex <= 8'b1111_1001; //1
    endcase
end
    
endmodule
