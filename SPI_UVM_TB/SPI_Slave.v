module SPI_Slave(MOSI, SS_n, clk, rst_n, tx_data, tx_valid, MISO, rx_data, rx_valid);
	parameter IDLE = 0;
	parameter CHK_CMD = 1; 
	parameter WRITE = 2;
	parameter READ_ADD = 3;
	parameter READ_DATA = 4;

	input MOSI, SS_n, clk, rst_n, tx_valid;
	input [7:0] tx_data;
	output reg MISO=0;
	output reg rx_valid;
	output reg [9:0] rx_data;
	reg tx_valid_flag;


	
	reg [2:0] cs, ns;
	wire [7:0] temp;
	// reg [9:0] PO;
	// reg SO;
	reg flag_rd;
	reg[3:0] state_count ; 
	reg[2:0] final_count ;

	//output logic 2
	// assign temp = (tx_valid)? tx_data: temp;
	assign temp=tx_data;
	// assign MISO = SO;

	//state memory

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			flag_rd=0;
			cs <= IDLE;
		end
		else
		    cs <= ns;
	end

	//output logic 1

	/*always @(cs) begin
		case (cs)
		      IDLE: rx_valid = 0;
		      WRITE: rx_valid = 1;
		      READ_ADD: rx_valid = 1;
		      READ_DATA: rx_valid = 1;
		      default: rx_valid = 0;
		endcase
	end*/

	always @(posedge clk) begin
		if ((cs == WRITE) || (cs == READ_ADD) || (cs == READ_DATA)) begin
		    rx_data <= {rx_data[8:0], MOSI};
		    if (state_count == 9) begin
				state_count <= 0;
				rx_valid <= 1;
		    end
		    else begin
		    	rx_valid <= 0;
		    	state_count <= state_count + 1;
		    end
		end
		else begin
			rx_valid<=0;
			state_count <= 0;
		end
			MISO<=0;
			if ( (tx_valid || tx_valid_flag)  ) begin
				tx_valid_flag<=1;
		    	MISO <= temp[7-final_count];
		    	final_count <= final_count + 1;
		    	if (final_count == 7) begin 
					final_count <= 0;
					tx_valid_flag<=0;
				end
			end
			else begin
				tx_valid_flag<=0;
				final_count <= 0;
			end
	end

	//next state logic

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
