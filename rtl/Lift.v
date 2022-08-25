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
//           butt_up_down,            // кнопка вызова лифта на этаже
     [2:0] pass_f,                  // этаж на котором пассажир нажал кнопку вызова

output reg [2:0] elev_f_o,
       reg      busy_o              // состояние лифта ( свободен "0" / занят "1" )

    );

    parameter IDLE     = 2'b00,     // начальное состояние, в которое переходит автомат при rst
              WAIT     = 2'b01,      // движение лифта до кнопки на пассажира
              MOVE     = 2'b10,     // движение лифта до этажа, на который нажал пассажир в лифте
              DOORS    = 2'b11;     // работа дверей

reg [1:0] state, next;


reg doors;                          // индикатор дверей ( открыты "1" / закрыты "0" )

reg [2:0] num_of_floors = 3'b111;   // количество этажей в доме

reg butt = 1'b0;

reg [2:0] time_cnt = 0;

reg [2:0] pass_f_reg = 0;

reg [2:0] butt_el_reg = 0;


always @( posedge clk ) begin
    if ( !rst_n ) state <= IDLE;
    else begin
            state <= next;
            pass_f_reg <= pass_f == 0 ? pass_f_reg : pass_f;
            butt_el_reg <= butt_el == 0 ? butt_el_reg : butt_el;
    end
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

    WAIT: begin
            if ( |pass_f || |butt_el )
                    next = MOVE;
            else
                    next = WAIT;
    end

    MOVE: begin
            time_cnt <= 1'b0;
            if ( |pass_f ) begin
                butt <= 1'b1;
                if ( elev_f_o != pass_f ) begin
                        elev_f_o <= elev_f_o < pass_f ? elev_f_o + 1 : elev_f_o - 1;
                        next = MOVE;
                end
                else if( elev_f_o == pass_f ) begin
                            butt <= 1'b0;
                            next = DOORS;    
                end
            end
            else if ( |butt_el ) begin
            butt <= 1'b0;
                  if ( elev_f_o != butt_el ) begin
                         elev_f_o <= elev_f_o < butt_el ? elev_f_o + 1 : elev_f_o - 1;
                         next = MOVE;
                  end
                  else if ( elev_f_o == butt_el ) begin
                              next = DOORS;
                              busy_o <= 1'b0;
                  end 
            end
            else if ( |butt_el == 0 || |pass_f == 0) next = WAIT; 
    end


    DOORS:      begin
                    doors <= 1'b1;
                    if ( time_cnt != 3'b011 ) begin
                            time_cnt <= time_cnt + 1'b1;
                            next = DOORS;
                    end
                    if ( |pass_f && time_cnt == 3'b011 ) begin
                            next = WAIT;
                            doors <= 1'b0;
                            time_cnt <= 1'b0;
                    end
                    else if ( |butt_el && time_cnt == 3'b011) begin
                            next = WAIT;
                            doors <= 1'b0;
                            time_cnt <= 1'b0;
                    end
                    else next = DOORS;
                    if (time_cnt == 3'b011 && (|pass_f == 0 && |butt_el == 0)) begin
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
