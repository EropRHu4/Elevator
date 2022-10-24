`timescale 1ns / 1ps                                                                 
//////////////////////////////////////////////////////////////////////////////////   
// Company:                                                                          
// Engineer:                                                                         
//                                                                                   
// Create Date: 04.10.2022 17:19:37                                                  
// Design Name:                                                                      
// Module Name: vga_controller                                                       
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
`define RED               'b111100000000                                             
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
                                                                                     
module vga_controller(                                                               
  input clk,                                                                         
  input rst_n,                                                                       
  input [2:0] elev_f_o,                                                              
  output reg [`COLOR_BITS - 1 : 0 ] red,                                             
  output reg [`COLOR_BITS - 1 : 0 ] green,                                           
  output reg [`COLOR_BITS - 1 : 0 ] blue,                                            
  output reg hsync,                                                                  
  output reg vsync                                                                   
);                                                                                   
                                                                                     
reg [9:0] hcount = 0;                                                                
reg [9:0] vcount = 0;                                                                
reg [1:0] counter = 0;                                                               
reg enable;                                                                          
                                                                                     
reg [9:0] count = 0;                                                                 
reg [6:0] param = 0;                                                                 
//reg [2:0] elev_f_o = 0;                                                            
                                                                                     
function rgb_out2;                                                                   
    input [(`COLOR_BITS*3 -1):0] rgb; //TODO !8                                      
    begin                                                                            
                                                                                     
    red   = (rgb >> 6) & 'h7;  //TODO                                                
    green = (rgb >> 3) & 'h7;                                                        
    blue  = (rgb >> 0) & 'h7;                                                        
end                                                                                  
endfunction                                                                          
                                                                                     
always @ (posedge clk)                                                               
begin                                                                                
  if (counter == 3) //What is it?                                                    
  begin                                                                              
    counter <= 1'b0;                                                                 
    enable <= 1'b1;                                                                  
  end                                                                                
  else                                                                               
  begin                                                                              
    counter <= counter + 1'b1;                                                       
    enable <= 1'b0;                                                                  
  end                                                                                
end                                                                                  
                                                                                     
// Название этого действа ?                                                          
always @(posedge clk)                                                                
begin                                                                                
  if (enable == 1)                                                                   
  begin                                                                              
    if(hcount == 799) //What is it?                                                  
    begin                                                                            
      hcount <= 0;                                                                   
      if(vcount == 524) //What is it?                                                
        vcount <= 0;                                                                 
      else                                                                           
        vcount <= vcount+1'b1;                                                       
    end                                                                              
    else                                                                             
      hcount <= hcount+1'b1;                                                         
                                                                                     
                                                                                     
  if (vcount >= 490 && vcount < 492)                                                 
    vsync <= 1'b0;                                                                   
  else                                                                               
    vsync <= 1'b1;                                                                   
                                                                                     
  if (hcount >= 676 && hcount < 752)                                                 
    hsync <= 1'b0;                                                                   
  else                                                                               
    hsync <= 1'b1;                                                                   
  end                                                                                
end                                                                                  
                                                                                     
always @(posedge clk) begin                                                          
if (!rst_n) begin                                                                    
    Rectangular(`WHITE,'d4,'d6,'d27,'d29);                                           
    Rectangular(`WHITE,'d8,'d10,'d27,'d29);                                          
    Rectangular(`WHITE,'d12,'d14,'d27,'d29);                                         
    Rectangular(`WHITE,'d16,'d18,'d27,'d29);                                         
    Rectangular(`WHITE,'d20,'d22,'d27,'d29);                                         
    Rectangular(`WHITE,'d24,'d26,'d27,'d29);                                         
    Rectangular(`WHITE,'d28,'d30,'d27,'d29);                                         
    Rectangular(`WHITE,'d4,'d28,'d2,'d21); // clear display                          
    for (x = 5; x < 19; x = x+1) begin                                               
            Output_RGB(16,x , `RED);                                                 
    end                                                                              
    Output_RGB(15,5 , `RED);                                                         
end                                                                                  
else begin                                                                           
        ClearVideo(`BLUE); // background                                             
        Rectangular(`WHITE,'d4,'d28,'d2,'d21); // disp                               
