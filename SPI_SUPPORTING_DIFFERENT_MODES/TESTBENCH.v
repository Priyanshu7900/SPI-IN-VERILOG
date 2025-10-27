module top_tb;
  reg start=0;
  reg [1:0]mode;
  reg clk=0;
  reg rst=0;
  reg[7:0]din=0;
  wire[7:0]dout;
  wire done;
  
  always #5 clk=~clk;
  initial begin
    #50;
    @(posedge clk)
    start=1;
    @(posedge clk)
    start=0;
  end
 
  initial begin
    #10;
    rst=1;
    repeat(2)@(posedge clk);
    rst=0;
  end
  initial begin
    mode=0;
  end
  
  initial begin
    din=8'haa;
    #1000;
    $finish();
  end
  
  top dut(clk,rst,mode,start,din,dout,done);
endmodule
