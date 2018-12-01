module score_engine_tb();

reg clock_div;
reg score_in;
reg difficulty;
reg start;

wire [31:0]score;

initial
begin
clock_div = 0; //Initialize the values
score_in = 0; //
difficulty = 1; //Use difficulty = 3, the easy to medium setting
start = 0; //Wait to start until later
#20
start = 1; //Start
score_in = 1;//Immediately jump a block
#1
score_in = 0; //Then 19 frames of nothing
#19
difficulty = 3; //Increase the difficulty
#20;
score_in = 1; //Jump two blocks
#2
score_in = 0; //then wait a few more frams
#2 
start = 0; //reset the score
#5
$finish; //end
end

always
begin
#1 clock_div = ~clock_div; //Use 1GHz Clock for demonstration
end

endmodule