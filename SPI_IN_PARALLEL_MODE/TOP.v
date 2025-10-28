  module top(
input clk,rst,newd,
input [1:0]slave_select,
  input [7:0]din,
  output reg[7:0] dout);
  wire sclk,cs1,cs2,miso,mosi,done1,done2,miso1,miso2;
  master in1(clk,rst,newd,slave_select,din,miso,cs1,cs2,mosi,sclk,dout);
  slave1 in2(sclk,cs1,mosi,miso1,done1);
  slave2 in3(sclk,cs2,mosi,miso2,done2);
  
  assign miso=(cs1==0)?miso1:miso2;
endmodule
