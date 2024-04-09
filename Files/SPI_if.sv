interface SPI_if (clk);
  
  input clk;
  logic MOSI, SS_n, clk, rst_n_in;
  logic MISO;
  logic MISO_Ex;
  //just internal signals needs to be covered in functional coverage
    logic in1;
    logic in2;
    logic in3;
    logic wait_plz;

  //wire rx_valid, tx_valid;
  //wire [9:0] rx_data;
  //wire [7:0] tx_data;

endinterface