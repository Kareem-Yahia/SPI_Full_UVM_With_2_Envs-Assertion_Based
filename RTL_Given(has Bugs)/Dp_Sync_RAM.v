module Dp_Sync_RAM(clk, rst_n, din, rx_valid, dout, tx_valid);
	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;

	input clk, rst_n, rx_valid;
	input [9:0] din;
	output reg tx_valid;
	output reg [7:0] dout;


	reg [7:0] mem [MEM_DEPTH-1:0];
	reg [ADDR_SIZE-1:0] addr_rd;
	reg [ADDR_SIZE-1:0] addr_wr;

	integer i;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
		   dout <= 0;
		   for(i=0; i<MEM_DEPTH; i=i+1)
			mem[i] <= 0;
		end
		else if (rx_valid) begin
		   tx_valid <= 0;
		   case (din[9:8])
			2'b00: addr_wr <= din[7:0];
			2'b01: mem[addr_wr] <= din[7:0];
			2'b10: addr_rd <= din[7:0];
			2'b11: {dout, tx_valid} <= {mem[addr_rd], 1'b1};
		   endcase
		end
	end

endmodule
