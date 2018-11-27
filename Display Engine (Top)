`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 10:22:44 AM
// Design Name: 
// Module Name: Display_Engine
// Project Name: Display Engine
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

// Main Display Engine (Top Module)
module display_engine(jump, obstacle, AN, S);
input jump;
input [15:0] obstacle ;
output [15:0] AN;
output [15:0] S;

reg out_first;
reg [63:0] out_display;
reg [7:1]out_rest;

decoderFirst first_7seg(jump, obstacle[15:14], out_first);
decoderRest rest1_7seg(obstacle[13:12], out_rest[1]);
decoderRest rest2_7seg(obstacle[11:10], out_rest[2]);
decoderRest rest3_7seg(obstacle[9:8], out_rest[3]);
decoderRest rest4_7seg(obstacle[7:6], out_rest[4]);
decoderRest rest5_7seg(obstacle[5:4], out_rest[5]);
decoderRest rest6_7seg(obstacle[3:2], out_rest[6]);
decoderRest rest7_7seg(obstacle[1:0], out_rest[7]);


DP first_7seg_Display (.in(out_first), .out(out_display[63:56]));
DP rest1_7seg_Display (.in(out_rest[1]), .out(out_display[55:48]));
DP rest2_7seg_Display (.in(out_rest[2]), .out(out_display[47:40]));
DP rest3_7seg_Display (.in(out_rest[3]), .out(out_display[39:32]));
DP rest4_7seg_Display (.in(out_rest[4]), .out(out_display[31:24]));
DP rest5_7seg_Display (.in(out_rest[5]), .out(out_display[23:16]));
DP rest6_7seg_Display (.in(out_rest[6]), .out(out_display[15:8]));
DP rest7_7seg_Display (.in(out_rest[7]), .out(out_display[7:0]));


endmodule
