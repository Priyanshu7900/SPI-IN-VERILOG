  module slave1( input sclk,cs1,mosi,
               output reg miso,
                output reg done1);
 
    typedef enum logic[1:0] {idle=0,receive=1,send=2}state_type;
  state_type state=idle;
  
    reg [3:0] count=0;
    reg[7:0]data_t=0;
    reg[7:0]data=0;
    always@(negedge sclk)
      begin
        case(state)
          idle:begin
            if(cs1==0)
              begin
                state<=receive;
                data_t[0]<=mosi;
                count<=1;
              end
            else
              begin
                state<=idle;
                count<=0;
                done1<=0;
                miso<=0;
              end
          end
          receive:begin
            if(count<7)
              begin
                count<=count+1;
                state<=receive;
                data_t[count]<=mosi;
              end
            else
              begin
                count<=0;
                state<=send;
                data<={mosi,data_t[6:0]};
              end
          end
          send:begin
            if(count<7)begin
              count<=count+1;
              miso<=data[count];
              state<=send;
            end
            else
              begin
                 miso<=data[count];
                count<=0;
                done1<=1;
                state<=idle;
              end
          end
        endcase
      end
  endmodule
