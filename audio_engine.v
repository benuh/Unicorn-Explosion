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

reg audio; //The internal audio waveform

//All three counters are compared to each other to generate the waveforms
	reg [23:0]counter; 		//the general counter
	reg [23:0] high_counter;	//the counter that resets to the default high pitch, and then decreases
	reg [23:0] low_counter; 	//the counter that resets to the default low pitch, and then increases
	reg low_pitch;			//the current position of the low_pitch audio
	reg high_pitch;			//the current position of the high_pitch audio
	reg [3:0]mod_counter;		//the counter uses for the PWM driver

	always@(CLK100MHZ) //To better interface with the onboard PWM driver, 
		           //the output signal is modulated through with a consistient clock pul
    begin
	    if(mod_counter == 0)//At the start of each cycle, the audio stream is brought down to zero
        begin
        audio_out = 0;
        end
	    else if(mod_counter == 15)//At the end of each cycle, the audio stream is brought up to high
        begin
        audio_out = 1;
        end
    else
        begin
        audio_out = audio; //In the middle of the cycle, the audio signal passes straight through 
        end
    mod_counter = mod_counter + 1;
    end


	always@(posedge CLK100MHZ) //The primary block of the audio generator, which compares the various counters to produce the output tones
begin
power = 1;
	if(isdead) //When the player looses, a falling tone is played
	begin
	if(counter > low_counter)
		begin
		low_pitch <= ~low_pitch;//Whenever the counter resets, the square wave is flipped
		low_counter <= low_counter + 8'd128; //This line increases the period of the low_counter, decreasing the pitch
		counter <= 0; //And then resets the counter
		end
	else
		counter = counter + 1;//Otherwise, just increment the counter
	end
	else if(jump)//If the player jumps, a rising tone is played
	begin
	if(counter > high_counter)
		begin
		high_pitch <= ~high_pitch; //Every time the counter reaches its target, the audio stream is flipped
		high_counter <= high_counter - 8'd128; //and the target of the counter decreases, increasing the pitch
		counter <= 0; //and reset the counter
		end
    else
        counter = counter + 1;
	end
else
	begin
	high_counter = 100000; //If nothing is happening, reset both pitches
	low_counter = 200000;
	counter = counter + 1; //And increment the counter
	end

end

	always@(CLK100MHZ) //The patch panel block
begin
	if(isdead) //Assigns the correct audio stream in each case
		audio = low_pitch;
	else if(jump)
		audio = high_pitch;
	else
		audio = 1'b0;
end
endmodule
