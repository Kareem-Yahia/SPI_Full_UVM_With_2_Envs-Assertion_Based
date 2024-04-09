module ram_golden_model(din,rx_valid,clk,rst_n,dout,tx_valid);
parameter MEM_DEPTH=256;
	parameter ADDR_SIZE=8;

	input [9:0] din;
	input rx_valid,clk,rst_n;
	output reg [7:0] dout;
	output reg tx_valid;

	reg [7:0] mem [MEM_DEPTH-1:0];

	reg [ADDR_SIZE-1:0] wr_addr;
	reg [ADDR_SIZE-1:0] rd_addr;



	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
		dout<=0;
		else begin
			if(rx_valid) begin
				if(din[9:8]==2'b00)
				wr_addr<=din[7:0];
				else if(din[9:8]==2'b01)
				mem[wr_addr]<=din[7:0];
				else if(din[9:8]==2'b10)
				rd_addr<=din[7:0];
				else if(din[9:8]==2'b11)
				dout<=mem[rd_addr];
			end
		end
	end
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tx_valid<=0;
		else begin
			if(din[9:8]==2'b11 && rx_valid==1)
				tx_valid<=1'b1;
			else
				tx_valid<=1'b0;
		end
	end
	// assign tx_valid=(din[9:8]==2'b11 && rx_valid==1)? 1'b1:1'b0;

endmodule