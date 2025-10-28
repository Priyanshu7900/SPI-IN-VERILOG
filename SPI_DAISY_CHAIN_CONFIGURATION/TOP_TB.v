module tb;
  reg clk=0;
  reg newd=0;
  reg[7:0]din=0;
  wire dout;
  wire done;
  always #5 clk=~clk;
  top dut(clk,newd,din,dout,done);
  initial begin
    @(posedge dut.in1.sclk);
    din=8'haa;
    newd=1;
    #200;
    newd=0;
    #5000;
    $finish();
  end  
endmodule
