module ram_sva(clk,rst_n,din,rx_valid,tx_valid,addr_w,addr_r,dout,mem);
input clk,rst_n,rx_valid,tx_valid;
input [9:0] din;
input [7:0] addr_w,addr_r,dout;
parameter MEM_DEPTH = 256;
input  [7:0] mem [MEM_DEPTH-1:0];
	property p1;
		@(posedge clk) disable iff(~rst_n|| ~rx_valid) (((din[9:8] == 2'b00)##1 ((din[9:8] == 2'b01)))) |=> ((mem[$past(addr_w)]) == $past (din[7:0])); 
	endproperty
		property p2;
        @(posedge clk) disable iff(~rst_n || ~rx_valid) (din[9:8]==2'b11) |=> (tx_valid);
		endproperty

     // check reset
	property p3;
		@(posedge clk) (rst_n==0) |=> (dout==0 && tx_valid==0);
	endproperty
// check write 
		property p4;
		@(posedge clk) disable iff(~rst_n || ~rx_valid) ((din[9:8]==2'b10) ##1 (din[9:8]==2'b11) |=> (mem[$past(addr_r)]==((dout))) );
		endproperty



		p1_add:assert property( p1 );
		p2_add:assert property( p2 );
		p3_add:assert property( p3 );
		p4_add:assert property( p4 );


		p2_cover:cover property(p2) $display("assertion in tx is correct");
		p1_cover: cover property (p1) $display("assertion in write is correct");
		p3_cover: cover property(p3)  $display("assertion in write for more cycles is correct");
		p4_cover: cover property(p4)  $display("assertion in read is correct");

endmodule