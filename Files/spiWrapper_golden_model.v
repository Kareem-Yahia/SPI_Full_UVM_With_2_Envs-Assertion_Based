module spi_wrapper_golden_model(MOSI,MISO,SS_n,clk,rst_n);
input clk,rst_n,MOSI,SS_n;
output MISO;
wire [9:0] rx_data_z;
wire rx_valid_z;
wire [7:0] tx_data_z;
wire tx_valid_z;

//spi_slave s1(MOSI,MISO,SS_n,clk,rst_n,tx_data_z,tx_valid_z,rx_data_z,rx_valid_z);
//ram r1(rx_data_z,rx_valid_z,clk,rst_n,tx_data_z,tx_valid_z);
spi_slave_golden_model s1(.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n),.clk(clk),.rst_n(rst_n),.tx_data(tx_data_z),.tx_valid(tx_valid_z),.rx_data(rx_data_z),.rx_valid(rx_valid_z));
ram_golden_model r1(.din(rx_data_z),.rx_valid(rx_valid_z),.clk(clk),.rst_n(rst_n),.dout(tx_data_z),.tx_valid(tx_valid_z));



endmodule