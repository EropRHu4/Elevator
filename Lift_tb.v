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
//      reg   num_of_floors;    // ���������� ������ � ����
      reg   [2:0] butt_el;          // ������ � ������� ����� � �����
      reg   butt_up_down;     // ������ ������ ����� �� �����
//      reg   [2:0] elev_f;           // ���� �� ������� ��������� ����
      reg   [2:0] pass_f;           // ���� �� ������� �������� ����� ������ ������
//      reg   busy_i;           // ��������� ����� ��������/�����
      
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
      rst_n = 1;
      #30;
      rst_n = 0;
      
      pass_f = 3'b011; // �������� �� 3
     
      butt_up_down = 1'b1;
      
      butt_el = 3'b111;
      
      pass_f = 3'b010;
      
      butt_up_down = 1'b1;
      
      butt_el = 3'b101;
      
      end
      
endmodule
