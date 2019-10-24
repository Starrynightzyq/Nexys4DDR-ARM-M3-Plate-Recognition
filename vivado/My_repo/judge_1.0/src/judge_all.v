`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/23 13:00:11
// Design Name: 
// Module Name: judge_all
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


module judge_all #(
	parameter [0:0] ALL_CHAR = 0
	)(
	input             clk           ,
	input             rst_n         ,
	/* 控制信号 */
	input  [    15:0] max_diff      , // 最大误差值
	input  [     3:0] min_continue  , // 最小连续
	input  [     7:0] min_counter   , // 最小计数值
	/* input signals */
	(*mark_debug = "true"*) input  [ 7*4-1:0] char_index_c  , // 识别到的数字*8
	input  [7*16-1:0] char_diff_c   , // 误差*8
	input             char_valid_c  , //
	/* output signals */
	(*mark_debug = "true"*) output reg [ 7*4-1:0] char_index_co  , // 识别到的数字*8
	output wire           char_valid_co    // 一张车欧识别完成的信号
    );

	localparam IDLE = 2'b0;
	localparam COUNT = 2'b1;
	localparam DONE = 2'h2;

	reg count_done = 0; // 达到最小计数值
	reg count_continue_done = 0; // 达到最小连续计数值

	(*mark_debug = "true"*) reg [7*4-1:0] char_index_is_delay1 = 'h0;
	(*mark_debug = "true"*) reg [7*4-1:0] char_index_is_delay2 = 'h0;

	reg [3:0] counter_continue;
	reg recognize_done;

	/* 状态机 */
	reg [1:0] state_reg;

	wire [ 7*4-1:0] char_index_now;
	reg [ 7*4-1:0] char_index_last;

generate
	if(ALL_CHAR) begin
		assign char_index_now = char_index_c;
	end else begin 
		assign char_index_now = {char_index_c[7*4-1:2*4], 8'b0};
	end
endgenerate

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin 
			char_index_is_delay1 <= 0;
			char_index_is_delay2 <= 0;
		end else if(char_valid_c) begin
			char_index_is_delay1 <= char_index_c;
			char_index_is_delay2 <= char_index_is_delay1;
		end
	end

	always @(posedge clk or negedge rst_n) begin : proc_state_reg
		if(~rst_n) begin
			state_reg <= 0;
		end else begin
			case (state_reg)
				IDLE : begin 
					state_reg <= COUNT;
				end
				COUNT : begin 
					if(count_done || count_continue_done) begin
						state_reg <= DONE;
					end else begin 
						state_reg <= COUNT;
					end
				end
				DONE : begin 
					state_reg <= IDLE;
				end
				default : state_reg <= IDLE;
			endcase
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			counter_continue <= 0;
			char_index_co <= 0;
			count_continue_done <= 0;
			recognize_done <= 0;
		end else begin
			case (state_reg)
				IDLE : begin 
					counter_continue <= 0;
					count_continue_done <= 1'b0;
					recognize_done <= 1'b0;
				end
				COUNT : begin 
					if(char_valid_c) begin
						if(counter_continue < min_continue) begin
							if(char_index_last == char_index_now) begin
								char_index_last <= char_index_now;
								counter_continue <= counter_continue + 1;
							end else begin 
								char_index_last <= char_index_now;
								counter_continue <= 0;
							end
							count_continue_done <= 1'b0;
						end else begin 
							count_continue_done <= 1'b1;
							counter_continue <= 0;
						end
					end
					recognize_done <= 1'b0;
				end
				DONE : begin 
					counter_continue <= 0;
					count_continue_done <= 1'b0;
					recognize_done <= 1'b1;
					char_index_co <= char_index_is_delay2;
				end
				default : begin 
					counter_continue <= 0;
					count_continue_done <= 1'b0;
					recognize_done <= 1'b0;
				end
			endcase
		end
	end

	assign char_valid_co = recognize_done;

endmodule
