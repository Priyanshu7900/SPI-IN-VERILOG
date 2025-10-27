
module spi_slave_with_modes(
input sclk,cs,mosi,
input [1:0]mode,
  output wire [7:0]dout,
output wire done);

  reg [7:0]dout1=0,dout2=0;
  reg done1=0,done2=0;
  reg [2:0]count1=3'b111;
  reg [2:0]count2=3'b111;
  reg[7:0]data1=0;
  reg[7:0]data2=0;
  
 always@(posedge sclk)
  begin
    if(cs==0)
      begin
        if(count1!=0)
          begin
            count1<=count1-1;
            data1[count1]<=mosi;            
          end
        else
          begin
            dout1<={data1[7:1],mosi};
            done1<=1;
          end
      end
  end

always@(negedge sclk)
  begin
    if(cs==0)
      begin
        if(count2!=0)
          begin
            count2<=count2-1;
            data2[count2]<=mosi;            
          end
        else
          begin
            dout2<={data2[7:1],mosi};
            done2<=1;
          end
      end
  end
 
  
  
  
  assign dout=((mode==0)||(mode==2'b11))?dout1:dout2;
  assign done=((mode==0)||(mode==2'b11))?done1:done2;
  
  endmodule

module top(
input clk,rst,
  input[1:0]mode,
  input start,
  input [7:0]din,
output wire done,
  output [7:0]dout);
  
  wire sclk,cs,mosi;
  
  spi_master_with_modes in1(start,mode,clk,rst,din,sclk,mosi,cs);
  spi_slave_with_modes in2(sclk,cs,mosi,mode,dout,done);
endmodule
