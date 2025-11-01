module spi_slave_with_crc(
input sclk,cs,mosi,
  output reg done_receiving,err,
  output reg[7:0] data);
  typedef enum logic[1:0]{idle=0,receive=1,check_error=2}state_type;
  state_type state =idle;
  reg [3:0]count=0;
  reg[11:0]din_t;
  reg[4:0]generator_polynomial=5'b10011;  
  always@(negedge sclk) 
  begin
  case(state)
  idle:begin
  if(cs==0)
  begin
  state<=receive;
  end
  else
  begin
  state<=idle;
  done_receiving<=0;
  err<=0;
  end
  end
  receive:begin
  if(count<11)
  begin
  din_t[count]<=mosi;
  count<=count+1;
  state<=receive;
  end
  else
  begin
  din_t[count]<=mosi;
  state<=check_error;
  count<=0;
  done_receiving<=1;
  data<={mosi,din_t[10:4]};
  end
  end
  check_error:begin
  for(int i=11;i>=4;i--)
  begin
  if(din_t[i]==1)
  din_t[i-:5]=din_t[i-:5]^generator_polynomial;
  end
  if(din_t[3:0]==4'b0000)
  begin
  err<=0;
  end
  else
  begin
  err<=1;
  end
  end
  endcase
  end 
  endmodule
