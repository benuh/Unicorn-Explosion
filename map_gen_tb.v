`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2018 03:20:04 PM
// Design Name: 
// Module Name: map_gen_tb
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
/*input clk_div,
    input clk_sys , en , jump , rst,
    input [1:0] difficulty,
    output reg [15:0] map*/

module map_gen_tb(

    );
    reg clk_sys, clk_div, en, jump, rst;
    reg [1:0] difficulty;
    wire [15:0] map;
    reg [3:0] i;
    map_gen m1(clk_div,clk_sys, en, jump, rst, difficulty, map);
    initial #220 $finish;
    
    initial
    begin
    clk_sys = 0; clk_div = 0; en = 0; jump=0; rst = 0; difficulty = 0; //0
    for(i = 0; i<10;i= i +1)
    begin
        #1 clk_sys = ~clk_sys;
    end
    #1 clk_div = 1; clk_sys = ~clk_sys; //10
    for(i = 0; i<10;i= i +1)
        begin
            #1 clk_sys = ~clk_sys;
        end
    
    #1 clk_div = 0; clk_sys = ~clk_sys; en = 1;//20
    for(i = 0; i<10;i= i +1)
        begin
            #1 clk_sys = ~clk_sys;
        end
    #1 clk_div = ~clk_div; clk_sys = ~clk_sys; en = 1; jump = 1; //30
    for(i = 0; i<10;i= i +1)
        begin
            #1 clk_sys = ~clk_sys;
        end
    #1 clk_div = ~clk_div; clk_sys = ~clk_sys; jump = 0; difficulty = 1;  //40
    for(i = 0; i<10;i= i +1)
        begin
            #1 clk_sys = ~clk_sys; clk_div = ~clk_div;
        end
    #1 clk_div = ~clk_div; clk_sys = ~clk_sys;  //50
    for(i = 0; i<10;i= i +1)
        begin
            #1 clk_sys = ~clk_sys;
        end
    #1 clk_div = ~clk_div; clk_sys = ~clk_sys;  //60
    for(i = 0; i<10;i= i +1)
        begin
            #1 clk_sys = ~clk_sys;
        end
    #1 clk_div = ~clk_div; clk_sys = ~clk_sys;   //70   
    for(i = 0; i<10;i= i +1)
        begin
            #1 clk_sys = ~clk_sys;
        end
    #1 clk_div = ~clk_div; clk_sys = ~clk_sys;jump = 1;  //80
    for(i = 0; i<10;i= i +1)
        begin
            #1 clk_sys = ~clk_sys;
        end
    #1 clk_div = ~clk_div; clk_sys = ~clk_sys; difficulty = 2;jump = 0 //90   
     for(i = 0; i<10;i= i +1)
        begin
            #1 clk_sys = ~clk_sys; clk_div = ~clk_div;
        end
    #1 clk_div = ~clk_div; clk_sys = ~clk_sys; //100
     for(i = 0; i<10;i= i +1)
       begin
           #1 clk_sys = ~clk_sys;
       end
   #1 clk_div = ~clk_div; clk_sys = ~clk_sys;  //110
     for(i = 0; i<10;i= i +1)
      begin
          #1 clk_sys = ~clk_sys;
      end
  #1 clk_div = ~clk_div; clk_sys = ~clk_sys;   //120
     for(i = 0; i<10;i= i +1)
     begin
         #1 clk_sys = ~clk_sys;
     end
 #1 clk_div = ~clk_div; clk_sys = ~clk_sys;  //130
     for(i = 0; i<10;i= i +1)
    begin
        #1 clk_sys = ~clk_sys;
    end
#1 clk_div = ~clk_div; clk_sys = ~clk_sys; jump = 1; difficulty = 3;  //140
     for(i = 0; i<10;i= i +1)
   begin
       #1 clk_sys = ~clk_sys;
   end
#1 clk_div = ~clk_div; clk_sys = ~clk_sys; jump = 0; //150
     for(i = 0; i<10;i= i +1)
   begin
       #1 clk_sys = ~clk_sys; clk_div = ~clk_div;
   end
#1 clk_div = ~clk_div; clk_sys = ~clk_sys; //160
     for(i = 0; i<10;i= i +1)
   begin
       #1 clk_sys = ~clk_sys;
   end
#1 clk_div = ~clk_div; clk_sys = ~clk_sys; //170
     for(i = 0; i<10;i= i +1)
   begin
       #1 clk_sys = ~clk_sys;
   end
#1 clk_div = ~clk_div; clk_sys = ~clk_sys; //180
     for(i = 0; i<10;i= i +1)
   begin
       #1 clk_sys = ~clk_sys;
   end
#1 clk_div = ~clk_div; clk_sys = ~clk_sys; rst = 1; // 190
     for(i = 0; i<10;i= i +1)
   begin
       #1 clk_sys = ~clk_sys; clk_div = ~clk_div;
   end
#1 clk_div = ~clk_div; clk_sys = ~clk_sys; rst = 0;//200
    end
endmodule
