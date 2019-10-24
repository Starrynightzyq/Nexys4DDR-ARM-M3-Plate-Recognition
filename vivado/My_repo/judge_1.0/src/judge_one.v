`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/12 21:10:25
// Design Name: 
// Module Name: judge_one
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


module judge_one (
	input               clk           ,
	input               rst_n         ,
	/* input signals */
	input      [ 4-1:0] char_index    , // 识别到的数字
	input      [16-1:0] char_diff     , // 误差
	input               char_valid    , //
	/* 控制信号 */
	input      [  15:0] max_diff      , // 最大误差值
	input      [   3:0] min_continue  , // 最小连续
	input      [   7:0] min_counter   , // 最小计数值
	input               all_done      , // 一张车牌中所有字符识别完成
	/* output signals */
	output reg [ 4-1:0] char_index_o  , // 识别到的数字
	output reg          recognize_done  // 一个字符识别完成的信号
);

	localparam IDLE = 2'b0;
	localparam COUNT = 2'b1;
	localparam DONE = 2'h2;

	/* 状态机 */
	reg [1:0] state_reg         ;
	reg [1:0] state_next        ;
	
	reg [3:0] char_last         ; // 上一次的字符值
	reg [3:0] counter_continue      ; // 连续小于最大误差计数器，当 counter_continue == min_continue ,识别完成
	reg [7:0] counter_char[0:10]; // 字符统计，当某个字符先达到 min_counter, 识别完成

	reg count_done = 0; // 达到最小计数值
	reg count_continue_done = 0; // 达到最小连续计数值

	reg done_times = 0;

	always @(posedge clk or negedge rst_n) begin : proc_state_reg
		if(~rst_n) begin
			state_reg <= IDLE;
		end else begin
			state_reg <= state_next;
		end
	end

	always @(*) begin : proc_state_next
		state_next = state_reg;
		case (state_reg)
			IDLE : begin 
				state_next = COUNT;
				done_times = 0;
			end
			COUNT : begin 
				if(count_done || count_continue_done) begin
					state_next = DONE;
				end else begin
					state_next = COUNT;
				end
			end
			DONE : begin 
				if(all_done) begin
					state_next = IDLE;
				end else begin 
					state_next = COUNT;
				end
				done_times = 1;
			end
			default : state_next = IDLE;
		endcase
	end

	always @(posedge clk or negedge rst_n) begin : proc_output
		if(~rst_n) begin

		end else begin
			case (state_reg)
				IDLE : begin 
					count_done <= 1'b0;
					count_continue_done <= 1'b0;
					counter_continue <= 'b0;
					recognize_done <= 1'b0;
					counter_char[0] <= 'b0;
					counter_char[1] <= 'b0;
					counter_char[2] <= 'b0;
					counter_char[3] <= 'b0;
					counter_char[4] <= 'b0;
					counter_char[5] <= 'b0;
					counter_char[6] <= 'b0;
					counter_char[7] <= 'b0;
					counter_char[8] <= 'b0;
					counter_char[9] <= 'b0;
					counter_char[10] <= 'b0;
				end
				COUNT : begin 
					if(char_valid) begin
						// 处理非连续情况
						if(counter_char[char_index] < min_counter) begin
							count_done <= 1'b0;
							counter_char[char_index] <= counter_char[char_index] + 1'b1;
						end else begin
							count_done <= 1'b1;
							counter_char[char_index] <= 'b0;
							char_index_o <= char_index;
						end
						// 处理连续情况
						if(char_diff < max_diff) begin
							if(char_index == char_last) begin
								if(counter_continue < min_continue) begin
									counter_continue <= counter_continue + 1'b1;
									count_continue_done <= 1'b0;
								end else begin
									counter_continue <= 'b0;
									count_continue_done <= 1'b1;
									char_index_o <= char_index;
								end
							end else begin
								counter_continue <= 'b1;
								char_last <= char_index;
								count_continue_done <= 1'b0;
							end
						end else begin
							counter_continue <= 'b0;
							char_last <= char_index;
							count_continue_done <= 1'b0;
						end
					end
					if(done_times) begin
						recognize_done <= 1'b1;
					end else begin 
						recognize_done <= 1'b0;
					end
				end
				DONE : begin
					count_done <= 1'b0;
					count_continue_done <= 1'b0;
					counter_continue <= 'b0;
					recognize_done <= 1'b1;
					counter_char[0] <= 'b0;
					counter_char[1] <= 'b0;
					counter_char[2] <= 'b0;
					counter_char[3] <= 'b0;
					counter_char[4] <= 'b0;
					counter_char[5] <= 'b0;
					counter_char[6] <= 'b0;
					counter_char[7] <= 'b0;
					counter_char[8] <= 'b0;
					counter_char[9] <= 'b0;
					counter_char[10] <= 'b0;
				end
			endcase
		end
	end

endmodule
