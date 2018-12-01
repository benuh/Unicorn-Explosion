`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 10:33:04 AM
// Design Name: 
// Module Name: score_engine
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

//The module that tracks the player's current score.
//The player is awarded one point for every space they travel, and ten point for each block they successfully jump over
module score_engine(
    input clock_div,
    input score_in, //score_in is sent from the collision detection when the player jumps over a block
    input [1:0]difficulty, //To add appeal to playing on higher difficulty levels, the score is multiplied by the difficulty. /
    output reg [31:0]score,
    input start,
    input isdead
    );
    
    always@(posedge clock_div)    
    begin
    if(~isdead)
    begin
    if(~start)
        score = 0; //The score resets to zero on reset
    if(score_in) //The difficulty must be added by one because it starts at zero, and multiplying the score by zero would not add extra fun :P
        score = score + ((difficulty + 1)*10);
    else
        score = score + ((difficulty + 1)*1);
    end
    end
    
endmodule
