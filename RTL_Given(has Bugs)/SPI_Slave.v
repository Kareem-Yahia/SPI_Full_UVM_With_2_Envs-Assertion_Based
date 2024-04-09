module SPI_Slave(MOSI, SS_n, clk, rst_n, tx_data, tx_valid, MISO, rx_data, rx_valid);
	parameter IDLE = 0; parameter CHK_CMD = 1; parameter WRITE = 2;
	parameter READ_ADD = 3; parameter READ_DATA = 4;

	input MOSI, SS_n, clk, rst_n, tx_valid;
	input [7:0] tx_data;
	output MISO;
	output reg rx_valid;
	output reg [9:0] rx_data;


	reg [2:0] cs, ns;
	reg [9:0] PO;
	wire [7:0] temp;
	reg SO, flag_rd = 0;
	integer state_count = 0, final_count = 0;

	assign temp = (tx_valid)? tx_data: temp;
	assign MISO = SO;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
		    cs <= IDLE;
		else
		    cs <= ns;
	end

	always @(cs) begin
		case (cs)
		      IDLE: rx_valid = 0;
		      WRITE: rx_valid = 1;
		      READ_ADD: rx_valid = 1;
		      READ_DATA: rx_valid = 1;
		      default: rx_valid = 0;
		endcase
	end

	always @(posedge clk or negedge SS_n) begin
		if ((cs == WRITE) || (cs == READ_ADD) || (cs == READ_DATA)) begin
		    PO <= {PO[8:0], MOSI}; state_count <= state_count + 1;
		    if (state_count == 10) begin
			rx_data <= PO; state_count <= 0;
		    end
		end
		if (rx_data[9:8] == 2'b11 && temp) begin
		    SO <= temp[7-final_count];
		    final_count <= final_count + 1;
		    if (final_count == 10)
			final_count <= 0;
		end
	end

	always @(MOSI, SS_n, cs) begin
		case (cs)
		      IDLE:
			if (SS_n)
			    ns = IDLE;
			else
			    ns = CHK_CMD;
		      CHK_CMD:
			if (SS_n)
			    ns = IDLE;
			else begin
			    if (!MOSI)
				ns = WRITE;
			    else begin
				if (!flag_rd)
				    ns = READ_ADD;
				else
				    ns = READ_DATA;
			    end
			end
		      WRITE:
			if (SS_n)
			    ns = IDLE;
			else
			    ns = WRITE;
		      READ_ADD:
			if (SS_n)
			    ns = IDLE;
			else begin
			    ns = READ_ADD; flag_rd = 1;
			end
		      READ_DATA:
			if (SS_n)
			    ns = IDLE;
			else begin
			    ns = READ_DATA; flag_rd = 0;
			end
		      default: ns = IDLE;
		endcase
	end

endmodule
