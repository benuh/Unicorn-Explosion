`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Team 1
// Engineer: Andrew Swanson
// 
// Create Date: 11/17/18
// Design Name: Audio Engine
// Module Name: audio_engine
// Project Name: Unicorn_explosion
// Target Devices: Nexys DDR4
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


module audio_engine(input CLK100MHZ, input jump, input isdead, output reg audio_out, output reg power);

reg audio;
reg [23:0]counter;
reg low_pitch;
reg high_pitch;
reg [3:0]mod_counter;
reg [23:0] high_counter;
reg [23:0] low_counter;

always@(CLK100MHZ) //Modifies mod_counter and audio_out
    begin
    if(mod_counter == 0)
        begin
        audio_out = 0;
        end
    else if(mod_counter == 15)
        begin
        audio_out = 1;
        end
    else
        begin
        audio_out = audio;
        end
    mod_counter = mod_counter + 1;
    end


always@(posedge CLK100MHZ) //modifies power, low_counter, low_pitch, high pitch, high counter, 
begin
power = 1;
if(isdead)
	begin
	if(counter > low_counter)
		begin
		counter <= 0;
		low_pitch <= ~low_pitch;
		low_counter <= low_counter + 8'd128;
		end
	else
		counter = counter + 1;
	end
else if(jump)
	begin
	if(counter > high_counter)
		begin
		counter <= 0;
		high_pitch <= ~high_pitch;
		high_counter <= high_counter - 8'd128;
		end
    else
        counter = counter + 1;
	end
else
	begin
	high_counter = 100000;
	low_counter = 200000;
	counter = counter + 1;
	end

end

always@(CLK100MHZ)
begin
	if(isdead)
		audio = low_pitch;
	else if(jump)
		audio = high_pitch;
	else
		audio = 1'b0;
end
endmodule