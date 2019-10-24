
`timescale 1 ns / 1 ps

module reorder_v1_0_M_AXIS #
(
	// Users to add parameters here
	parameter integer NUMBER_OF_COLS        = 640, // 640 cols
	parameter integer NUMBER_OF_ROWS        = 480, // 480 rows
	// User parameters ends
	// Do not modify the parameters beyond this line

	// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
	parameter integer C_M_AXIS_TDATA_WIDTH	= 8,
	// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
	parameter integer C_M_START_COUNT	= 32
)
(
	// Users to add ports here
	// bound_buffer
	input  wire        clr           ,
	output wire        bound_read    ,
	input  wire [ 2:0] bound_x_addr_i,
	input  wire [15:0] bound_x_min_i , // 左边界
	input  wire [15:0] bound_x_max_i , // 右边界
	input  wire [15:0] bound_y_min_i , // 上边界
	input  wire [15:0] bound_y_max_i , // 下边界
	// ram read
	output wire [18:0] ram_addr      ,
	input  wire        ram_data      ,
	// axis control
	output wire [15:0] axis_cols,
	output wire [15:0] axis_rows,
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
	// 
	localparam [1:0] ON_RESIZE = 2'b01, END_RESIZE = 2'b10;
	reg [1:0] resize_state;

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

	reg bound_read_delay = 0;
	reg bound_read_delay_1 = 0;

	reg [15:0] mutable_cols; // 列 x
	reg [15:0] mutable_rows; // 行 y

	reg [18:0]  ram_addr_reg;

	reg resize_en;

	wire axis_tlast_down; // 下降沿

	always @(posedge M_AXIS_ACLK) begin
		if(~M_AXIS_ARESETN) begin
			mutable_cols <= 100;
			mutable_rows <= 100;
		end else begin
			mutable_cols <= ((bound_x_max_i - bound_x_min_i + 1)>=10)?(bound_x_max_i - bound_x_min_i + 1):(10);
			mutable_rows <= ((bound_y_max_i - bound_y_min_i + 1)>=10)?(bound_y_max_i - bound_y_min_i + 1):(10);
		end
	end
	// assign mutable_cols = bound_x_max_i - bound_x_min_i + 1;
	// assign mutable_rows = bound_y_max_i - bound_y_min_i + 1;

	assign bound_read = ((mst_exec_state == IDLE)&&(row_counter == 0)&&(!clr))?1'b1:1'b0;
	// assign bound_read = (axis_tlast_delay && (row_counter == mutable_rows))||(resize_state == IDLE);

	assign ram_addr = ram_addr_reg + 1;

	// I/O Connections assignments

	assign M_AXIS_TVALID = axis_tvalid;
	assign M_AXIS_TDATA  = stream_data_out;
	assign M_AXIS_TLAST  = axis_tlast;
	assign M_AXIS_TSTRB  = {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};
	assign M_AXIS_TUSER  = axis_tuser;

	assign axis_tlast_down = (!axis_tlast)&&(axis_tlast_delay);

	always @(posedge M_AXIS_ACLK) begin
		bound_read_delay <= bound_read;
		bound_read_delay_1 <= bound_read_delay;
	end

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
					IDLE : begin
						// The slave starts accepting tdata when
						// there tvalid is asserted to mark the
						// presence of valid streaming data
						//if ( count == 0 )
						//  begin
						if(clr) begin
							mst_exec_state <= IDLE;
						end else begin
							mst_exec_state <= INIT_COUNTER;
						end
						count          <= 0;
					//  end
					//else
					//  begin
					//    mst_exec_state  <= IDLE;
					end

					INIT_COUNTER :
						// The slave starts accepting tdata when
						// there tvalid is asserted to mark the
						// presence of valid streaming data
						if(clr) begin
							mst_exec_state <= IDLE;
						end else if ( count == C_M_START_COUNT - 1 ) begin
							mst_exec_state <= SEND_STREAM;
						end else begin
							count          <= count + 1;
							mst_exec_state <= INIT_COUNTER;
						end

					SEND_STREAM :
						// The example design streaming master functionality starts
						// when the master drives output tdata from the FIFO and the slave
						// has finished storing the S_AXIS_TDATA
						if(clr) begin
							mst_exec_state <= IDLE;
						end else if (tx_done) begin
							mst_exec_state <= IDLE;
							count          <= 0;
						end else begin
							mst_exec_state <= SEND_STREAM;
						end
				endcase
		end


	//tvalid generation
	//axis_tvalid is asserted when the control state machine's state is SEND_STREAM and
	//number of output streaming data is less than the mutable_cols.
	assign axis_tvalid = ((mst_exec_state == SEND_STREAM) && (read_pointer < mutable_cols)) && resize_en;

	// AXI tlast generation
	// axis_tlast is asserted number of output streaming data is mutable_cols-1
	// (0 to mutable_cols-1)
	assign axis_tlast = (read_pointer == mutable_cols-1);
	assign axis_tuser = ((row_counter == 0)&&(mst_exec_state == SEND_STREAM)&&(read_pointer == 0)&&axis_tvalid);


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

	// ram addr
	always @(posedge M_AXIS_ACLK) begin : proc_ram_addr
		if(~M_AXIS_ARESETN) begin
			ram_addr_reg <= bound_y_min_i*NUMBER_OF_COLS + bound_x_min_i;
		end else begin
			if(bound_read_delay_1) begin
				ram_addr_reg <= bound_y_min_i*NUMBER_OF_COLS + bound_x_min_i;
			end else if(axis_tlast_down) begin
				ram_addr_reg <= ram_addr_reg + NUMBER_OF_COLS - mutable_cols + 1;
			end else if(tx_en && (read_pointer < mutable_cols-1)) begin
				ram_addr_reg <= ram_addr_reg + 1;
			end
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
				if (read_pointer <= mutable_cols-1)
					begin
						if (tx_en)
							// read pointer is incremented after every read from the FIFO
							// when FIFO read signal is enabled.
							begin
								read_pointer <= read_pointer + 1;
							end
					end
			else if (read_pointer == mutable_cols)
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
					if (read_pointer <= mutable_cols-1) begin
						tx_done <= 1'b0;
					end else if (read_pointer == mutable_cols) begin
						// tx_done is asserted when mutable_cols numbers of streaming data
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
			if(row_counter <= mutable_rows-1) begin
				if(axis_tlast) begin
					row_counter <= row_counter + 1;
				end
			end else if((row_counter == mutable_rows)||(clr)) begin
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
	assign stream_data_out = {8{ram_data}};
		// 		end
		// end

	// Add user logic here
	always @(posedge M_AXIS_ACLK) begin : proc_resize_state
		if(~M_AXIS_ARESETN) begin
			resize_state <= 0;
			resize_en <= 1'b0;
		end else begin
			case (resize_state)
				IDLE : begin 
					resize_state <= ON_RESIZE;
					resize_en <= 1'b0;
				end
				ON_RESIZE : begin 
					if((bound_x_addr_i == 7) && bound_read_delay_1) begin
						resize_state <= END_RESIZE;
					end else begin 
						resize_state <= ON_RESIZE;
					end
					resize_en <= 1'b1;
				end
				END_RESIZE : begin 
					if(clr) begin
						resize_state <= IDLE;
					end else begin 
						resize_state <= END_RESIZE;
					end
					resize_en <= 1'b0;
				end
				default : resize_state <= IDLE;
			endcase
		end
	end

	assign axis_cols = mutable_cols;
	assign axis_rows = mutable_rows;

	// User logic ends

endmodule
