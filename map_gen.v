`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2018 01:26:39 PM
// Design Name: 
// Module Name: map_gen
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


module map_gen(
    input clk_div,
    input clk_sys , start , jump , rst,
    input [1:0] difficulty,
    output reg [15:0] map
    //,output [15:0] led
    );
    //reg clkdiv;
    reg en, ed_start,ed_jump;
    reg [1:0] next;
    reg [9:0] preload;
    reg [2:0] size, place;
    reg [3:0] seed_seg;
    reg [1:0] seed_place;
    reg [15:0] counter, seed;
    
    initial//for test bench, set everything to 0
    begin
        en = 0;
        counter = 0;
        seed = 0;
        map = 0;
        size = 0;
        place = 0;
    end
     
    always @ (posedge clk_sys or negedge rst)
    begin
        if (rst) begin 
            counter  <= 16'd0;
        end else
            counter <= counter + 1; //counter used to make a "random" seed
        
    end
    debouncer deb_start(clk_sys,start,start_1);
    debouncer deb_jump(clk_sys,jump, jump_1);
    always @ (posedge clk_sys or negedge rst)
    begin
        if(rst)
        begin
            seed <= 0;
            en <= 0;
        end
        else if (start_1)
        begin
            if(ed_start == 0)
            begin
                seed <= counter;
                en <= ~en;
                ed_start <= 1'b1;
            end
                //seed_place <= 4'b0000;
        end
        else if (jump_1)
        begin   
            if(ed_jump == 0)        
            begin    
                seed <= counter;    
                ed_jump <= 1'b1;
            end   
        end 
        else
        begin
            ed_start <= 1'b0;
            ed_jump <= 1'b0;
        end
        
    end
    
    
    /* 
       1.we choose which segment of the seed we want to use. if we have reached the end of the seed, we make a new seed based on jump
       when enabled:
       1.if we do not have a preload , we want the seed to choose a preload
       2.the next will be the next part of the preload that needs to be output
       3.the map will shift to the left, and the next will become the lowest 2 bits of map   
            (note: on the 7 segment display, the left hand side will be the most significant bits on map, and the right side will be the least signeficent bits of map. the map will go from right to left as the clk_div continues)      
    */
    always @ (posedge clk_div)
    begin
        if(en)
        begin
            
            if(size <= place)
            begin
            case(seed_place)
                 0: seed_seg <= seed[3:0];
                 1: seed_seg <= seed[7:4];
                 2: seed_seg <= seed[11:8];
                 3: seed_seg <= seed[15:12];
                 /*4: seed_seg <= seed[19:16];
                 5: seed_seg <= seed[23:20];
                 6: seed_seg <= seed[27:24];
                 7: seed_seg <= seed[31:28];*/
                 default: seed_seg <= 15;
                 endcase                 
                 seed_place <= seed_place + 1;               
                 if(map[0] || map[2] || map[4] || map[6] || map[8] || map[10] || map[12] || map[14])
                 begin
                case(difficulty)
                    0:if(seed_seg <= 3)
                      begin
                          preload <= 16'b00;
                          size <= 1;                         
                      end
                      else if(seed_seg <= 5)
                      begin
                          preload <= 16'b0000;
                          size <= 2;
                      end
                      else if(seed_seg <= 7)
                      begin
                          preload <= 16'b000000;
                          size <= 3;
                      end
                      else
                      begin
                          preload <= 8'b00000100;
                          size <= 4;
                      end                    
                    1:if(seed_seg <= 3)
                      begin
                          preload <= 16'b00;
                          size <= 1;                         
                      end
                      else if(seed_seg <= 5)
                      begin
                          preload <= 16'b0000;
                          size <= 2;
                      end
                      else if(seed_seg <= 7)
                      begin
                          preload <= 16'b000000;
                          size <= 3;
                      end
                      else if(seed_seg <= 11)
                      begin
                            preload <= 16'b00001000;
                            size <= 4;
                      end  
                      else 
                      begin
                            preload <= 16'b00000100;
                            size <= 4;
                      end
                    2:if(seed_seg <= 2)
                      begin
                            preload <= 16'b00;
                            size <= 1;                         
                      end
                      else if(seed_seg <= 4)
                      begin
                            preload <= 16'b0000;
                            size <= 2;
                      end
                      else if(seed_seg <= 6)
                      begin
                            preload <= 16'b000000;
                            size <= 3;
                      end
                      else if(seed_seg <= 9)
                      begin
                            preload <= 16'b00001000;
                            size <= 4;
                      end  
                      else if(seed_seg <=11)
                      begin
                            preload <= 16'b0000010100;
                            size <=5;
                      end
                      else
                      begin
                            preload <= 16'b00000100;
                            size <= 4;
                      end
                    3:if(seed_seg <= 1)
                      begin
                          preload <= 16'b00;
                          size <= 1;                         
                      end
                      else if(seed_seg <= 2)
                      begin
                          preload <= 16'b0000;
                          size <= 2;
                      end
                      else if(seed_seg <= 4)
                      begin
                          preload <= 16'b000000;
                          size <= 3;
                      end
                      else if(seed_seg <= 7)
                      begin
                          preload <= 16'b00001000;
                          size <= 4;
                      end  
                      else if(seed_seg <= 10)
                      begin
                          preload <= 16'b0000010100;
                          size <=5;
                      end
                      else
                      begin
                          preload <= 16'b00000100;
                          size <= 4;
                      end
                    default: 
                    begin
                    preload <= 8'b00000100;  
                    size <= 4;
                    end                 
                endcase
                end
                else
                begin
                    preload <= 16'b00000100;
                    size <= 4;
                end
                place <= 0;
            end
            case(place)
                0:next <= preload[1:0];
                1:next <= preload[3:2];
                2:next <= preload[5:4];
                3:next <= preload[7:6];
                4:next <= preload[9:8];
                default: next <= 0;
            endcase
            place <= place + 1;
            
            map <= {map[13:12],map[11:10],map[9:8],map[7:6],map[5:4],map[3:2],map[1:0],next};
        end
        else
        begin
            map <= 0;
        end
    end//end of always
    
    
    assign led = seed[15:0]; 
    
    
endmodule




//Debouncer source: https://www.eecs.umich.edu/courses/eecs270/270lab/270_docs/debounce.html
module debouncer(
    input clk, //this is a 50MHz clock provided on FPGA pin PIN_Y2
    input PB,  //this is the input to be debounced
    output reg PB_state  //this is the debounced switch
);
/*This module debounces the pushbutton PB.
 *It can be added to your project files and called as is:
 *DO NOT EDIT THIS MODULE
 */

// Synchronize the switch input to the clock
reg PB_sync_0;
always @(posedge clk) PB_sync_0 <= PB; 
reg PB_sync_1;
always @(posedge clk) PB_sync_1 <= PB_sync_0;

// Debounce the switch
reg [15:0] PB_cnt;
always @(posedge clk)
if(PB_state==PB_sync_1)
    PB_cnt <= 0;
else
begin
    PB_cnt <= PB_cnt + 1'b1;  
    if(PB_cnt == 16'hffff) PB_state <= ~PB_state;  
end
endmodule
