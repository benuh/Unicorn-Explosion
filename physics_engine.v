`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Spamson
// Credited Author: Ben Hu
// Actual Author: Andrew "Pretending to be Ben" Swanson
// 
// Create Date: 11/20/2018 09:50:44 AM
// Design Name: 
// Module Name: physics_engine
// Project Name: Unicorn Explosion
// Target Devices: Nexys 4 DDR
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


module physics_engine(
    input speed,
    input [15:0] map_tiles, //MSBs are player position
    input jump,
    output is_dead,
    output score);
    
    always@(posedge speed)
    case(map_tiles[15:14])
    0: //No block, no worries
    begin
    score = 0;
    end
    1: //Low block -- If you don't jump, you're dead
    begin
    if(~jump)
    is_dead = 1;
    else
    score=1;
    end
    2: //High block -- If you jump, you're dead
    begin
    if(jump)
    is_dead = 1;
    end
    3: //Unimplemented
    begin
    score = 0;
    end
endmodule
