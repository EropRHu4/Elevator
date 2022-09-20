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
       [7:0] AN,
  reg  [7:0] LED

    );

    parameter IDLE     = 2'b00,     // начальное состояние, в которое переходит автомат при rst
              WAIT     = 2'b01,      // движение лифта до кнопки на пассажира
              MOVE     = 2'b10,     // движение лифта до этажа, на который нажал пассажир в лифте
              DOORS    = 2'b11;     // работа дверей

reg [7:0] assist_hex;

reg [7:0] assist_an;

reg [1:0] state, next;

reg doors;                          // индикатор дверей ( открыты "1" / закрыты "0" )

reg [2:0] num_of_floors = 3'b111;   // количество этажей в доме

reg butt = 1'b0;

reg [2:0] time_cnt = 0;

reg [2:0] elev_f_o = 0;

reg [27:0] cnt = 0;

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

always @( posedge clk or negedge rst_n) begin
    if ( !rst_n ) state <= IDLE;
    else begin
            state <= next;
    end
end

always @( posedge clk ) begin
    next = 'bx;
    LED[elev_f_o - 1] <= 1'b1;
    case( state )
    IDLE: begin
            doors <= 1'b0;
            next = WAIT;
            LED[0] <= 1'b1;
            elev_f_o <= 1'b1;
            LED[6:0] <= 0;
//            assist_hex <= 8'b1111_1001;
          end

    WAIT: begin
            if ( |SW[2:0] )
                    next = MOVE;
            else next = WAIT;
    end

    MOVE: begin
            if ( |SW[2:0] ) begin
                butt <= 1'b1;
                if ( elev_f_o != SW[2:0] && SW[3]) begin
                        next = MOVE;
                        if (cnt != 'd250_000_000) begin
                            cnt <= cnt + 1;
                            LED[elev_f_o - 1] <= 1'b1;
                        end
                        else begin
                            LED[elev_f_o - 1] <= 1'b0;
                            elev_f_o <= elev_f_o < SW[2:0] ? elev_f_o + 1 : elev_f_o - 1;
                            cnt <= 0;
                        end
                end
                else if( elev_f_o == SW[2:0] ) begin
                            butt <= 1'b0;
                            next = DOORS;
                            LED[elev_f_o - 1] <= 1'b1;
                end
                else next = MOVE;
            end
            else 
                next = WAIT; 
    end

    DOORS:      begin
                    doors <= 1'b1;
                    if ( time_cnt != 3'b011 ) begin
                            time_cnt <= time_cnt + 1'b1;
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
