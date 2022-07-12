`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2022 15:39:18
// Design Name: 
// Module Name: Lift
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
//`define IDLE  2'b00
//`define WAIT  2'b01
//`define MOVE  2'b10

module Lift(

input clk, 
      rst_n,
//      num_of_floors,    // ���������� ������ � ����
     [2:0] butt_el,          // ������ � ������� ����� � �����
      butt_up_down,     // ������ ������ ����� �� �����
//     [2:0] elev_f,           // ���� �� ������� ��������� ����
     [2:0] pass_f,           // ���� �� ������� �������� ����� ������ ������
//      busy_i,           // ��������� ����� ��������/�����

output [2:0] elev_f_o,
       busy_o

    );
    
    parameter IDLE = 2'b00,
              WAIT = 2'b01,
              MOVE = 2'b10;
    
reg [1:0] state, next;
reg [2:0] elev_floor;
reg flag;

assign busy_o = flag;
assign elev_f_o = elev_floor;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= IDLE;
    else        state <= next;
end


always @(*) begin
    next = 'bx;
    case(state)
    IDLE: begin
          flag <= 1'b0;
          elev_floor = 3'b001;
                        next = WAIT;
          end
    WAIT: if (butt_up_down) begin
                 flag <= 1'b1;
                 $display("The button has pressed on the %d floor", pass_f);
                 while (elev_floor != pass_f) begin 
                        elev_floor <= elev_floor < pass_f ? elev_floor + 1 : elev_floor - 1;
                 $display("Elevator is on the %d floor", elev_floor);      
                 end
                        next = MOVE;
          end
          else   flag <= 1'b0;
    MOVE: if (butt_el > 0) begin
                 while (elev_floor != butt_el) begin 
                        elev_floor <= elev_floor < butt_el ? elev_floor + 1 : elev_floor - 1;
               end 
                        next = WAIT;
          end
          else  begin 
                  flag <= 1'b0;
                        next = WAIT;
                end
          endcase
    end 
endmodule