//////////////////// LEDS //////////////////////////////                             
    if (elev_f_o == 'b001)                                                           
        Rectangular(`RED,'d4,'d6,'d27,'d29);                                         
    else Rectangular(`WHITE,'d4,'d6,'d27,'d29);                                      
    if (elev_f_o == 'b010)                                                           
        Rectangular(`RED,'d8,'d10,'d27,'d29);                                        
    else Rectangular(`WHITE,'d8,'d10,'d27,'d29);                                     
    if (elev_f_o == 'b011)                                                           
        Rectangular(`RED,'d12,'d14,'d27,'d29);                                       
    else Rectangular(`WHITE,'d12,'d14,'d27,'d29);                                    
    if (elev_f_o == 'b100)                                                           
        Rectangular(`RED,'d16,'d18,'d27,'d29);                                       
    else Rectangular(`WHITE,'d16,'d18,'d27,'d29);                                    
    if (elev_f_o == 'b101)                                                           
        Rectangular(`RED,'d20,'d22,'d27,'d29);                                       
    else Rectangular(`WHITE,'d20,'d22,'d27,'d29);                                    
    if (elev_f_o == 'b110)                                                           
        Rectangular(`RED,'d24,'d26,'d27,'d29);                                       
    else Rectangular(`WHITE,'d24,'d26,'d27,'d29);                                    
    if (elev_f_o == 'b111)                                                           
        Rectangular(`RED,'d28,'d30,'d27,'d29);                                       
    else Rectangular(`WHITE,'d28,'d30,'d27,'d29);                                    
                                                                                     
    case(elev_f_o)                                                                   
    //////////////////// 1 /////////////////////////////////                         
    'b001: begin                                                                     
        for (x = 5; x < 19; x = x+1) begin                                           
            Output_RGB(16,x , `RED);                                                 
        end                                                                          
        Output_RGB(15,5 , `RED);                                                     
     end                                                                             
    //////////////////// 2 /////////////////////////////////                         
    'b010: begin                                                                     
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,19 , `RED);                                                 
        end                                                                          
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,13 , `RED);                                                 
        end                                                                          
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,5 , `RED);                                                  
        end                                                                          
        for (x = 14; x < 19; x = x+1) begin                                          
            Output_RGB(12,x , `RED);                                                 
        end                                                                          
        for (x = 6; x < 13; x = x+1) begin                                           
            Output_RGB(17,x , `RED);                                                 
        end                                                                          
    end                                                                              
    //////////////////// 3 /////////////////////////////////                         
    'b011: begin                                                                     
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,19 , `RED);                                                 
        end                                                                          
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,13 , `RED);                                                 
        end                                                                          
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,5 , `RED);                                                  
        end                                                                          
        for (x = 14; x < 19; x = x+1) begin                                          
            Output_RGB(17,x , `RED);                                                 
        end                                                                          
        for (x = 6; x < 13; x = x+1) begin                                           
            Output_RGB(17,x , `RED);                                                 
        end                                                                          
    end                                                                              
    //////////////////// 4 /////////////////////////////////                         
    'b100: begin                                                                     
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,13 , `RED);                                                 
        end                                                                          
        for (x = 14; x < 19; x = x+1) begin                                          
            Output_RGB(17,x , `RED);                                                 
        end                                                                          
        for (x = 6; x < 13; x = x+1) begin                                           
            Output_RGB(17,x , `RED);                                                 
        end                                                                          
        for (x = 6; x < 13; x = x+1) begin                                           
            Output_RGB(12,x , `RED);                                                 
        end                                                                          
     end                                                                             
    //////////////////// 5 /////////////////////////////////                         
    'b101: begin                                                                     
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,19 , `RED);                                                 
        end                                                                          
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,13 , `RED);                                                 
        end                                                                          
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,5 , `RED);                                                  
        end                                                                          
        for (x = 14; x < 19; x = x+1) begin                                          
            Output_RGB(17,x , `RED);                                                 
        end                                                                          
        for (x = 6; x < 13; x = x+1) begin                                           
            Output_RGB(12,x , `RED);                                                 
        end                                                                          
    end                                                                              
    //////////////////// 6 /////////////////////////////////                         
    'b110: begin                                                                     
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,19 , `RED);                                                 
        end                                                                          
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,13 , `RED);                                                 
        end                                                                          
        for (x = 12; x < 18; x = x+1) begin                                          
            Output_RGB(x,5 , `RED);                                                  
        end                                                                          
        for (x = 14; x < 19; x = x+1) begin                                          
            Output_RGB(12,x , `RED);                                                 
        end                                                                          
        for (x = 14; x < 19; x = x+1) begin                                          
            Output_RGB(17,x , `RED);                                                 
        end                                                                          
        for (x = 6; x < 13; x = x+1) begin                                           
            Output_RGB(12,x , `RED);                                                 
        end                                                                          
     end                                                                             
    //////////////////// 7 /////////////////////////////////                         
    'b111: begin                                                                     
        for (x = 5; x < 19; x = x+1) begin                                           
            Output_RGB(16,x , `RED);                                                 
        end                                                                          
        for (x = 12; x < 17; x = x+1) begin                                          
            Output_RGB(x,5 , `RED);                                                  
        end                                                                          
    end                                                                              
    default:                                                                         
    begin                                                                            
        for (x = 5; x < 19; x = x+1) begin                                           
            Output_RGB(16,x , `RED);                                                 
        end                                                                          
        Output_RGB(15,5 , `RED);                                                     
     end                                                                             
                                                                                     
    //////////////////// 8 /////////////////////////////////                         
    /*for (x = 12; x < 18; x = x+1) begin                                            
           Output_RGB(x,19 , `RED);                                                  
    end                                                                              
    for (x = 12; x < 18; x = x+1) begin                                              
           Output_RGB(x,13 , `RED);                                                  
    end                                                                              
    for (x = 12; x < 18; x = x+1) begin                                              
           Output_RGB(x,5 , `RED);                                                   
    end                                                                              
    for (x = 14; x < 19; x = x+1) begin                                              
           Output_RGB(12,x , `RED);                                                  
    end                                                                              
    for (x = 14; x < 19; x = x+1) begin                                              
           Output_RGB(17,x , `RED);                                                  
    end                                                                              
    for (x = 6; x < 13; x = x+1) begin                                               
           Output_RGB(12,x , `RED);                                                  
    end                                                                              
    for (x = 6; x < 13; x = x+1) begin                                               
           Output_RGB(17,x , `RED);                                                  
    end*/                                                                            
    //////////////////// 9 /////////////////////////////////                         
    /*for (x = 12; x < 18; x = x+1) begin                                            
           Output_RGB(x,19 , `RED);                                                  
    end                                                                              
    for (x = 12; x < 18; x = x+1) begin                                              
           Output_RGB(x,13 , `RED);                                                  
    end                                                                              
    for (x = 12; x < 18; x = x+1) begin                                              
           Output_RGB(x,5 , `RED);                                                   
    end                                                                              
    for (x = 14; x < 19; x = x+1) begin                                              
           Output_RGB(17,x , `RED);                                                  
    end                                                                              
    for (x = 6; x < 13; x = x+1) begin                                               
           Output_RGB(12,x , `RED);                                                  
    end                                                                              
    for (x = 6; x < 13; x = x+1) begin                                               
           Output_RGB(17,x , `RED);                                                  
    end*/                                                                            
    endcase                                                                          
