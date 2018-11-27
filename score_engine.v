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


module score_engine(
    input clock_div,
    input score_in,
    input difficulty,
    output reg [31:0]score,
    input start
    );
    
    always@(posedge clock_div, posedge reset)    
    begin
    if(~start)
        score = 0;
    if(score_in)
        score = score + ((difficulty + 1)*10);
    else
        score = score + ((difficulty + 1)*1);
    end
    
endmodule
