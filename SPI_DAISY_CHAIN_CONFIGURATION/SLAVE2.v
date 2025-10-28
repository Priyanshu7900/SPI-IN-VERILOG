module daisy_chain_slave2(input sclk,cs,sdi,
                          input done_slave1,
                         output reg sdo,
                        output reg done);
  reg[3:0]count=0;
  typedef enum logic [1:0] {idle=0,receive=1,send=2}state_type;
  state_type [1:0]state=idle;
  
  reg[7:0]data_t=0;
  reg[7:0]data=0;
  reg newd=0;
  
  ////////////// receiving the data in the slave 1 form the master
  always@(posedge sclk)
    begin
      case(state)
        idle:begin
          if(done_slave1)
           begin
             data_t[count]<=sdi;
             count<=count+1;
             state<=receive;
           end
          else
            begin
              state<=idle;
              count<=0;
              done<=0;
            end
        end
        receive:begin
          if(count==8)
            begin
              state<=send;
              count<=1;
              data<=data_t;
              sdo<=data_t[0];
            end
          else
            begin
              data_t[count]<=sdi;
              count<=count+1;
              state<=receive;
            end
        end
        send:begin
          if(count==8)
            begin
              state<=idle;
              count<=0;
              sdo<=0;
              done<=1;
            end
          else
            begin
              sdo<=data_t[count];
              count<=count+1;
            end
        end
      endcase
    end
  
  

endmodule
