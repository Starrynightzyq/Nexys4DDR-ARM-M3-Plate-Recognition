`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/01/07 15:34:21
// Design Name: 
// Module Name: rgb_change
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


module rgb_change(
    input rgb_in,
    output rgb_out
    );
    wire[23:0]rgb_in;
    wire[23:0]rgb_out;
    assign rgb_out[7:0]=rgb_in[15:8];
    assign rgb_out[15:8]=rgb_in[7:0];
    assign rgb_out[23:16]=rgb_in[23:16];
endmodule
