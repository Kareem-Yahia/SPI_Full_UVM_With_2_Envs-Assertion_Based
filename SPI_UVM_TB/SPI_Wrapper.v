module SPI_Wrapper(MOSI, SS_n, clk, rst_n, MISO);
	input MOSI, SS_n, clk, rst_n;
	output MISO;


	wire rx_valid, tx_valid;
	wire [9:0] rx_data;
	wire [7:0] tx_data;

	SPI_Slave SLAVE(MOSI, SS_n, clk, rst_n, tx_data, tx_valid, MISO, rx_data, rx_valid);
	Dp_Sync_RAM RAM(clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);

endmodule
