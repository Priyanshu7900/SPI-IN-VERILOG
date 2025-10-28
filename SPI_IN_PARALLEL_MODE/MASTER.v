
module master(
input clk,rst,newd,
  input [1:0]slave_select,
  input [7:0]din,
   input miso,
output reg cs1,
output reg cs2, 
  output reg mosi,
output wire sclk,
  output reg [7:0]dout);
  
  reg [3:0]clk_count=0;
  reg spi_sclk=0;
  
   //////////// generating the sclk
   always@(posedge clk)
    begin
      if(clk_count<3)
        clk_count<=clk_count+1;
      else begin
        clk_count<=0;
        spi_sclk<=~spi_sclk;
      end
    end
  
  typedef enum logic[1:0] {idle=0,send=1,collect=2}state_type;
  state_type state=idle;
  
  
  reg[3:0]count=0;
  reg[7:0]din_t=0;
  reg[7:0]data_t=0;
  
  always@(posedge sclk)
    begin
      if(rst)
        begin
          state<=idle;
        count<=0;
        cs1<=1;
        cs2<=1;
        mosi<=0;
        end
      else begin
      case(state)
        idle:begin
      if(newd)
        begin
          state<=send;
          mosi<=din[0];
          din_t<=din;
          count<=1;
          case(slave_select)
          2'b00:begin
          cs1<=1;
          cs2<=1;
          end
          2'b01:begin
          cs1<=0;
          cs2<=1;
          end
          2'b10:begin
          cs1<=1;
          cs2<=0;
          end
          2'b11:begin
          cs1<=0;
          cs2<=0;
          end
          endcase
        end
      else begin
        state<=idle;
        count<=0;
        cs1<=1;
        cs2<=1;
        mosi<=0;        
      end
        end
        send:begin
          if(count<8)
            begin
              count<=count+1;
              mosi<=din_t[count];
              state<=send;
            end
          else
            begin
              state<=collect;
              mosi<=0;
              count<=0;
            end
        end
        collect:begin
          if(count<7)
            begin
              state<=collect;
              count<=count+1;
              data_t[count]<=miso;
            end
          else begin
            dout<={miso,data_t[6:0]};
            count<=0;
            state<=idle;
            cs1<=1;
            cs2<=1;
            mosi<=0;
          end
        end
        default:begin
          state<=idle;
          cs1<=1;
          cs2<=2;
          count<=0;
          mosi<=0;
        end
      endcase
      end
    end
  assign sclk=spi_sclk;
 endmodule
