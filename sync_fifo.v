`timescale 1ns / 1ps

module sync_fifo(
input clk,
input rst,

input wr_en_i,
input [7:0] data_i,
output full_o,

input rd_en_i,
output reg [7:0] data_o,
output empty_o
);

parameter DEPTH = 8;
reg [7:0] mem [0:DEPTH-1]; //Defined fifo

reg [2:0] wr_ptr;
reg [2:0] rd_ptr;
reg [3:0] count;
reg full,empty;
always @(*) begin
    full = (count==DEPTH)? 1 : 0;
    empty = (count==0)? 1 : 0;
end

assign full_o=full;
assign empty_o=empty;


always @(posedge clk) begin //Writing
    if (rst) begin
    wr_ptr<=2'd0;
    rd_ptr<=3'd0;
    count<=4'd0;
    end
    else begin
    if(wr_en_i==1 && ~full_o) begin
            mem[wr_ptr]<=data_i;
            wr_ptr<= wr_ptr + 1;
            count<= count + 1;
        end
    else if(rd_en_i==1 && ~empty_o) begin
            data_o<=mem[rd_ptr];
            rd_ptr<= rd_ptr + 1;
            count<= count - 1;
        end
    end
end
endmodule
//`timescale 1ns / 1ps
//module sync_fifo(
//input clk,
//input rst,
//input wr_en_i,
//input rd_en_i,
//input [7:0] data_i,
//output reg [7:0] data_o,
//output reg full_o,
//output reg empty_o
//);

//reg [7:0] mem [7:0];
//reg [3:0] wr_ptr;
//reg [3:0] rd_ptr;
//reg[2:0] count;

//always @(posedge clk) begin
//if(rst) begin
//wr_ptr<=0;
//rd_ptr<=0;
//end
//else begin
//if(wr_en_i && !full_o) begin
//mem[wr_ptr%8]<=data_i;
//wr_ptr<=wr_ptr+1;
//end
//if(rd_en_i && !empty_o) begin
//data_o<=mem[rd_ptr%8];
//rd_ptr<=rd_ptr+1;
//end
//end
//end

//always @(*) begin
//full_o=(wr_ptr-rd_ptr==8);
//empty_o=(wr_ptr==rd_ptr);
//end
//endmodule

//module sync_fifo(
//input clk,
//input rst,
//input wr_en_i,
//input rd_en_i,
//input [7:0] data_i,
//output reg [7:0] data_o,
//output reg full_o,
//output reg empty_o

//);


//parameter WIDTH = 8;
//parameter DEPTH = 8;
//parameter POINTER_SIZE = 5;

//reg [WIDTH - 1 : 0 ] memory [0 : DEPTH - 1];
//reg [POINTER_SIZE - 1 : 0] wr_ptr;
//reg [POINTER_SIZE - 1 : 0] rd_ptr;

//always @(*) begin
//empty_o = ((wr_ptr - rd_ptr) == 0) ? 1'b1 : 1'b0;   
//full_o = ((wr_ptr - rd_ptr) == DEPTH) ? 1'b1 : 1'b0; 
//end

//always@(posedge clk)
//  begin
//    if (rst == 1'b1)
//      begin
//        data_o <= 0;
//        rd_ptr <= 0;
//        wr_ptr <= 0;
//      end
//    else
//      begin
//        if ((wr_en_i == 1'b1) && (full_o == 1'b0))
//          begin
//          memory[wr_ptr] <= data_i;
//          wr_ptr <= wr_ptr + 1;
//          end
//        end
        
//        if((rd_en_i == 1'b1) && (empty_o == 1'b0))
//          begin
//          data_o <= memory[rd_ptr];
//          rd_ptr <= rd_ptr + 1;
//          end
//        end
      
//endmodule