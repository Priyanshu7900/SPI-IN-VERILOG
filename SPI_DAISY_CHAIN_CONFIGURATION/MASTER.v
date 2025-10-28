`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Priyanshu Gupta
// 
// Create Date: 28.10.2025 10:44:02
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module daisy_chain_master(
input clk,newd,
  input[7:0]din,
input sdi,
output reg cs,
output reg sclk,
  output reg [7:0]dout,
output reg sdo);
  
  reg spi_sclk=0;
  integer clk_count=0;
  
  /////////// generation of  sclk
  typedef enum logic[1:0]{sample=0,send=1,waitt=2,collect=3}state_type;
  state_type state=sample;
  always@(posedge clk)
    begin
      if(clk_count<3)
        clk_count<=clk_count+1;
      else
        begin
          spi_sclk<=~spi_sclk;
          clk_count<=0;
        end
    end
  reg[7:0]din_t=0;
  reg[3:0]count=0;
  reg[7:0]data;
  
  /////////////////////// sending serially data form master to slave 1 
  ///////////and waiting till it receives data back form the slave
  always@(posedge sclk)
    begin
      case(state)
        sample:begin
          if(newd==1)
          begin
           cs<=0;
            din_t<=din;
            sdo<=din[0];
            state<=send;
            count<=count+1;
          end
        else
          begin
            state<=sample;
            cs<=1;
            sdo<=0;
            dout<=0;
          end
        end
        send:begin
          if(count==8)
            begin
              sdo<=0;
              state<=waitt;
              count<=0;
            end
          else
            begin
              state<=send;
              sdo<=din_t[count];
              count<=count+1;
            end
        end
        waitt:begin
          if(count<7)
            begin
              count<=count+1;
              state<=waitt;
            end
          else if(count==7) begin
            state<=waitt;
            count<=count+1;
          end
          else begin
            state<=collect;
            count<=0;
          end
        end
        collect:begin
          if(count==3'b111)
            begin
              count<=0;
              state<=sample;
              cs<=1;
              dout<={sdi,data[6:0]};
            end
          else
            begin
              count<=count+1;
              state<=collect;
              data[count]<=sdi;
            end
        end
      endcase
    end
  
          
   assign sclk=spi_sclk;
endmodule
