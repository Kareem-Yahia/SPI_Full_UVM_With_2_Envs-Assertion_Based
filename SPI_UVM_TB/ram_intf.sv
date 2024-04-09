interface ram_if ();
	parameter ADDR_SIZE=8;
  logic clk;
  logic rst_n,rx_valid,tx_valid;
  logic [9:0] din;
  logic [ADDR_SIZE-1:0] dout;
  logic [ADDR_SIZE-1:0] dout_ex;
  logic tx_valid_ex;
endinterface 