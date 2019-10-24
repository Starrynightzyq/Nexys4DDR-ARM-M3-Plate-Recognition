`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/20 11:07:30
// Design Name: 
// Module Name: reorder_read
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reorder_read #(
	parameter integer NUMBER_OF_COLS = 640, // 640 cols
	parameter integer NUMBER_OF_ROWS = 480  // 480 rows
) (
	input  wire        aclk          ,
	input  wire        aresetn       ,
	// bound_buffer
	input  wire [ 2:0] bound_x_addr_i,
	input  wire [15:0] bound_x_min_i , // 左边界
	input  wire [15:0] bound_x_max_i , // 右边界
	input  wire [15:0] bound_y_min_i , // 上边界
	input  wire [15:0] bound_y_max_i , // 下边界
	// ram read
	output wire [18:0] ram_addr      ,
	input  wire        ram_data      ,
	// m axis signal
	output wire [15:0] m_axis_cols_o , // 列 x
	output wire [15:0] m_axis_rows_o , // 行 y
	output wire        m_axis_data_o , // 数据
	input  wire        m_axis_clr    , // 清空
	input  wire        m_axis_tx_en
);

	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_COLS' size of FIFO.
	localparam addr_bit_num = clogb2(NUMBER_OF_COLS*NUMBER_OF_ROWS);

	reg [addr_bit_num-1:0] addr_counter;

	always @(posedge aclk or negedge aresetn) begin : proc_addr_counter
		if(~aresetn) begin
			addr_counter <= 0;
		end else begin
			if(m_axis_clr) begin
				addr_counter <= bound_y_min_i * NUMBER_OF_COLS + bound_x_max_i;
			end else if(m_axis_tx_en) begin

				// addr_counter <= 
			end
			addr_counter <= addr_counter+1;
		end
	end

endmodule
