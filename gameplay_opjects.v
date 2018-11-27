`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2018 06:44:16 PM
// Design Name: 
// Module Name: DP
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

// GamePlay Objects
module DP(in, out, CLK); 
    input in; // Input for shape desired from Decoder
    input CLK;
    output reg out; // Shapes displayed at each 7-seg
    always@(posedge CLK)
    begin
    case(in)
        0 : out = 8'b11110011; //Unicorn Down
        1 : out = 8'b10100011; //Lower Box
        2 : out = 8'b10011100; //Upper Box
        3 : out = 8'b10111101; //Unicorn Up
        4 : out = 8'b10000011; //Jump Lower Box
        5 : out = 8'b10001100; //Under Upper Box
        6 : out = 8'b11111111; //Empty
        7 : out = 8'b10001001; //Dead
    default: out= 8'b11111111; //Empty
    endcase
    end
endmodule


//Score Keeper Display
module score(in, out, CLK);
    input in, CLK;
    output reg out;
    always@(in) 
    begin
    case(in)
        0 : out = 8'b11000000;
        1 : out = 8'b11111001;
        2 : out = 8'b10100100;
        3 : out = 8'b10110000;
        4 : out = 8'b10011001;
        5 : out = 8'b10010010;
        6 : out = 8'b10000010;
        7 : out = 8'b11111000;
        8 : out = 8'b10000000;
        9 : out = 8'b10010000;
    default: out= 8'b01111111;
    endcase
    end
endmodule


// Rest 7-Seg Displays
module desocderRest(obstacle, out);
    input [1:0]obstacle; //Input from Physics Engine for rest 7-seg
    output reg [2:0] out; //Indicator of the rest 7-seg shape

    always@(obstacle)
    begin
    if(obstacle[1]) //obstacle[1] shows status if obstacle Down exists
        out = 3'b001; //Obstacle Down
    else if(obstacle[0]) //obstacle[0] shows status if obstacle Up exists
        out = 3'b010; //Obstacle Up
    else
        out = 3'b110; //Empty
    end
endmodule


// First 7-Seg Display
module decoderFirst (jump, obstacle, out, CLK);
    input jump;
    input [1:0]obstacle; //Input from Physics Engine for first 7-seg
    input CLK;
    output reg [2:0] out; //Indicator of the first 7-seg shape
    
    always@(posedge CLK)
    begin
    if(jump==0 & obstacle[0]==0 & obstacle[1]==0)
        out = 3'b000; //Unicorn Down
    else if (jump==1 & obstacle[0]==0 & obstacle[1]==0)
        out = 3'b011; //Unicorn Up
    else if(jump==0 & obstacle[0]==1 & obstacle[1]==0)
        out = 3'b101; //ObstacleUp w/ Unicorn Down
    else if(jump==1 & obstacle[0]==0 & obstacle[1]==1)
        out = 3'b100; //ObstacleDown w/ Unicorn Up
    else
        out = 3'b111; //Dead
    end
endmodule
