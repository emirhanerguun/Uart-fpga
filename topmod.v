`timescale 1ns / 1ps
module topmod(
input clk,
input rst,
input  rx_serial,
input rd_en_i,
output full_o,
output [7:0] data_o,
output empty_o,
output  tx_serial
);
reg wr_en_i;
reg [7:0] internal;
wire [7:0] dout;
wire [7:0] data_i;
wire stop;
    
UART_TX UART_TX(
.clk(clk),
.rst(rst),
.din(internal),
.enable(rd_en_i),
.tx_serial(tx_serial)
);

UART_RX UART_RX(
    .clk(clk),
    .rst(rst),
    .rx_serial(rx_serial),
    .dout(dout),
    .stop(stop)
);

sync_fifo SYNC_FIFO(
.clk(clk),
.rst(rst),

.wr_en_i(stop),
.data_i(data_i),

.rd_en_i(rd_en_i),
.data_o(data_o),

.full_o(full_o),
.empty_o(empty_o)
);
assign data_i=dout;

always @( posedge clk )begin
//if(stop) begin
//tx_serial<=!tx_serial; end

if(empty_o && !full_o ) begin
internal<=8'b01100101; //e
end
else if(!empty_o && full_o) begin
internal<=8'b01100110; //f
end
end



endmodule
