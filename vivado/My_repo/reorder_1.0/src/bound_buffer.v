`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/19 22:47:50
// Design Name: 
// Module Name: bound_buffer
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


module bound_buffer (
	input  wire        aclk            ,
	input  wire        aresetn         ,
	// 上下边界
	input  wire [15:0] bound_y_min     ,
	input  wire        bound_y_min_we  ,
	input  wire [15:0] bound_y_max     ,
	input  wire        bound_y_max_we  ,
	// 左边界输入
	input  wire [ 2:0] bound_x_min_addr,
	input  wire [15:0] bound_x_min     ,
	input  wire        bound_x_min_we  ,
	// 右边界输入
	input  wire [ 2:0] bound_x_max_addr,
	input  wire [15:0] bound_x_max     ,
	input  wire        bound_x_max_we  ,
	// 控制信号
	input  wire        read            , // 读信号计数 m_tuser
	input  wire        clr             , // 清空 s_tuser
	// 输出
	output reg  [15:0] bound_y_min_o   ,
	output reg  [15:0] bound_y_max_o   ,
	output reg  [ 2:0] bound_x_addr_o  ,
	output reg  [15:0] bound_x_min_o   , // 左边界
	output reg  [15:0] bound_x_max_o     // 右边界
);

	localparam NUMBER_OF_CHAR = 8;

	localparam [1:0] IDLE = 2'b00,
	WE_MIN = 2'b01,
	WE_MAX = 2'b10;

	reg [1:0] we_state;

	(* ram_style = "block" *) reg [15:0] bound_x_min_buf [7:0];
	(* ram_style = "block" *) reg [15:0] bound_x_max_buf [7:0];
	reg [15:0] bound_x_min_buf_temp;
	reg [15:0] bound_x_max_buf_temp;
	reg [2:0]  bound_x_addr_temp;
	reg [15:0] bound_y_min_buf;
	reg [15:0] bound_y_max_buf;

	reg [2:0] counter;
	reg [2:0] counter_delay;
	reg [2:0] counter_delay_1;

	reg clr_delay;
	wire clr_raise;

	reg refresh_en;

	always @(posedge aclk) begin : proc_clr_delay
		if(~aresetn) begin
			clr_delay <= 0;
		end else begin
			clr_delay <= clr;
		end
	end

	assign clr_raise = (clr)&&(!clr_delay);

	always @(posedge aclk) begin : proc_state
		if(~aresetn) begin
			we_state <= IDLE;
		end else begin
			case (we_state)
				IDLE : begin 
					we_state <= WE_MIN;
				end
				WE_MIN : begin 
					if(bound_x_min_we) begin
						we_state <= WE_MAX;
					end else begin 
						we_state <= WE_MIN;
					end
				end
				WE_MAX : begin 
					if(bound_x_max_we) begin
						we_state <= IDLE;
					end else begin 
						we_state <= WE_MAX;
					end
				end
				default : we_state <= IDLE;
			endcase
		end
	end

	// temp
	always @(posedge aclk) begin
		if(~aresetn) begin
			bound_x_min_buf_temp <= 0;
			bound_x_max_buf_temp <= 0;
			bound_x_addr_temp <= 0;
			refresh_en <= 1'b0;
		end else begin
			case (we_state)
				IDLE : begin 
					refresh_en <= 1'b0;
				end
				WE_MIN : begin 
					if(bound_x_min_we) begin
						bound_x_min_buf_temp <= bound_x_min;
						bound_x_addr_temp <= bound_x_min_addr;
					end
				end
				WE_MAX : begin 
					if(bound_x_max_we) begin
						if(bound_x_max_addr == bound_x_addr_temp) begin
							bound_x_max_buf_temp <= bound_x_max;
							refresh_en <= 1'b1;
						end
					end
				end
			endcase
		end
	end

	always @(posedge aclk) begin : proc_bound_x_min_buf
		if(~aresetn) begin
			bound_x_min_buf[0] <= 0;
			bound_x_min_buf[1] <= 0;
			bound_x_min_buf[2] <= 0;
			bound_x_min_buf[3] <= 0;
			bound_x_min_buf[4] <= 0;
			bound_x_min_buf[5] <= 0;
			bound_x_min_buf[6] <= 0;
			bound_x_min_buf[7] <= 0;
		end else if(refresh_en) begin
			bound_x_min_buf[bound_x_addr_temp] <= bound_x_min_buf_temp;
		end
	end

	always @(posedge aclk) begin : proc_bound_x_max_buf
		if(~aresetn) begin
			bound_x_max_buf[0] <= 0;
			bound_x_max_buf[1] <= 0;
			bound_x_max_buf[2] <= 0;
			bound_x_max_buf[3] <= 0;
			bound_x_max_buf[4] <= 0;
			bound_x_max_buf[5] <= 0;
			bound_x_max_buf[6] <= 0;
			bound_x_max_buf[7] <= 0;
		end else if(refresh_en) begin
			bound_x_max_buf[bound_x_addr_temp] <= bound_x_max_buf_temp;
		end
	end

	always @(posedge aclk or negedge aresetn) begin : proc_bound_y_min_buf
		if(~aresetn) begin
			bound_y_min_buf <= 0;
		end else if(bound_y_min_we) begin
			bound_y_min_buf <= bound_y_min;
		end
	end

	always @(posedge aclk or negedge aresetn) begin : proc_bound_y_max_buf
		if(~aresetn) begin
			bound_y_max_buf <= 0;
		end else if(bound_y_max_we) begin
			bound_y_max_buf <= bound_y_max;
		end
	end

	always @(posedge aclk or negedge aresetn) begin : proc_counter
		if(~aresetn) begin
			counter <= 0;
			counter_delay <= 0;
			counter_delay_1 <= 0;
		end else begin
			if(clr_raise) begin
				counter <= 0;
			end else if(read) begin
				if(counter == NUMBER_OF_CHAR-1) begin
					// counter <= 0;
				end else begin
					counter <= counter + 1;
				end
				counter_delay <= counter;
				counter_delay_1 <= counter_delay;
			end
		end
	end

	always @(posedge aclk or negedge aresetn) begin : proc_bound_o
		if(~aresetn) begin
			bound_x_addr_o <= 0;
			bound_x_min_o <= 0;
			bound_x_max_o <= 0;
			bound_y_min_o <= 0;
			bound_y_max_o <= 0;
		end else begin
			bound_x_addr_o <= counter_delay;
			bound_x_min_o <= bound_x_min_buf[counter_delay];
			bound_x_max_o <= bound_x_max_buf[counter_delay];
			if(read) begin	
				bound_y_min_o <= bound_y_min_buf;
				bound_y_max_o <= bound_y_max_buf;
			end
		end
	end

endmodule
