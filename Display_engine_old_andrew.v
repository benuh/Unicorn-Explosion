`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Unicorn Explosion
// Engineer: Andrew Swanson
//
// Create Date: 09/25/2018 01:35:29 PM
// Design Name:
// Module Name: Display AS
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

module display_engine_as(
    input [15:0] map,
    input start,
    input jump,
    input dead,
    input [31:0]score,
    input CLK100MHZ,
    input clk_div,
    output reg [7:0]Anodes,
    output [7:0]Cathodes
    );
    
    reg [23:0]counter;
    reg [3:0]value;
    reg [3:0]type; //0 = number, 1 = map, 2 = letter
    wire [31:0]score_bcd;
    reg [3:0]offset;
    
    decoder c1(type, value, Cathodes);
    
    initial
    begin
    counter = 0;
    end
    
    always@(posedge CLK100MHZ)
    begin
    counter = counter + 1;
    end
    
    always@(posedge clk_div)
    offset = offset -1;
    /*
    always@(score)
    begin
    score_bcd[31:28] = (score % 32'd100_000_000)/32'd10_000_000;    //10^7
    score_bcd[27:24] = (score % 32'd10_000_000)/32'd1_000_000;      //10^6
    score_bcd[23:20] = (score % 32'd1_000_000)/32'd100_000;         //10^5
    score_bcd[19:16] = (score % 32'd100_000)/32'd10_000;            //10^4
    score_bcd[15:12] = (score % 32'd10_000)/32'd1_000;              //10^3
    score_bcd[11:8]  = (score % 32'd1_000)/32'd100;                 //10^2
    score_bcd[7:4]   = (score % 32'd100)/32'd10;                    //10^1
    score_bcd[3:0]   = (score % 32'd10)/32'd1;                      //10^0
    end
    */
    
    assign score_bcd = score;
     
    always@(counter[15]) // The Anode Cycling Block
        begin
        case(counter[18:16])
            0: Anodes = 8'b00000001;
            1: Anodes = 8'b00000010;
            2: Anodes = 8'b00000100;
            3: Anodes = 8'b00001000;
            4: Anodes = 8'b00010000;
            5: Anodes = 8'b00100000;
            6: Anodes = 8'b01000000;
            7: Anodes = 8'b10000000;
            default: Anodes = 8'b00111000;
        endcase
        Anodes = ~Anodes;
        end
        
        always@(CLK100MHZ) //The value generation block
            begin
            if(dead)
            begin
                type = 0; //Show numbers
                case(counter[18:16])
                0: value = score_bcd[3:0];
                1: value = score_bcd[7:4];
                2: value = score_bcd[11:8];
                3: value = score_bcd[15:12];
                4: value = score_bcd[19:16];
                5: value = score_bcd[23:20];
                6: value = score_bcd[27:24];
                7: value = score_bcd[31:28];
                default: value = 4'hx;
                endcase
            end
            else if(~start)
                begin
                type <= 2; //Show Letters
                value <= ((counter[18:16] + offset) % 16);
                end
            else
                begin
                type = 1;
                case(counter[18:16])
                0: value = map[1:0];
                1: value = map[3:2];
                2: value = map[5:4];
                3: value = map[7:6];
                4: value = map[9:8];
                5: value = map[11:10];
                6: value = map[13:12];
                7:
                    begin
                        if (jump && (map[15:14] == 1))
                        value = 6;
                    else if(~jump && (map[15:14] ==2))
                        value = 7;
                    else if(jump)
                        value = 5;
                    else
                        value = 4;
                    end
            endcase
            end
            end
endmodule

module decoder(input [3:0] type,input[3:0]value, output reg [7:0] out);
always@(type, value)
begin
case (type)
0:
    begin
    case(value)
       0 : out = 8'b1100_0000;
       1 : out = 8'b1111_1001;
       2 : out = 8'b1010_0100;
       3 : out = 8'b1011_0000;
       4 : out = 8'b1001_1001;
       5 : out = 8'b1001_0010;
       6 : out = 8'b1000_0010;
       7 : out = 8'b1111_1000;
       8 : out = 8'b1000_0000;
       9 : out = 8'b1001_0000;
       10: out = 8'b1000_1000;
       11: out = 8'b1000_0011;
       12: out = 8'b1100_0110;
       13: out = 8'b1010_0001;
       14: out = 8'b1000_0110;
       15: out = 8'b1000_1110;
       default: out= 8'b1111_1111;
    endcase
    end
1:
    begin
    case(value)
        0: out = 8'b1111_1111;
        1: out = 8'b1010_0011;
        2: out = 8'b1001_1100;
        3: out = 8'b0111_1111;
        4: out = 8'b1111_0011; //Unicorn on Ground
        5: out = 8'b1011_1101; //Unicorn in Air
        6: out = 8'b1010_0001; //Unicorn jumping over block
        7: out = 8'b1001_0000; //Unicorn slipping under block
        default: out= 8'b11111111;
    endcase
    end
2:
begin
case(value)
15:
out = 8'b1000_1100; //P
14:
out = 8'b1010_1111; //r
13:
out = 8'b1000_0110; //E
12:
out = 8'b1001_0010; //S
11:
out = 8'b1001_0010; //S
10:
out = 8'b1111_1111; //
9:
out = 8'b1111_1111; //
8:
out = 8'b1001_0010; //S
7:
out = 8'b1000_0111; //t
6:
out = 8'b1000_1000; //A
5:
out = 8'b1010_1111; //r
4:
out = 8'b1000_0111; //t
3:
out = 8'b1111_1111; //_
2:
out = 8'b1111_1111; //_
1:
out = 8'b1111_1111; //_
15:
out = 8'b1111_1111; //_
default
out = 8'b1111_1111; //_
endcase
end
endcase
end

endmodule
