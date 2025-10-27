module spi_slave(input sclk,cs,mosi,
                 output reg[7:0]dout,
                 output reg done);
  reg [2:0]count=0;
  reg[7:0]data=0;
  
  typedef enum logic[1:0] {idle=0,sample=1}state_type;
  state_type state=idle;
  
  always@(posedge sclk)
    begin
      case(state)
        idle:begin
          dout<=0;
          done<=0;
          if(cs==0)
            state<=sample;
          else
            state<=idle;
        end
        sample:begin
          if(count<7)
            begin
            state<=sample;
              count<=count+1;
               data<={data[6:0],mosi};              
            end
          else
            begin
              state<=idle;
              dout<={data[6:0],mosi};
              done<=1;
              count<=0;
            end
        end
        default:begin
          state<=idle;
          dout<=0;
          done<=0;
        end
      endcase
    end
endmodule
