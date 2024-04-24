`timescale 1ns / 1ps
module UART_RX #(parameter clkdiv=50000000/115200-1)(
    input clk,
    input rst,
    input rx_serial,
    output reg [7:0]dout,
    output  stop
    );
    reg [15:0] cntr;
    reg [3:0] bitcntr;
    reg [2:0]State;
    reg [8:0]data;
    
    always@(posedge clk) begin
        if(rst) begin
            State <= 0;
            cntr<=0;
            bitcntr<=0;
            data <= 9'b1_1111_1111;
        end
        else begin
            case(State)
                2'b00: begin
//                               stop<=0;
    
                    if(!rx_serial) begin 
                        cntr <= cntr+1;
                    
                        if(cntr==clkdiv[15:1]) begin
                        State<=2'b01;
                        cntr<=0;
                        bitcntr<=0;
                        end  
                    end
               end          
                2'b01: begin
                    cntr<=cntr+1;
                    if(cntr==clkdiv) begin
                     cntr<=0;
                     bitcntr<=bitcntr+1;
                     data <= {rx_serial,data[8:1]};
                    end            
                    if(bitcntr == 8) begin
//                        stop<=1;
                        bitcntr<=0;
                        State <= 2'b00;
                        dout <= data[8:1];
                        data <= 9'b1_1111_1111;
                    end
                end
            endcase
        end
    end
assign stop = (bitcntr==8)? 1:0;
endmodule
