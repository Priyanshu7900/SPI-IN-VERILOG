 module top(input clk,rst,newd,
        input [7:0]din,
                   output reg done_sending,done_receiving,
                   output reg [7:0]data,
                   output reg err);
                   wire sclk,cs,mosi;
          spi_master_with_crc in1(clk,newd,rst,din,sclk,cs,mosi,done_sending);
          spi_slave_with_crc in2(sclk,cs,mosi,done_receiving,err,data);         
          
        endmodule
