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

module display_as(
    input [15:0] map,
    input start,
    input jump,
    input dead,
    input [31:0]score,
    input CLK100MHZ,
    output reg [7:0]AN,
    output reg [7:0]S
    );
    
    reg [19:0]counter;
    reg [3:0]value;
    reg [3:0]type; //0 = number, 1 = map, 2 = letter
    reg [31:0]score_bcd;
    
    decoder c1(type, value, S);
    
    initial
    begin
    counter = 0;
    end
    
    always@(CLK100MHZ)
    begin
    counter = counter + 1;
    end
    
    always
    begin
    score_bcd[31:28] = (score % 32'b0000_0000_1001_1000_1001_0110_1000_0000) / 32'b0000_0000_0000_1111_0100_0010_0100_0000;//Millions Place
    score_bcd[27:24] = (score % 32'b0000_0000_0000_1111_0100_0010_0100_0000) / 32'b1_1000_0110_1010_0000;//
    score_bcd[23:20] = (score % 32'b1001_1000_1001_0110_1000_0000) / 32'b1111_0100_0010_0100_0000;
    score_bcd[19:16] =
    score_bcd[15:12] =
    score_bcd[11:8]  =
    score_bcd[7:4]   =
    score_bcd[3:0]   =
    end
        
    always@(counter[15])
        begin
        case(counter[18:16])
            0: AN = 8'b00000001;
            1: AN = 8'b00000010;
            2: AN = 8'b00000100;
            3: AN = 8'b00001000;
            4: AN = 8'b00010000;
            5: AN = 8'b00100000;
            6: AN = 8'b01000000;
            7: AN = 8'b10000000;
            default: AN = 8'b00000000;
        endcase
        AN = ~AN;
        end
        
        always@(counter[15])
            begin
            if(dead)
            begin
                type = 0;
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
                type = 2;
                value = counter[18:16];
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
                        if (jump && map[15:14] == 1)
                        value = 6;
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
       0 : out = 8'b11000000;
       1 : out = 8'b11111001;
       2 : out = 8'b10100100;
       3 : out = 8'b10110000;
       4 : out = 8'b10011001;
       5 : out = 8'b10010010;
       6 : out = 8'b10000010;
       7 : out = 8'b11111000;
       8 : out = 8'b10000000;
       9 : out = 8'b10010000;
       10: out = 8'b10001000;
       11: out = 8'b10000011;
       12: out = 8'b11000110;
       13: out = 8'b10100001;
       14: out = 8'b10000110;
       15: out = 8'b10001110;
       default: out= 8'b01111111;
    endcase
    end
1:
begin
case(value)
    0: out = 8'b1111_1111;
    1: out = 8'b1010_0011;
    2: out = 8'b1001_1100;
    3: out = 8'b0111_1111;
    4: out = 8'b1111_0011;
    5: out = 8'b1011_1101;
    6: out = 8'b1010_0001;
    default: out= 8'b01111111;
endcase
end
2:
begin
end


endcase
end

endmodule
