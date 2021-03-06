
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Unicorn Explosion
// Engineer: Benjamin(Changcan) Hu
// 
// Create Date: 11/25/2018 02:57:30 PM
// Design Name: Benjamin(Changcan) Hu
// Module Name: Brain
// Project Name: Uniorn Explosion
// Target Devices: NEXYS4-DDR
// Tool Versions: Artix-XC7A100T-CSG324
// Description: FPGA
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module physics_engine(
input clk,
input start,
input [15:0] map,
input jumpin,
output reg is_dead,
output reg score,
output reg jumpout
);
reg [1:0] position;
reg [1:0]Q;

always@(posedge clk)
begin
 if(~start)
 begin
    is_dead = 0;
 end
 else
 begin
    case(position)
    0:
        begin
            if(jumpin==1)
            begin
                position<=2'b10;
            end
            else 
            begin
                position<=2'b00;
            end
        end
    1:
        begin
            position<=2'b00;
        end
    2:
        begin
            position<=2'b01;
        end
    3:
        begin
        position=2'b01;
        end
    endcase
    
    case(map[15:14])
    0: //No block
        begin
            score=0;
        end
    1: //Low block
        if(position > 2'b00)
            begin
                score = 1;
            end
        else
        begin
            is_dead=1;
        end
    2: //High block
        if(position==0)
        begin        
            score = 1;
        end
        else
        begin
            is_dead=1;
        end  
    3: //Don't exist
        begin
            score = score;
        end
    endcase
    end
end

always@(position)
begin
if(position == 0)
jumpout = 0;
else
jumpout = 1;
end

endmodule