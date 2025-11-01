
module spi_master_with_crc(
input clk,newd,rst,
  input[7:0]din,
  output wire sclk,
output reg cs,
output reg mosi,
  output reg done_sending);
  
  reg[2:0]clk_count=0;
  reg spi_sclk=0;
  /////////// generation of the sclk
  always@(posedge clk)
    begin
      if(clk_count<3)
        begin
          clk_count<=clk_count+1;
        end
      else
        begin
          clk_count<=0;
          spi_sclk<=~spi_sclk;
        end
    end
  
  
  /////////////////////// fsm logic
  reg[7:0]din_t=0;
  reg[3:0]count=0;
  reg[11:0]data_frame=0;
  reg[4:0]generator_polynomial=5'b10011;
  reg[11:0]t_frame=0;
  reg[3:0]remainder=0;
  integer i;
  typedef enum logic [1:0]{idle=0,add_crc=1,send=2}state_type;
  state_type state=idle;
  always@(posedge sclk)
    begin
      if(rst)
      begin
      state<=idle;
              count<=0;
              done_sending<=0;
              cs<=1;
              mosi<=0;
      end
      else
      begin
      case(state)
        idle:begin
          if(newd)
            begin
              cs<=1;
              state<=add_crc;
              t_frame<={din,4'b0000};
            end
          else
            begin
              state<=idle;
              count<=0;
              done_sending<=0;
              cs<=1;
              mosi<=0;
            end
        end
        add_crc:begin
          for(i=11;
             i>=4;i--)
            begin
              if(t_frame[i]==1)
                t_frame[i-:5]=t_frame[i-:5]^generator_polynomial;
            end
          
          remainder=t_frame[3:0];
          data_frame<={din,remainder}; 
          state<=send; 
          cs<=0;        
        end
        send:begin
          if(count<12)
            begin
              count<=count+1;
              mosi<=data_frame[count];
              state<=send;
            end
          else
            begin
              count<=0;
              state<=idle;
              cs<=1;
              mosi<=0;
              done_sending<=1;
            end
        end
        default:begin
          state<=idle;
          done_sending<=0;
          cs<=1;
          mosi<=0;
        end
      endcase
      end
    end  
 assign sclk=spi_sclk; 
endmodule
