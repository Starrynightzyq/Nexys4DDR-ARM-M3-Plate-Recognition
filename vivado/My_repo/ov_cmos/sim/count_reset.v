`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/30 20:32:27
// Design Name: 
// Module Name: count_reset
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


module count_reset#
	(
	parameter[19:0]num = 20'hffff0
	)(
	input clk_i,
	output rst_o
	);

	reg[19:0] cnt = 20'd0;
	reg rst_d0;
	
	/*count for clock*/
	always@(posedge clk_i) begin
		cnt <= ( cnt <= num)?( cnt + 20'd1 ):num;
	end

	/*generate output signal*/
	always@(posedge clk_i) begin
		rst_d0 <= ( cnt >= num)?1'b1:1'b0;
	end

	assign rst_o = rst_d0;

endmodule
