`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2022 11:45:03
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
      parameter  SIMULATION = 1;
      reg        clk;
      reg        reset_n;
      reg  [3:0] SW;
      
      wire [7:0] HEX;
      wire [7:0] LED;
      wire [7:0] AN;
      
      top
      #(
      .SIMULATION(SIMULATION)
      )
      elev_tb
      (
      .clk              (clk),
      .reset_n          (reset_n),
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
      reset_n = 0;
      #100;
      reset_n = 1;
      
      
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