end                                                                                  
end                                                                                  
reg [`COLOR_BITS*3-1:0] VideoMem[0:(`SCREEN_MAX_X-1)][0:(`SCREEN_MAX_Y-1)];          
// reg CharSet[0:9][0:8][0:8];                                                       
                                                                                     
function Output_RGB;                                                                 
input [(`SCREEN_MAX_Xbits-1):0] x;                                                   
input [(`SCREEN_MAX_Ybits-1):0] y;                                                   
input [`COLOR_BITS*3-1:0] rgb;                                                       
begin                                                                                
   VideoMem[x][y]= rgb;                                                              
end                                                                                  
endfunction                                                                          
                                                                                     
integer x;                                                                           
integer y;                                                                           
                                                                                     
function ClearVideo;                                                                 
input [`COLOR_BITS*3-1:0] color;                                                     
begin                                                                                
for (x = 0; x < `SCREEN_MAX_X; x=x+1) begin                                          
    for (y = 0; y < `SCREEN_MAX_Y; y=y+1) begin                                      
        VideoMem[x][y] = color;                                                      
    end                                                                              
end                                                                                  
end                                                                                  
endfunction                                                                          
                                                                                     
                                                                                     
function Rectangular;                                                                
input [`COLOR_BITS*3-1:0] color;                                                     
input [4:0] x_start;                                                                 
input [4:0] x_end;                                                                   
input [4:0] y_start;                                                                 
input [4:0] y_end;                                                                   
begin                                                                                
for (x = x_start; x < x_end; x=x+1) begin                                            
    for (y = y_start; y < y_end; y=y+1) begin                                        
        VideoMem[x][y] = color;                                                      
    end                                                                              
end                                                                                  
end                                                                                  
endfunction                                                                          
                                                                                     
                                                                                     
integer x_h;                                                                         
integer y_v;                                                                         
                                                                                     
always @ (posedge clk)                                                               
begin                                                                                
if (hcount < 480 && vcount < 480) begin                                              
   x_h = hcount;                                                                     
   y_v = vcount;                                                                     
   x_h = x_h / (480 / `SCREEN_MAX_X ); // 8x8 800 max                                
   y_v = y_v / (480 / `SCREEN_MAX_Y );                                               
  if (enable)                                                                        
  begin                                                                              
            red   <= (VideoMem[x_h][y_v] >> 8) & 'hF;  //TODO                        
            green <= (VideoMem[x_h][y_v] >> 4) & 'hF;                                
            blue  <= (VideoMem[x_h][y_v] >> 0) & 'hF;                                
  end                                                                                
end                                                                                  
else  begin                                                                          
            red   <= 0;  //TODO                                                      
            green <= 0;                                                              
            blue  <= 0;                                                              
                                                                                     
end                                                                                  
end                                                                                  
endmodule                                                                            
