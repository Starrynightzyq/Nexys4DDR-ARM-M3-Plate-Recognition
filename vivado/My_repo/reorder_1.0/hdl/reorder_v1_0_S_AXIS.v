
`timescale 1 ns / 1 ps

	module reorder_v1_0_S_AXIS #
	(
		// Users to add parameters here
		parameter integer NUMBER_OF_COLS        = 8, // 640 cols
		parameter integer NUMBER_OF_ROWS        = 4, // 480 rows
		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 8
	)
	(
		// Users to add ports here
		output reg [18:0] ram_addr_o,
		output reg ram_d_o,
		output reg ram_we_o,
		// User ports ends
		// Do not modify the ports beyond this line

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		output wire  S_AXIS_TREADY,
		// Data in
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// Byte qualifier
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
		// Indicates boundary of last packet
		input wire  S_AXIS_TLAST,
		// USER indicates the start of a frame, it designates the first pixel of a frame
		input wire S_AXIS_TUSER,
		// Data is in valid
		input wire  S_AXIS_TVALID
	);
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

	// Total number of input data.
	// localparam NUMBER_OF_COLS  = 8; // 640 cols
	// localparam NUMBER_OF_ROWS         = 4; // 480 rows

	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_COLS' size of FIFO.
	localparam bit_num  = clogb2(NUMBER_OF_COLS);
	localparam row_bit_num = clogb2(NUMBER_OF_ROWS);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [1:0] IDLE = 1'b0,        // This is the initial/idle state 

	                WRITE_FIFO  = 1'b1; // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
	wire  	axis_tready;
	// State variable
	reg mst_exec_state;  
	// FIFO implementation signals
	genvar byte_index;     
	// FIFO write enable
	wire fifo_wren;
	// FIFO full flag
	reg fifo_full_flag;
	// FIFO write pointer
	reg [bit_num-1:0] write_pointer;
	// row counter
	reg [row_bit_num-1:0] row_counter;
	// sink has accepted all the streaming data and stored in FIFO
	(*mark_debug = "true"*)reg writes_done;
	  reg writes_done_delay = 0;
	  wire writes_done_rise;
	// I/O Connections assignments

	assign S_AXIS_TREADY	= axis_tready;

	always @(posedge S_AXIS_ACLK) begin
		writes_done_delay <= writes_done;
	end
	assign writes_done_rise = (writes_done)&&(!writes_done_delay);

	// Control state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (!S_AXIS_ARESETN) 
	  // Synchronous reset (active low)
	    begin
	      mst_exec_state <= IDLE;
	    end  
	  else
	    case (mst_exec_state)
	      IDLE: 
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	          if (S_AXIS_TVALID)
	            begin
	              mst_exec_state <= WRITE_FIFO;
	            end
	          else
	            begin
	              mst_exec_state <= IDLE;
	            end
	      WRITE_FIFO: 
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if (writes_done)
	          begin
	            mst_exec_state <= IDLE;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
	            mst_exec_state <= WRITE_FIFO;
	          end

	    endcase
	end
	// AXI Streaming Sink 
	// 
	// The example design sink is always ready to accept the S_AXIS_TDATA  until
	// the FIFO is not filled with NUMBER_OF_COLS number of input words.
	assign axis_tready = ((mst_exec_state == WRITE_FIFO) && (write_pointer <= NUMBER_OF_COLS-1));

	// write_pointer
	always@(posedge S_AXIS_ACLK) begin
		if(!S_AXIS_ARESETN) begin
			write_pointer <= 0;
		end else begin
			if (write_pointer <= NUMBER_OF_COLS-1) begin
				if (fifo_wren) begin
					// write pointer is incremented after every write to the FIFO
					// when FIFO write signal is enabled.
					write_pointer <= write_pointer + 1;
				end

				// if (write_pointer == NUMBER_OF_COLS-1) begin
				// 	// reads_done is asserted when NUMBER_OF_COLS numbers of streaming data
				// 	// has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
				// 	if(mst_exec_state == IDLE) begin
				// 		write_pointer <= 0;
				// 	end
				// end
			end

			if(mst_exec_state == IDLE) begin
				write_pointer <= 0;
			end
		end
	end

	// writes_done
	always@(posedge S_AXIS_ACLK) begin
		if(!S_AXIS_ARESETN)
			begin
				writes_done <= 1'b0;
			end
		else begin
			case (mst_exec_state)
				IDLE       : writes_done <= 1'b0;
				WRITE_FIFO : begin
					if (write_pointer <= NUMBER_OF_COLS-1) begin
						if (fifo_wren) begin
							// when FIFO write signal is enabled.
							writes_done <= 1'b0;
						end
						if ((write_pointer == NUMBER_OF_COLS-1)) begin // || S_AXIS_TLAST
							// reads_done is asserted when NUMBER_OF_COLS numbers of streaming data
							// has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
							writes_done <= 1'b1;
						end
					end
				end
				default : writes_done <= 1'b0;
			endcase
		end
	end

	// row_counter
	always@(posedge S_AXIS_ACLK) begin
		if(!S_AXIS_ARESETN)
			begin
				row_counter <= 0;
			end
		else begin
			if(S_AXIS_TUSER || (row_counter == NUMBER_OF_ROWS)) begin
				row_counter <= 0;
			end else if(writes_done_rise) begin // S_AXIS_TLAST
				row_counter <= row_counter + 1;
			end
		end
	end

	// FIFO write enable generation
	assign fifo_wren = S_AXIS_TVALID && axis_tready;

	// FIFO Implementation
	generate 
	  for(byte_index=0; byte_index<= (C_S_AXIS_TDATA_WIDTH/8-1); byte_index=byte_index+1)
	  begin:FIFO_GEN

	    reg  [(C_S_AXIS_TDATA_WIDTH/4)-1:0] stream_data_fifo [0 : NUMBER_OF_COLS-1];

	    // Streaming input data is stored in FIFO

	    always @( posedge S_AXIS_ACLK )
	    begin
	      if (fifo_wren)// && S_AXIS_TSTRB[byte_index])
	        begin
	          stream_data_fifo[write_pointer] <= S_AXIS_TDATA[(byte_index*8+7) -: 8];
	        end  
	    end  
	  end		
	endgenerate

	// Add user logic here
	always@(posedge S_AXIS_ACLK) begin
		if(!S_AXIS_ARESETN) begin
			ram_d_o    <= 0;
			ram_we_o   <= 0;
			ram_addr_o <= 0;
		end else begin
			if(fifo_wren) begin
				ram_d_o    <= S_AXIS_TDATA[0];
				ram_addr_o <= row_counter*NUMBER_OF_COLS + write_pointer;
			end
			ram_we_o   <= fifo_wren;
		end
	end

	// ram_d_o <= &S_AXIS_TDATA;
	// ram_we_o <= fifo_wren;
	// ram_addr_o <= row_counter*NUMBER_OF_COLS + write_pointer;

	// User logic ends

	endmodule
