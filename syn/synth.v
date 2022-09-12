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

input        clk,
             rst_n,
       [3:0] SW,

output [7:0] HEX,    
       [2:0] AN,
  reg  [7:0] LED

    );

    parameter IDLE     = 2'b00,     // начальное состояние, в которое переходит автомат при rst
              WAIT     = 2'b01,      // движение лифта до кнопки на пассажира
              MOVE     = 2'b10,     // движение лифта до этажа, на который нажал пассажир в лифте
              DOORS    = 2'b11;     // работа дверей

reg [7:0] hex;


reg [1:0] state, next;

reg doors;                          // индикатор дверей ( открыты "1" / закрыты "0" )

reg [2:0] num_of_floors = 3'b111;   // количество этажей в доме

reg butt = 1'b0;

reg [2:0] time_cnt = 0;

reg [2:0] elev_f_o = 0;

reg [31:0] cnt = 'd0;

always @( posedge clk or negedge rst_n) begin
    if ( !rst_n ) state <= IDLE;
    else begin
            state <= next;
    end
end


always @( posedge clk ) begin
    next = 'bx;
    case( state )
    IDLE: begin
            doors <= 1'b0;
            next = WAIT;
            LED[0] <= 1'b1;
            elev_f_o <= 1'b0;
            LED[7:1] <= 0;
          end

    WAIT: begin
            if ( |SW[2:0] )
                    next = MOVE;
            else next = WAIT;
    end

    MOVE: begin
            if ( |SW[2:0] ) begin
                butt <= 1'b1;
                LED[elev_f_o] <= 1'b0;
                if ( elev_f_o != SW[2:0] && SW[3]) begin
                        elev_f_o <= elev_f_o < SW[2:0] ? elev_f_o + 1 : elev_f_o - 1;
                        next = MOVE;
//                        if (cnt != 'd4000_000_000) begin
//                            cnt <= cnt + 'd1;
//                            LED[elev_f_o] <= 1'b1;
//                        end
//                        else LED[elev_f_o] <= 1'b0;
                end
                else if( elev_f_o == SW[2:0] ) begin
                            butt <= 1'b0;
                            next = DOORS;
                            LED[elev_f_o] <= 1'b1;
                end
            end
            else 
                next = WAIT; 
    end

    DOORS:      begin
                    doors <= 1'b1;
                    if ( time_cnt != 3'b011 ) begin
                            time_cnt <= time_cnt + 1'b1;
                            next = DOORS;
                    end
                    if ( |SW[2:0] && time_cnt == 3'b011 ) begin
                            next = WAIT;
                            doors <= 1'b0;
                            time_cnt <= 1'b0;
                    end
                    else if (time_cnt == 3'b011 && |SW[2:0] == 0) begin
                            doors <= 1'b0;
                            next = WAIT;
                    end
                end

    default:    begin
                    next = IDLE;
                end
    endcase
end
endmodule
