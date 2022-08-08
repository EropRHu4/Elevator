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
     [2:0] butt_el,                 // кнопка с номером этажа в лифте
           butt_up_down,            // кнопка вызова лифта на этаже
     [2:0] pass_f,                  // этаж на котором пассажир нажал кнопку вызова

output reg [2:0] elev_f_o,
       reg      busy_o              // состояние лифта ( свободен "0" / занят "1" )

    );

    parameter IDLE = 2'b00,
              WAIT = 2'b01,
              MOVE = 2'b10;

reg [1:0] state, next;


reg doors;                          // индикатор дверей ( открыты "1" / закрыты "0" )

reg [2:0] num_of_floors = 3'b111;   // количество этажей в доме

reg butt = 1'b0;

reg finish = 1'b0;

always @( posedge clk or negedge rst_n ) begin
    if ( !rst_n ) state <= IDLE;
    else          state <= next;
end


always @( posedge clk ) begin
    next = 'bx;
    case( state )
    IDLE: begin
            busy_o <= 1'b0;
            elev_f_o <= 3'b001;
            doors <= 1'b0;
                        next = WAIT;
          end
    WAIT: if ( pass_f ) begin
                 busy_o <= 1'b1;
                 butt <= 1'b1;
                 doors <= 1'b0;
                 if ( elev_f_o != pass_f ) begin
                        elev_f_o <= elev_f_o < pass_f ? elev_f_o + 1 : elev_f_o - 1;
                        state <= WAIT;
                        next = state;
                 end
                 else begin
                      butt <= 1'b0;
                      doors <= 1'b1;
                      finish <= 1'b1;
                        next = MOVE;
                 end
          end
          else busy_o <= 1'b0;
    MOVE: if ( butt_el ) begin
                 doors <= 1'b0;
                 busy_o <= 1'b1;
                 if ( elev_f_o != butt_el && finish == 1'b1) begin
                        elev_f_o <= elev_f_o < butt_el ? elev_f_o + 1 : elev_f_o - 1;
                        state <= MOVE;
                        next = state;
                 end
                 else if (elev_f_o == butt_el) begin 
                        next = MOVE;
                        busy_o <= 1'b0;
                        doors <= 1'b1;
                        finish <= 1'b0;
                 end
                 else if (elev_f_o != butt_el && finish == 1'b0) begin
                        next <= WAIT;
                        finish <= 1'b0;
                 end
          end
          else  begin
                busy_o <= 1'b0;
                doors <= 1'b0;
                        next = WAIT;
          end
    default: begin
                next = IDLE;
             end
    endcase
end
endmodule
