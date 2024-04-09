module project_tb_sva (MOSI, SS_n, clk, rst_n, MISO,rx_valid,tx_valid,rx_data,tx_data);
	input MOSI, SS_n, clk, rst_n, MISO;

	input rx_valid, tx_valid;
	input [9:0] rx_data;
	input [7:0] tx_data;

	//here we check_resest
	always_comb begin
		if(!rst_n) begin
			check_async_reset: assert final ( tx_data==0 && tx_valid==0 );//we didn't put miso as its deferred one clock cycle
		end
	end

	property serial_to_parallel;
		@(posedge clk) disable iff (!rst_n) $rose(rx_valid) |-> (rx_data=={$past(MOSI,10),$past(MOSI,9),$past(MOSI,8),$past(MOSI,7),
		$past(MOSI,6),$past(MOSI,5),$past(MOSI,4),$past(MOSI,3),$past(MOSI,2),$past(MOSI,1)});
	endproperty	

	property parallel_to_serial;
		@(posedge clk) disable iff (!rst_n) $rose(tx_valid) |=> (MISO==tx_data[7] ##1 MISO==tx_data[6] ##1 MISO==tx_data[5] ##1 
			MISO==tx_data[4] ##1 MISO==tx_data[3] ##1 MISO==tx_data[2] ##1 MISO==tx_data[1] ##1 
			MISO==tx_data[0]);
	endproperty

	//also we check that rx_valid && tx_valid never asserted if SS_n=1 (end of communication)
    //also MISO ==0

	property check_ss_n;
		@(posedge clk) disable iff (!rst_n) $rose(SS_n) |=> ##1((!MISO) && (!rx_valid) && (!tx_valid) );
	endproperty

		//HERE we check when ss_n=1 end of communication miso must be zero
	property miso_check;
		@(posedge clk) disable iff (!rst_n) SS_n |=> ##1(!MISO);
	endproperty

		//here we check that when SS_n=0 (start of communication ) then mosi must follow these patterns 
		//if mosi=0 for writing then after it 00 or 01 
		//if mosi=1 for reading then after it 10 or 11
		// patterns like 010 or 011 or 100 or 101 is forbidden

	property pattern1;
		@(posedge clk) disable iff (!rst_n) ( $fell(SS_n) ##1 (!MOSI) ) |=> (!MOSI);
	endproperty

	property pattern2;
		@(posedge clk) disable iff (!rst_n) ( $fell(SS_n) ##1 (MOSI) ) |=> (MOSI);
	endproperty	

	//here we assert properties

	serial_to_parallel_sva:assert property  (serial_to_parallel);
	parallel_to_serial_sva:assert property  (parallel_to_serial);
	check_ss_n_sva:assert property (check_ss_n);
	miso_check_sva: assert property(miso_check);
	pattern1_sva:assert property(pattern1);
		pattern2_sva:assert property(pattern2);

	cover_serial_to_parallel_sva: cover property (serial_to_parallel);
	cover_parallel_to_serial_sva: cover property (parallel_to_serial);
	cover_check_ss_n_sva: cover property (check_ss_n);
	cover_miso_check_sva: cover property(miso_check);
	cover_pattern1_sva: cover property(pattern1);
		cover_pattern2_sva: cover property(pattern2);

endmodule