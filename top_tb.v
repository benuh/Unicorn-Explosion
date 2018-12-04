`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2018 07:14:33 PM
// Design Name: Benjamin(Changcan) Hu
// Module Name: Top_tb
// Project Name: Unicorn Explosion
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


module top_tb();
//Declare lcoal reg and wire identifiers
reg jum_btn,reset_btn,CLK100MHZ;
reg [3:0]speed_in,difficulty_in;
wire [7:0]Anodes,Cathodes;
wire auido;
//instantiate the moduel under test
top top_test(jum_btn,reset_btn,CLK100MHZ,speed_in,difficulty_in,Anodes,Cathodes,audio);
//initial and always stimulation
initial #100 $finish;
initial CLK100MHZ=0;

always
begin 
#20 CLK100MHZ =~ CLK100MHZ;
end

initial 
begin
        jum_btn=0;reset_btn=1;speed_in=2'b1000;difficulty_in=2'b0001;
        #20 reset_btn=0;
        #60 jum_btn=1;
        #20 jum_btn=1; 
        #20 jum_btn=1; 
        #20 jum_btn=1; 
        #20 jum_btn=1;                               
end

endmodule
