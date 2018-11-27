`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2018 01:26:39 PM
// Design Name: 
// Module Name: Map_Gen
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


module Map_Gen(
    input clk_div,
    input clk_sys , start , jump , 
    input [1:0] difficulty,
    output reg [15:0] map
    ,output [15:0] led
    );
    //reg clkdiv;
    reg en;
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
     
    always @ (posedge clk_sys)
    begin
        counter <= counter + 1; //counter used to make a "random" seed
    end
    debouncer deb_start(clk_sys,start,start_1);
    debouncer deb_jump(clk_sys,jump, jump_1);
    always @ (posedge start_1,posedge jump_1)
    begin
        if (jump_1)
        begin               
        seed <= counter;    
        seed_place <= 0;   
        end
        else if (start_1)
        begin
        seed <= counter;
        en <= ~en;
        //seed_place <= 4'b0000;
        end
    end
    
    always @ (map)
    begin
        if(map == 16'd0)
        begin
            
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
    end
    
    
    
    assign led = seed[15:0]; 
    
    
endmodule
