
 module spi_master_with_modes(input start,
                      input [1:0]mode,
                     input clk,rst,
                      input[7:0]din,
                      output reg sclk,
                     output reg mosi,
                     output  reg cs
                     );

reg start_t=0;
always@(posedge clk)
  begin
   start_t<=start;
  end

wire cpol;
wire cphas;
assign {cpol,cphas}=mode;

reg[1:0]clk_count=0;
integer spi_edges=0;



//////////////////////////// generating the sclk
always@(posedge clk or posedge rst)
  begin
    if(rst)
      begin
        sclk<=cpol;
        clk_count<=0;
        spi_edges<=0;
      end
    else
      begin
        if(start_t)
          begin
          spi_edges<=16;
          end
        else if(spi_edges>0)
          begin
            if(clk_count==1)
              begin
                spi_edges<=spi_edges-1;
                clk_count<=clk_count+1;
                sclk<=~sclk;
              end
            else if(clk_count==3)
              begin
                spi_edges<=spi_edges-1;
                clk_count<=clk_count+1;
                sclk<=~sclk;
              end
            else
              clk_count<=clk_count+1;
          end
        else
          begin
            sclk<=cpol;
            clk_count<=0;
          end
      end
  end

reg [2:0]state=0;
reg [3:0]bitcount=4'b0111;
reg [1:0]count=0;
///////////////// mosi,cs logic 
always@(posedge clk or posedge rst)
  begin
    if(rst)
      begin
       mosi<=0;
        cs<=1;
        state<=0;
        count<=0;
        bitcount<=4'b0111;
      end
    else begin
      case(state)
      0:begin
        if(start)
          begin
            if(!cphas)
              begin
                cs<=0;
                state<=1;
              end
            else begin
              cs<=0;
              state<=2;
            end
          end
        else
          state<=0;
      end
        1:begin
          if(bitcount!=0)
            begin
             count<=count+1;
              mosi<=din[bitcount];
              if(count==2'b11)
                bitcount<=bitcount-1;
            end
          else
            begin
             count<=count+1;
              mosi<=din[bitcount];
              if(count==2'b11)
              state<=4;
            end          
        end
        2:begin
          state<=3;
        end
        3:begin
          state<=1;
        end
        4:begin
          mosi<=0;
          count<=0;
          bitcount<=4'b0111;
          if(spi_edges==0)
          cs<=1;
          else
          cs<=cs;
        end
      endcase
    end
  end
endmodule
