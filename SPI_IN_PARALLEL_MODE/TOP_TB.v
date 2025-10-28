module top_tb;
  reg clk=0;
  reg rst=0;
  reg newd=0;
  reg [7:0]din=0;
  reg [1:0]slave_select=0;
  wire [7:0]dout=0;
  always #5 clk=~clk;
  initial begin
    @(posedge dut.in1.sclk);
    newd=1;
    din=8'b10101010;
    slave_select=0;
    #200;
    newd=0;    
  end
  top dut(clk,rst,newd,slave_select,din,dout);
endmodule
