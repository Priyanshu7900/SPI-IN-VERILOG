module dac_converter(input clk100mhz,rst=0,start_write=0,
                     input [11:0]din,
                     output reg cs,
                     output reg mosi,
                     output wire sclk,
                     output reg done
                    );
  
  reg [5:0]count=0;
  integer clk_count=0;
  reg dac_init=0;
  typedef enum logic[1:0]{idle_dac=0,init_dac=1,data_dac=2,send_data=3}state_type;
  reg [1:0]state=idle_dac;
  reg [31:0]magic_data=32'h08000001;
  reg [31:0]data;
   reg clk1mhz=0;
  
  //////////////////// generation of the 1 mhz clk from the 100 mhz system clk
  always@(posedge clk100mhz)
    begin
      if(clk_count==49)
        begin
          clk_count<=0;
          clk1mhz<=~clk1mhz;
        end
      else
        begin
          clk_count<=clk_count+1;
        end
    end
  
  //////////////////////fsm logic
  
  always@(posedge sclk or negedge start_write)
    begin
      if(!start_write)
        begin
          done<=0;
          cs<=1;
          mosi<=0;
          count<=0;
          dac_init<=0;
          state<=idle_dac;
        end
      else begin
        case(state)
          idle_dac:begin
            done<=0;
          cs<=1;
          mosi<=0;
          count<=0;
          dac_init<=0;
            if(start_write)
              begin
                if(dac_init)
                  state<=data_dac;
                else
                  state<=init_dac;
              end
            else
              begin
                state<=idle_dac;
              end
          end
          init_dac:begin
            if(count<32)
              begin
                cs<=0;
                count<=count+1;
                mosi<=magic_data[31-count];
                state<=init_dac;
              end
            else begin
              state<=data_dac;
              cs<=1;
              mosi<=0;
              count<=0;
            end
          end
          data_dac:begin
            state<=send_data;
            data<={12'h030,din,8'h00};
          end
          send_data:begin
            if(count<32)
              begin
                cs<=0;
                count<=count+1;
                mosi<=data[31-count];
                state<=send_data;
              end
            else begin
              state<=idle_dac;
              cs<=1;
              mosi<=0;
              count<=0;
              done<=1;
            end
          end
        endcase
      end
    end
  
  assign sclk=clk1mhz;
endmodule 
