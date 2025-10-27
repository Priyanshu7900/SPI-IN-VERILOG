module top(input clk,rst,tx_enable,
            input [7:0]din,
           output reg[7:0]dout,
           output reg done );
  wire sclk,cs,mosi;
  spi_master in1(clk,rst,din,tx_enable,mosi,cs,sclk);
  spi_slave in2(sclk,cs,mosi,dout,done);
endmodule
