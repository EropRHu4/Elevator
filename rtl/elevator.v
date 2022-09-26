`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2022 11:07:32
// Design Name: 
// Module Name: elevator
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


module elevator(

input        clk,
             rst_n,
       [3:0] SW,

output [7:0] HEX,    
       [7:0] AN,
  reg  [7:0] LED

    );

    parameter IDLE     = 2'b00,     // начальное состояние, в которое переходит автомат при rst
              WAIT     = 2'b01,      // движение лифта до кнопки на пассажира
              MOVE     = 2'b10;     // движение лифта до этажа, на который нажал пассажир в лифте

reg [1:0] state;

reg doors;                          // индикатор дверей ( открыты "1" / закрыты "0" )

reg [2:0] num_of_floors = 3'b111;   // количество этажей в доме

reg butt = 1'b0;

reg [2:0] elev_f_o = 0;

reg [27:0] cnt = 0;

hex_controller hex
(
 .clk           (clk),
 .rst_n         (rst_n),
 .elev_f_o      (elev_f_o),
 .HEX           (HEX),
 .AN            (AN)
);

always @(posedge clk) begin
    case (elev_f_o)
        'b001: LED <= 8'b0000_0001;
        'b010: LED <= 8'b0000_0010;
        'b011: LED <= 8'b0000_0100;
        'b100: LED <= 8'b0000_1000;
        'b101: LED <= 8'b0001_0000;
        'b110: LED <= 8'b0010_0000;
        'b111: LED <= 8'b0100_0000;
        default: LED <= 8'b0000_0001;
    endcase
end

always @( posedge clk or negedge rst_n) begin
    if ( !rst_n ) state <= IDLE;
    else begin
        state <= 'bx;
        case( state )
        IDLE: begin
                    doors <= 1'b0;
                    state <= WAIT;
                    elev_f_o <= 1'b1;
              end

        WAIT: begin
              if ( |SW[2:0] )
                    state <= MOVE;
              else  state <= WAIT;
              end

        MOVE: begin
              if ( |SW[2:0] ) begin
                    butt <= 1'b1;
                    if ( elev_f_o != SW[2:0] && SW[3]) begin
                            state <= MOVE;
                            if (cnt != 'd250_000_000) begin
                                cnt <= cnt + 1;
                            end
                            else begin
                                elev_f_o <= elev_f_o < SW[2:0] ? elev_f_o + 1 : elev_f_o - 1;
                                cnt <= 0;
                            end
                    end
                    else if( elev_f_o == SW[2:0] ) begin
                                butt <= 1'b0;
                                state <= WAIT;
                    end
                    else state <= MOVE;
              end
              else 
                    state <= WAIT; 
              end
              
        default:    begin
                            state <= IDLE;
                    end
        endcase
        end
end
endmodule
