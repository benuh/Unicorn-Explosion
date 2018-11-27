`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 09:26:48 AM
// Design Name: 
// Module Name: Top
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


module top(
    input jump_btn,
    input reset_btn,
    input CLK100MHZ,
    input [3:0]speed_in,
    input [3:0]difficulty_in,
    output [7:0]AN,
    output [7:0]S,
    output audio
    );
    
    
    reg jump;
    reg start;
    reg [1:0] difficulty;
    reg [1:0] speed;
    wire isdead;
    wire isjump;
    wire score_inc;
    wire [31:0]score;
    wire [15:0]map;
    
    
    reg  clk_div;
    reg [24:0]bigcounter;
    
    always@(reset_btn)
    begin
    bigcounter = 0;
    clk_div = 0;
    start = 0;
    end
    
    always@(posedge CLK100MHZ)
    begin
    bigcounter <= bigcounter + speed;
    if(jump_btn)
        begin
        jump = 1;
        start = 1;
        end
    else
        begin
        jump = 0;
        start <= start;
        end
    if(reset_btn)
        start = 0;
    
    end
    
    always@(bigcounter[20])
    clk_div = ~clk_div;
    
    always@(posedge CLK100MHZ)
    begin
    if(speed_in[3])
    speed = 6;
    else if(speed_in[2])
    speed = 5;
    else if(speed_in[1])
    speed = 4;
    else if(speed_in[0])
    speed = 3;
    else
    speed = 2;
    end
    
    always@(posedge CLK100MHZ)
    begin
    if(difficulty[3])
    difficulty = 3;
    else if(difficulty[2])
    difficulty = 2;
    else if(difficulty[1])
    difficulty = 1;
    else
    difficulty = 0;
    end
    
    
    
    audio_engine m1(CLK100MHZ, jump, isdead, audio);
    physics_engine m2(clk_div,start,map,jump,isdead,score,isjump);
    map_gen m3(clk_div,CLK100MHZ,start,isjump,difficulty,map);
    display_engine m4(jump,map,AN,S);
    score_engine m5(clk_div,score_inc,difficulty,score,start);
    
endmodule
