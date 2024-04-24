`timescale 1ns / 1ps
module UART_TX #(parameter clkdiv=50000000/115200 -1)(
    input clk,
    input rst,
    input [7:0] din,
    input enable,
    output reg done,
    output reg tx_serial
);                                                                         
    reg [15:0] divcntr;
    reg [9:0] data;
    reg [1:0] State;
    reg [3:0]Counter;
    
    always@(posedge clk) begin
        if(rst) begin
        State <=2'b00;
        done<=1'b0;
        tx_serial<=1'b1;
    end
        else begin
            case(State) 
                2'b00: begin
                    tx_serial<=1'b1;
                    done <= 1'b0;
                    if(enable) begin
                        State <= 2'b01;
                        divcntr<=0;
                        Counter <=0;
                        data <= {1'b1,din,1'b0};    
                    end
                 end                  
                2'b01: begin
                    tx_serial<=data[0];
                    divcntr<=divcntr+1;
                    if(divcntr == clkdiv) begin
                        divcntr<=0;
                        Counter <= Counter +1;
                        data[8:0] <= data[9:1];
                    if(Counter==9) begin
                        Counter<=0;                         
                        State <= 2'b00;
                        done <= 1'b1;
                        end
                    end   
                end                
        endcase
    end
 end
endmodule