 module tb;
   reg clk100mhz=0;
   reg rst=0;
   reg start_write=0;
   reg [11:0]din=0;
   wire cs;
   wire mosi;
   wire sclk;
   wire done;
   
   always #5 clk100mhz=~clk100mhz;
   
   initial begin
     @(posedge sclk);
     start_write=1;
     din=12'b101010101010;
   end
   dac_converter in1(clk100mhz,rst,start_write,din,cs,mosi,sclk,done);
 endmodule
