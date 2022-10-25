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


`define COLOR_BITS          'd4
`define RED                 'b111100000000
`define GREEN               'b000011110000
`define BLUE                'b000000001111
`define BLACK               'b000000000000
`define WHITE               'b111111111111
`define CYAN                'b000011111111

/*`define RED     'b111000000
`define GREEN   'b000111000
`define BLUE    'b000000111
`define BLACK   'b000000000
`define WHITE   'b111111111
`define CYAN    'b000111111
`define YELLOW  'b111111000*/

`define SCREEN_MAX_Xbits    'd5
`define SCREEN_MAX_Ybits    'd5

`define SCREEN_MAX_X        'd32 //(1 << `SCREEN_MAX_Xbits)
`define SCREEN_MAX_Y        'd32 //(1 << `SCREEN_MAX_Ybits)


module elevator(

input                                 clk,
input                                 rst_n,
input          [3:0]                  SW,

output         [7:0]                  HEX,    
output         [7:0]                  AN,
output   reg   [7:0]                  LED,
output         [`COLOR_BITS - 1 : 0 ] red,   
output         [`COLOR_BITS - 1 : 0 ] green, 
output         [`COLOR_BITS - 1 : 0 ] blue,  
output                                hsync,                        
output                                vsync                         

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

assign elev_o = elev_f_o;

hex_controller hex
(
 .clk           (clk),
 .rst_n         (rst_n),
 .elev_f_o      (elev_f_o),
 .HEX           (HEX),
 .AN            (AN)
);

vga_controller vga
    (
     .clk                 (clk),
     .rst_n               (rst_n),
     .elev_f_o            (elev_f_o),
     .red                 (red),
     .green               (green),
     .blue                (blue),
     .hsync               (hsync),
     .vsync               (vsync)
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

always @( posedge clk ) begin
    if ( !rst_n ) begin
        state <= IDLE;
        doors <= 1'b0;
        elev_f_o <= 1'b1;
    end
    else begin
        case( state )
        IDLE: begin
                if ( |SW[2:0] )
                    state <= MOVE;
                else state <= IDLE;
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
                                state <= IDLE;
                    end
                    else state <= MOVE;
              end
              else 
                    state <= IDLE; 
              end
              
        default:    begin
                            state <= IDLE;
                    end
        endcase
        end
end
endmodule
