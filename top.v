`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Andrew Swanson
// 
// Create Date: 11/27/2018 09:26:48 AM
// Design Name: 
// Module Name: Top
// Project Name: Unicorn Explosion
// Target Devices: Nexsys 4 DDR
// Tool Versions: 
// Description: The wrapper for all of the created modules
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input jump_btn, //The game is generally set up as a one-button only game, so the center button is responsible for jumping and for starting the game
    input reset_btn, //The reset switch, which restarts the game
    input CLK100MHZ, //The reference clock, which is used directly for some modules, and divided for use by others
    input [3:0]speed_in, //The game's speed input, which increases the rate of the advancing blocks
    input [3:0]difficulty_in, //The game's difficulty, which causes a more difficult map to be generated, and multiplies the score
    output [7:0]Anodes, //The output to the 8 anodes of the 7 segment displays
    output [7:0]Cathodes, //The output to the 8 shared cathodes of the 7 segment displays
    output audio //The output to the board's audio amplifier
    );
    
    
    reg jump; //The debounced version of the jump 
    reg start; //The register that tracks the start and stop
    reg [1:0] difficulty; //The current difficulty
    reg [3:0] speed; //The current speed
    wire isdead; //The variable to determine if the player is dead
    wire isjump; //The output of the physics engine's jump calculation
    wire score_inc; //The passthru from the physics engine's "jump successful" output to the score input
    wire [31:0]score; //The current score
    wire [15:0]map; //The 8 visible tiles on the screen
    reg  clk_div; //The game's master clock
    reg [32:0]bigcounter; //The clock divider output, used to create the game's clock
    
    initial
    begin
    bigcounter = 0;
    clk_div = 0;
    jump = 0;
    start = 0;
    end
    
    always@(posedge CLK100MHZ) 
    begin
    if(reset_btn)
        begin
        start = 0;
        bigcounter = 0;
        jump = 0;
        end
    else if(jump_btn)
        begin
        jump = 1;
        start = 1;
        bigcounter = bigcounter + speed;
        end
    else
        begin
        jump = 0;
        start = start;
        bigcounter = bigcounter + speed;
        end
    end
    
    always@(posedge bigcounter[25]) //The clock is 2^27 times slower than 100MHZ, with a base speed of 0.75 tiles per second. However, this is never used directly, and is always multipled by at least 2 
    clk_div = ~clk_div;
    
    always@(posedge CLK100MHZ) //The speed is set up as a priority encoder, to make the interface more usable
    begin
    if(speed_in[3])
    speed = 9;
    else if(speed_in[2])
    speed = 7;
    else if(speed_in[1])
    speed = 6;
    else if(speed_in[0])
    speed = 4;
    else
    speed = 3;
    end
    
    always@(posedge CLK100MHZ)//As is the difficulty
    begin
    if(difficulty_in[3])
    difficulty = 3;
    else if(difficulty_in[2])
    difficulty = 2;
    else if(difficulty_in[1])
    difficulty = 1;
    else
    difficulty = 0;
    end
    //Here, the various modules are instantiated
    audio_engine m1(CLK100MHZ, isjump, isdead, audio,0); //By Andrew Swanson
    
    physics_engine m2(clk_div,start,map,jump,isdead,score_inc,isjump); //By Benjamin Hu
    
    map_gen m3(clk_div,CLK100MHZ,start, jump_btn,reset_btn,difficulty,map); //By Macade Walker
    
    display_engine_as m4(map,start,isjump,isdead,score,CLK100MHZ,clk_div,Anodes,Cathodes); //by Burhan Al-Esteswani and Yashika Malik
    
    score_engine m5(clk_div,score_inc,difficulty,score,start,isdead); //By Andrew Swanson
    
endmodule
