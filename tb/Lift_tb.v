`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2022 12:34:07
// Design Name: 
// Module Name: Lift_tb
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


module Lift_tb();
      reg   clk;
      reg   rst_n;
//      reg   num_of_floors;    // количество этажей в доме
      reg   [2:0] butt_el;          // кнопка с номерам этажа в лифте
      reg   butt_up_down;     // кнопка вызова лифта на этаже
//      reg   [2:0] elev_f;           // этаж на котором находится лифт
      reg   [2:0] pass_f;           // этаж на котором пассажир нажал кнопку вызова
//      reg   busy_i;           // состояние лифта свободен/занят
      
      wire [2:0] elev_f_o;
      wire  busy_o;
      
      Lift      lift_tb (
      .clk              (clk),
      .rst_n            (rst_n),
//      .num_of_floors    (num_of_floors),
      .butt_el          (butt_el),
      .butt_up_down     (butt_up_down),
//      .elev_f           (elev_f),
      .pass_f           (pass_f),
//      .busy_i           (busy_i),
      .elev_f_o         (elev_f_o),
      .busy_o           (busy_o)
      );
      
      always begin
      #5;
      clk = ~clk;
      end
      
      initial begin
      clk = 1'b0;
      rst_n = 0;
      #10;
      rst_n = 1;
      
      pass_f = 3'b011; // пассажир на 3
     
      butt_up_down = 1'b1;
      
      butt_el = 3'b111;
      #200;
      pass_f = 3'b010;
      
      butt_up_down = 1'b1;
      
      butt_el = 3'b101;
      
      end
      
endmodule
