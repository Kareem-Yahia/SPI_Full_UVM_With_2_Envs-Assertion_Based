import SPI_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top();
	bit clk;
	initial begin
		clk=0;
		forever
		 #1 clk=~clk;
	end

	SPI_if SPIif(clk);
	ram_if ramif();
	SPI_Wrapper SPI_wrapper(SPIif.MOSI, SPIif.SS_n, clk, SPIif.rst_n_in, SPIif.MISO);
	spi_wrapper_golden_model SPI_wrapper_golden_model(SPIif.MOSI,SPIif.MISO_Ex,SPIif.SS_n,SPIif.clk,SPIif.rst_n_in);
	bind SPI_Wrapper  project_tb_sva sva_try (MOSI, SS_n, clk, rst_n, MISO,rx_valid,tx_valid,rx_data,tx_data);
	
	assign ramif.clk=SPIif.clk;
	assign ramif.rst_n=SPIif.rst_n_in;
	assign ramif.rx_valid=SPI_wrapper.SLAVE.rx_valid;
	assign ramif.tx_valid=SPI_wrapper.SLAVE.tx_valid;
	assign ramif.din=SPI_wrapper.SLAVE.rx_data;
	assign ramif.dout=SPI_wrapper.SLAVE.tx_data;
	//golden model_ram
	assign ramif.dout_ex=SPI_wrapper.RAM.dout;
	assign ramif.tx_valid_ex=SPI_wrapper.RAM.tx_valid;


	initial begin
		$readmemh("mem.dat",SPI_wrapper.RAM.mem);		
		$readmemh("mem.dat",SPI_wrapper_golden_model.r1.mem);
		uvm_config_db#(virtual SPI_if)::set(null, "uvm_test_top", "SPIif",SPIif);
		uvm_config_db#(virtual ram_if)::set(null, "uvm_test_top", "ramif",ramif);
		run_test("SPI_test");
	end

endmodule