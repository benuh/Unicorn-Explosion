`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

// Company: Spamson

// Engineer: Andrew Swanson

// 

// Create Date: 11/18/2018 12:32:54 AM
// Design Name: 
// Module Name: audio_engine_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// // Dependencies: 
// // Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module audio_engine_tb();

reg is_dead;
reg jump;
reg CLK100MHZ;
wire audio;

audio_engine MUT(CLK100MHZ, jump,is_dead,audio,1);

always
#1 CLK100MHZ = ~CLK100MHZ;

initial
    begin
    CLK100MHZ = 0; //Intialize the clock,
    jump = 0; //Jump
    isdead = 0  //and lost settings
    #100
    jump = 1; //Jump at 100ns
    #200
    isdead = 1;//Die at 300ns
    end

endmodule
