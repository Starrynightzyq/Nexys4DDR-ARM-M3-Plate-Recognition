`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/30 20:12:49
// Design Name: 
// Module Name: OV_Sensor_ML
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
// 外部信号接口说明：
// CLK_i ：为输入时钟，通常接24MHZ 或者25MHZ
// Cmos_xclk_o:摄像头工作，通常直接把CLK_i 连接到cmos_xclk_o
// Cmos_vsyns_i：摄像头场同步输入上升沿代表场同步开始
// Cmos_href_i:摄像头行同步输入高电平代表行数据有效
// Cmos_data[7:0]:摄像头数据输入
// Hs_o:采集OV_Sensor_ML IP 输出的行数据有效
// Vs_o:采集OV_Sensor_ML IP 输出的场同步信号
// Vid_clk_ce:此信号用于和vid_in IP 的时钟同步(由于OV_Sensor_ML IP 是每两个时钟输
// 出一次rgb[23:0]的图像数据，因此需要通过Vid_clk_ce 对时钟频率进行同步，有了这个信
// 号，可以解决输入采集IP 和vid_in IP 数据接口之间的同步问题).
//////////////////////////////////////////////////////////////////////////////////


module OV_Sensor_ML#(
	parameter RBG_CHANGE = 1
	)(
	input CLK_i,
	//---------------------------- CMOS sensor hardware interface --------------------------/
	input cmos_vsync_i,//cmos vsync
	input cmos_href_i, //cmos hsync refrence
	input cmos_pclk_i, //cmos pxiel clock
	output cmos_xclk_o, //cmos externl clock
	input[7:0]cmos_data_i, //cmos data
	//video signal
	output vid_hsync,//hs signal.
	output vid_vsync,//vs signal.
	// output de_o,//data enable.
	output [23:0] vid_data,//data output,
	output vid_clk_ce,
	output vid_active_video
    );

	//----------------------视频输出解码模块---------------------------//
	wire [15:0]rgb_o_r;
	wire [23:0] rgb_temp;
	reg [7:0]cmos_data_r;
	reg cmos_href_r;
	reg cmos_vsync_r;

	always@(posedge cmos_pclk_i) begin
		cmos_data_r <= cmos_data_i;
		cmos_href_r <= cmos_href_i;
		cmos_vsync_r<= cmos_vsync_i;
	end
	//assign rgb_o = 24'b11111111_00000000_11111111;
	cmos_decode cmos_decode_u0(
		//system signal.
		.cmos_clk_i(CLK_i),//cmos senseor clock.
		.rst_n_i(RESETn_i2c),//system reset.active low.
		//cmos sensor hardware interface.
		.cmos_pclk_i(cmos_pclk_i),//(cmos_pclk),//input pixel clock.
		.cmos_href_i(cmos_href_r),//(cmos_href),//input pixel hs signal.
		.cmos_vsync_i(cmos_vsync_r),//(cmos_vsync),//input pixel vs signal.
		.cmos_data_i(cmos_data_r),//(cmos_data),//data.
		.cmos_xclk_o(cmos_xclk_o),//(cmos_xclk),//output clock to cmos sensor.
		//user interface.
		.hs_o(vid_hsync),//hs signal.
		.vs_o(vid_vsync),//vs signal.
		// .de_o(de_o),//data enable.
		.rgb565_o(rgb_o_r),//data output
		.vid_clk_ce(vid_clk_ce)
		);

	count_reset #(
		.num(20'hffff0)
		)(
		.clk_i(CLK_i),
		.rst_o(RESETn_i2c)
		);

	assign rgb_temp = {rgb_o_r[15:11], rgb_o_r[15:13], rgb_o_r[10:5], rgb_o_r[10:9], rgb_o_r[4:0], rgb_o_r[4:2]};	//rgb

	generate
		genvar i;
		if (RBG_CHANGE) begin
			rgb_change rgb_change_inst(.rgb_in(rgb_temp), .rgb_out(vid_data));
		end else begin
			assign vid_data = rgb_temp;
		end
	endgenerate

	assign vid_active_video = vid_hsync;


endmodule
