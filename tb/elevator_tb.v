`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2022 11:10:27
// Design Name: 
// Module Name: elevator_tb
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


module elevator_tb();
      reg        clk;
      reg        rst_n;
      reg  [3:0] SW;
      
      wire [7:0] HEX;
      wire [7:0] LED;
      wire [7:0] AN;
      
      top      elev_tb 
      (
      .clk              (clk),
      .rst_n            (rst_n),
      .SW               (SW),
      .HEX              (HEX),
      .LED              (LED),
      .AN               (AN)
      );
      
      always begin
      #10;
      clk = ~clk;
      end
      
      initial begin
      clk = 1'b0;
      rst_n = 0;
      #50;
      rst_n = 1;
      
      
      SW[2:0] = 3'b011;
      SW[3] = 1;
      #100;
      SW[3] = 0;
      #100;
      SW[2:0] = 3'b001;
      SW[3] = 1;
      #100;
      SW[3] = 0;
       #100;
      SW[2:0] = 3'b111;
      SW[3] = 1;
      
      end
      
endmodule
