module top (input clk,newd,
            input[7:0]din,
            output reg [7:0]dout,
            output reg done_sending);
  wire sclk,cs,sdi1,sdi2,sdo1,sdo2;
  daisy_chain_master in1(clk,newd,din,sdo2,cs,sclk,dout,sdo1);
  daisy_chain_slave1 in2(sclk,cs,sdo1,sdi1,done);
  daisy_chain_slave2 in3(sclk,cs,sdi1,sdo2,done);
endmodule
