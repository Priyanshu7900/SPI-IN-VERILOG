module spi_master(
input clk,rst,
  input [7:0]din,
input tx_enable,
output wire mosi,cs,sclk);
  
  typedef enum logic[1:0]{idle=0,start=1,transmit=2,stop=3}state_type;
  state_type state,nextstate;
  reg [2:0]count=0;
  reg [3:0]bitcount=0;
  reg spi_sclk=1;
  
  ///////////// generation of sclk
  
  always@(posedge clk)
    begin
      case(nextstate)
        idle:begin
          spi_sclk<=0;
        end
        start:begin
          if((count<3'b011)||(count==3'b111))
            begin
              spi_sclk<=0;              
            end
          else  begin
            spi_sclk<=1;
          end
        end
        transmit:begin
            if((count<3'b011)||(count==3'b111))
            begin
              spi_sclk<=0;              
            end
          else  begin
            spi_sclk<=1;
          end
        end
        stop:begin
           if((count<3'b011)||(count==3'b111))
            begin
              spi_sclk<=0;              
            end
          else  begin
            spi_sclk<=1;
          end
        end
      endcase
    end
  
  ////////////reset sensing logic
  
  always@(posedge clk)
    begin
      if(rst)
        state<=idle;
      else
        state<=nextstate;
    end
  
 /////////////// nextstate logic
  
  always@(*)
    begin
      case(state)
        idle:begin
          if(tx_enable)
            nextstate=start;
          else
            nextstate=idle;
        end
        start:begin
          if(count==3'b111)            
              nextstate=transmit;
          else
              nextstate=start;
        end
        transmit:begin
          if((bitcount==3'b111)&&(count==3'b111))
            nextstate=stop;
          else
            nextstate=transmit;
        end
        stop:begin
          if(count==3'b111)
            nextstate=idle;
          else
            nextstate=stop;
        end
        default:nextstate=idle;
      endcase
    end
 
///////////  counter logic 
  
  always@(posedge clk)
    begin
      case(state)
        idle:begin
          count<=0;
        end
        start:begin
          count<=count+1;
        end
        transmit:begin
          count<=count+1;
        end
        stop:begin
          count<=count+1;
          end
        default:count<=0;
      endcase
    end
 
  ////////////// bitcount logic
  
  always@(posedge clk)
    begin
      case(state)
        idle,start,stop:bitcount<=0;
        transmit:begin
          if(count==3'b111)
            begin
              if(bitcount==3'b111)
                bitcount<=0;
              else
                bitcount<=bitcount+1;
            end
        end
      endcase
    end
  ////////////// mosi logic
  
  assign mosi=((state==idle)||(state==start)||(state==stop))?0:din[7-bitcount];
  
 ////////////cs logic
  assign cs=((state==start)||(state==transmit))?0:1;
  assign sclk=spi_sclk;
    
endmodule
