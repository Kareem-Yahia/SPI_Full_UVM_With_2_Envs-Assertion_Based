module spi_slave_golden_model(MOSI,MISO,SS_n,clk,rst_n,tx_data,tx_valid,rx_data,rx_valid);
  parameter IDLE=3'b000;
  parameter CHK_CMD=3'b001;
  parameter WRITE=3'b010;
  parameter READ_ADD =3'b011;
  parameter READ_DATA=3'b100;


  input MOSI;
  input [7:0] tx_data;
  input SS_n,clk,rst_n,tx_valid;
  output reg MISO;
  output reg rx_valid;
  output reg [9:0] rx_data;

  reg[3:0] counter,i; //both are counters but i is counter for rd_data only
  reg [2:0] cs, ns;
  reg flag;
  reg tx_validflag;
  wire  [7:0] temp;

  //ns logic
  always @ (*) begin
    case (cs)
    IDLE:
         if(!SS_n)
         ns=CHK_CMD;
         else 
         ns=IDLE;
      CHK_CMD:
            if(SS_n==0 && MOSI==0)
            ns=WRITE;
            else if(SS_n==0 && MOSI==1 &&flag==0 ) 
            ns=READ_ADD;
            else if(SS_n==0 && MOSI==1 &&flag==1) 
            ns=READ_DATA;
            else
            ns=IDLE;
    WRITE:          
              if(SS_n)
              ns=IDLE;
              else
              ns=WRITE;
      READ_ADD:
              if(SS_n) 
              ns=IDLE;
              else 
              ns=READ_ADD;
      READ_DATA:
                if(SS_n)
                ns=IDLE;
                else
                ns=READ_DATA;
      default :
                ns=IDLE;
      endcase                
  end

  // state memory
  always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
    cs<=IDLE;
    flag<=0;
    end
    else begin
      cs<=ns;
      if(ns==READ_ADD)
      flag<=1;
      else if(ns==READ_DATA)
      flag<=0;
    end
  end

  // output logic
  always @ (posedge clk) begin
    case (cs)
    IDLE:{tx_validflag,i,counter,rx_data,rx_valid,MISO}<=0;
      CHK_CMD:
           {tx_validflag,i,counter,rx_data,rx_valid,MISO}<=0;
    WRITE:begin 
               rx_data<={rx_data[8:0],MOSI};
               if(counter==9) begin
               rx_valid<=1;
               counter<=0;
               end
               else
               rx_valid<=0;
               MISO<=0; 
               counter<=counter+1'b1;
          end
      READ_ADD:begin
               rx_data<={rx_data[8:0],MOSI};
               if(counter==9) begin
               rx_valid<=1;
               counter<=0;
               end
               else
               rx_valid<=0;
               MISO<=0;
               counter<=counter+1'b1;
             end      
      READ_DATA:
               begin
                rx_data<={rx_data[8:0],MOSI}; //convert from series to parallel
                if(counter==9) begin
                rx_valid<=1;
                counter<=0;
                end
                else
                rx_valid<=0;
                counter<=counter+1'b1;
                if(tx_valid)
                tx_validflag<=1;
                if(tx_validflag || tx_valid)begin// here we convert from parallel to series && tricky
                MISO<=temp[7-i];
                if(i==7) 
                i<=0;
                i<=i+1'b1;
                end
                else 
                MISO<=0;
              end  
      default :{tx_validflag,rx_data,rx_valid,MISO}<=0;
      endcase
  end
    assign temp=tx_data;
endmodule