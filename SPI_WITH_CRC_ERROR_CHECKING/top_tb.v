module tb;
  reg clk=0;
  reg rst=0;
  reg newd=0;
  reg [7:0]din=0;
  wire done_sending,done_receiving,err;
  wire[7:0]data;
  always #5 clk=~clk;
  
  initial begin
    rst=1;
    repeat(5)@(posedge clk);
    rst=0;
    @(posedge clk);
    newd=1;
    din=8'b10101010;
    #250;
    newd=0;
  end
  top dut(clk,rst,newd,din,done_sending,done_receiving,data,err);
endmodule
