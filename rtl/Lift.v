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

input      clk,
           rst_n,
//      num_of_floors,    // количество этажей в доме
     [2:0] butt_el,          // кнопка с номером этажа в лифте
           butt_up_down,     // кнопка вызова лифта на этаже
//     [2:0] elev_f,           // этаж на котором находится лифт
     [2:0] pass_f,           // этаж на котором пассажир нажал кнопку вызова
//      busy_i,           // состояние лифта свободен/занят

output reg [2:0] elev_f_o,
       wire      busy_o

    );
    
    parameter IDLE = 2'b00,
              WAIT = 2'b01,
              MOVE = 2'b10;
    
reg [1:0] state, next;
//reg [2:0] elev_floor;
reg flag;

assign busy_o = flag;
//assign elev_f_o = elev_floor;


always @( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) state <= IDLE;
    else        state <= next;
end


always @( clk ) begin
    next = 'bx;
    case( state )
    IDLE: begin
          flag <= 1'b0;
          elev_f_o <= 3'b001;
                        next = WAIT;
          end
    WAIT: if ( butt_up_down ) begin
                 flag <= 1'b1;
                
                 if ( elev_f_o != pass_f ) begin 
                        elev_f_o <= elev_f_o < pass_f ? elev_f_o + 1 : elev_f_o - 1;      
                 end
                        next = MOVE;
          end
          else   flag <= 1'b0;
    MOVE: if ( butt_el) begin
                 if ( elev_f_o != butt_el ) begin 
                        elev_f_o <= elev_f_o < butt_el ? elev_f_o + 1 : elev_f_o - 1;
                 end 
                        next = WAIT;
          end
          else  begin 
                  flag <= 1'b0;
                        next = WAIT;
          end
     default: begin
                flag <= 1'b0;
                elev_f_o <= 3'b001;
                        next = WAIT;
              end
    endcase
end 
endmodule
