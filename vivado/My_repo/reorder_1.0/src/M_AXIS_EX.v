
`timescale 1 ns / 1 ps

module M_AXIS_EX #(
	// Users to add parameters here
	parameter integer NUMBER_OF_COLS        = 8, // 640 cols
	parameter integer NUMBER_OF_ROWS        = 4, // 480 rows
	// User parameters ends
	// Do not modify the parameters beyond this line
	// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
	parameter integer C_M_AXIS_TDATA_WIDTH = 8,
	// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
	parameter integer C_M_START_COUNT      = 8
) (
	// Users to add ports here
	// User ports ends
	// Do not modify the ports beyond this line
	// Global ports
	input  wire                                M_AXIS_ACLK   ,
	//
	input  wire                                M_AXIS_ARESETN,
	// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted.
	output wire                                M_AXIS_TVALID ,
	// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
	output wire [    C_M_AXIS_TDATA_WIDTH-1:0] M_AXIS_TDATA  ,
	// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
	output wire [(C_M_AXIS_TDATA_WIDTH/8)-1:0] M_AXIS_TSTRB  ,
	// TLAST indicates the boundary of a packet, it designates the last pixel of each line
	output wire                                M_AXIS_TLAST  ,
	// USER indicates the start of a frame, it designates the first pixel of a frame
	output wire                                M_AXIS_TUSER  ,
	// TREADY indicates that the slave can accept a transfer in the current cycle.
	input  wire                                M_AXIS_TREADY
);
	// Total number of output data
	// localparam NUMBER_OF_COLS = 8; // 640 cols
	// localparam NUMBER_OF_ROWS         = 4; // 480 rows

	// function called clogb2 that returns an integer which has the
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
		begin
			for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
				bit_depth = bit_depth >> 1;
		end
	endfunction

	// WAIT_COUNT_BITS is the width of the wait counter.
	localparam integer WAIT_COUNT_BITS = clogb2(C_M_START_COUNT-1);

	// bit_num gives the minimum number of bits needed to address 'depth' size of FIFO.
	localparam bit_num     = clogb2(NUMBER_OF_COLS);
	localparam row_bit_num = clogb2(NUMBER_OF_ROWS)        ;

	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [1:0] IDLE = 2'b00,        // This is the initial/idle state

		INIT_COUNTER  = 2'b01, // This state initializes the counter, once
		// the counter reaches C_M_START_COUNT count,
		// the state machine changes state to SEND_STREAM
		SEND_STREAM   = 2'b10; // In this state the
	// stream data is output through M_AXIS_TDATA
	// State variable
	reg [1:0] mst_exec_state;
	// Example design FIFO read pointer
	reg [bit_num-1:0] read_pointer;
	// row counter
	reg [row_bit_num-1:0] row_counter;

	// AXI Stream internal signals
	//wait counter. The master waits for the user defined number of clock cycles before initiating a transfer.
	reg [WAIT_COUNT_BITS-1:0] count;
	//streaming data valid
	wire axis_tvalid;
	//streaming data valid delayed by one clock cycle
	reg axis_tvalid_delay;
	//Last of the streaming data
	wire axis_tlast;
	// last of a frame
	wire axis_tuser;
	//Last of the streaming data delayed by one clock cycle
	reg axis_tlast_delay;
	// delay one clock cycle
	reg axis_tuser_delay;
	//FIFO implementation signals
	wire [C_M_AXIS_TDATA_WIDTH-1:0] stream_data_out;
	wire                            tx_en          ;
	//The master has issued all the streaming data stored in FIFO
	reg tx_done;


	// I/O Connections assignments

	assign M_AXIS_TVALID = axis_tvalid;
	assign M_AXIS_TDATA  = stream_data_out;
	assign M_AXIS_TLAST  = axis_tlast;
	assign M_AXIS_TSTRB  = {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};
	assign M_AXIS_TUSER  = axis_tuser;


	// Control state machine implementation
	always @(posedge M_AXIS_ACLK)
		begin
			if (!M_AXIS_ARESETN)
				// Synchronous reset (active low)
				begin
					mst_exec_state <= IDLE;
					count          <= 0;
				end
			else
				case (mst_exec_state)
					IDLE :
						// The slave starts accepting tdata when
						// there tvalid is asserted to mark the
						// presence of valid streaming data
						//if ( count == 0 )
						//  begin
						mst_exec_state <= INIT_COUNTER;
					//  end
					//else
					//  begin
					//    mst_exec_state  <= IDLE;
					//  end

					INIT_COUNTER :
						// The slave starts accepting tdata when
						// there tvalid is asserted to mark the
						// presence of valid streaming data
						if ( count == C_M_START_COUNT - 1 )
							begin
								mst_exec_state <= SEND_STREAM;
							end
							else
								begin
									count          <= count + 1;
									mst_exec_state <= INIT_COUNTER;
								end

					SEND_STREAM :
						// The example design streaming master functionality starts
						// when the master drives output tdata from the FIFO and the slave
						// has finished storing the S_AXIS_TDATA
						if (tx_done)
							begin
								mst_exec_state <= IDLE;
								count          = 0;
							end
							else
								begin
									mst_exec_state <= SEND_STREAM;
								end
				endcase
		end


	//tvalid generation
	//axis_tvalid is asserted when the control state machine's state is SEND_STREAM and
	//number of output streaming data is less than the NUMBER_OF_COLS.
	assign axis_tvalid = ((mst_exec_state == SEND_STREAM) && (read_pointer < NUMBER_OF_COLS));

	// AXI tlast generation
	// axis_tlast is asserted number of output streaming data is NUMBER_OF_COLS-1
	// (0 to NUMBER_OF_COLS-1)
	assign axis_tlast = (read_pointer == NUMBER_OF_COLS-1);
	assign axis_tuser = ((row_counter == 0)&&(mst_exec_state == SEND_STREAM)&&(read_pointer == 0));


	// Delay the axis_tvalid and axis_tlast signal by one clock cycle
	// to match the latency of M_AXIS_TDATA
	always @(posedge M_AXIS_ACLK)
		begin
			if (!M_AXIS_ARESETN)
				begin
					axis_tvalid_delay <= 1'b0;
					axis_tlast_delay  <= 1'b0;
					axis_tuser_delay  <= 1'b0;
				end
			else
				begin
					axis_tvalid_delay <= axis_tvalid;
					axis_tlast_delay  <= axis_tlast;
					axis_tuser_delay  <= axis_tuser;
				end
		end


	//read_pointer pointer

	always@(posedge M_AXIS_ACLK)
		begin
			if(!M_AXIS_ARESETN)
				begin
					read_pointer <= 0;
				end
			else
				if (read_pointer <= NUMBER_OF_COLS-1)
					begin
						if (tx_en)
							// read pointer is incremented after every read from the FIFO
							// when FIFO read signal is enabled.
							begin
								read_pointer <= read_pointer + 1;
							end
					end
			else if (read_pointer == NUMBER_OF_COLS)
				begin
					if(mst_exec_state == IDLE) begin
						read_pointer <= 0;
					end
				end
		end

	// tx done

	always@(posedge M_AXIS_ACLK) begin
		if(!M_AXIS_ARESETN) begin
			tx_done <= 1'b0;
		end else begin
			case (mst_exec_state)
				IDLE         : tx_done = 1'b0;
				INIT_COUNTER : tx_done = 1'b0;
				SEND_STREAM  : begin
					if (read_pointer <= NUMBER_OF_COLS-1) begin
						tx_done <= 1'b0;
					end else if (read_pointer == NUMBER_OF_COLS) begin
						// tx_done is asserted when NUMBER_OF_COLS numbers of streaming data
						// has been out.
						tx_done <= 1'b1;
					end
				end
				default : tx_done = 1'b0;
			endcase
		end
	end

	// row counter

	always@(posedge M_AXIS_ACLK) begin
		if(!M_AXIS_ARESETN) begin
			row_counter <= 0;
		end else begin
			if(row_counter <= NUMBER_OF_ROWS-1) begin
				if(axis_tlast) begin
					row_counter <= row_counter + 1;
				end
			end else if(row_counter == NUMBER_OF_ROWS) begin
				row_counter <= 0;
			end
		end
	end


	//FIFO read enable generation

	assign tx_en = M_AXIS_TREADY && axis_tvalid;

	// Streaming output data is read from FIFO
	// always @( posedge M_AXIS_ACLK )
	// 	begin
	// 		if(!M_AXIS_ARESETN)
	// 			begin
	// 				stream_data_out <= 1;
	// 			end
	// 		else if (tx_en)// && M_AXIS_TSTRB[byte_index]
	// 			begin
	assign stream_data_out = ((read_pointer >= 10 && read_pointer <= 20)||
		(read_pointer >= 30 && read_pointer <= 50)||
		(read_pointer >= 70 && read_pointer <= 80)||
		(read_pointer >= 90 && read_pointer <= 110)||
		(read_pointer >= 130 && read_pointer <= 140)||
		(read_pointer >= 150 && read_pointer <= 170)||
		(read_pointer >= 190 && read_pointer <= 200)||
		(read_pointer >= 210 && read_pointer <= 230))&&(row_counter >= 100)&&(row_counter <= 200)?255:0;
		// 		end
		// end

	// Add user logic here

	// User logic ends

endmodule
