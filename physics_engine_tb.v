`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2018 08:45:51 AM
// Design Name: 
// Module Name: Brain_tb
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


module physics_engine_tb(
    );
    //Declare local reg and wire identifiers
    reg clk,start,jumpin;
    reg[15:0] map;
    wire is_dead,score,jumpout;
    //instantiate the module under test
    Brain Physics(clk,start,map,jumpin,is_dead,score,jumpout);
    //Generate stimuli, using initial and always
    initial#300 $finish;
    initial clk=0;
    always 
    begin
    #20 clk=~clk;
    end
    
    initial
    begin
                 start <= 1'b0;
                 jumpin<=0;map<=16'h0140;
                 #20 map<=16'h0500;start<=1;jumpin<=1;
                 #20 map<=16'h1400;
                 #20 map<=16'h4000;
                 #20 map<=16'h0001;
                 #20 map<=16'h0014;



                       
       
    end
    

endmodule
