
`timescale 1 ns / 1 ps

	module reorder_v1_0 #
	(
		// Users to add parameters here
		parameter integer NUMBER_OF_COLS        = 640, // 640 cols
		parameter integer NUMBER_OF_ROWS        = 480, // 480 rows
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXIS
		parameter integer C_S_AXIS_TDATA_WIDTH	= 8,

		// Parameters of Axi Master Bus Interface M_AXIS
		parameter integer C_M_AXIS_TDATA_WIDTH	= 8,
		parameter integer C_M_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here
		// 每个字符的左右边界
		input wire [2:0]  bound_x_min_addr,
		input wire [15:0] bound_x_min,
		input wire        bound_x_min_we,
		input wire [2:0]  bound_x_max_addr,
		input wire [15:0] bound_x_max,
		input wire        bound_x_max_we,
		// 每个字符的上下边界
		input wire [15:0] bound_y_min,
		input wire        bound_y_min_we,
		input wire [15:0] bound_y_max,
		input wire        bound_y_max_we,
		// next axis control
		output wire [15:0] axis_cols,
		output wire [15:0] axis_rows,
		// 字符地址
		output wire [2:0] char_addr,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S_AXIS
		input wire  aclk,
		input wire  aresetn,

		output wire  s_axis_tready,
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] s_axis_tstrb,
		input wire  s_axis_tlast,
		input wire s_axis_tuser,
		input wire  s_axis_tvalid,

		// Ports of Axi Master Bus Interface M_AXIS
		// input wire  m_axis_aclk,
		// input wire  m_axis_aresetn,
		output wire  m_axis_tvalid,
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] m_axis_tstrb,
		output wire  m_axis_tlast,
		output wire m_axis_tuser,
		input wire  m_axis_tready
	);

	wire [18:0] ram_addr_s;
	wire ram_d_s;
	wire ram_we_s;
	wire [18 : 0] ram_addr_m;
	wire ram_d_m;

	wire bound_read_m;
	wire [ 2:0] bound_x_addr_m;
	wire [15:0] bound_x_min_m; // 左边界
	wire [15:0] bound_x_max_m; // 右边界
	wire [15:0] bound_y_min_m; // 上边界
	wire [15:0] bound_y_max_m; // 下边界

// Instantiation of Axi Bus Interface S_AXIS
	reorder_v1_0_S_AXIS # ( 
		.NUMBER_OF_COLS      (NUMBER_OF_COLS),
		.NUMBER_OF_ROWS      (NUMBER_OF_ROWS),
		.C_S_AXIS_TDATA_WIDTH(C_S_AXIS_TDATA_WIDTH)
	) reorder_v1_0_S_AXIS_inst (
		.ram_addr_o    (ram_addr_s),
		.ram_d_o       (ram_d_s),
		.ram_we_o      (ram_we_s),

		.S_AXIS_ACLK(aclk),
		.S_AXIS_ARESETN(aresetn),
		.S_AXIS_TREADY(s_axis_tready),
		.S_AXIS_TDATA(s_axis_tdata),
		.S_AXIS_TSTRB(s_axis_tstrb),
		.S_AXIS_TLAST(s_axis_tlast),
		.S_AXIS_TUSER(s_axis_tuser),
		.S_AXIS_TVALID(s_axis_tvalid)
	);

// Instantiation of Axi Bus Interface M_AXIS
	reorder_v1_0_M_AXIS # ( 
		.NUMBER_OF_COLS      (NUMBER_OF_COLS),
		.NUMBER_OF_ROWS      (NUMBER_OF_ROWS),
		.C_M_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
		.C_M_START_COUNT(C_M_AXIS_START_COUNT)
	) reorder_v1_0_M_AXIS_inst (
		.clr(s_axis_tuser),
		.bound_read(bound_read_m),
		.bound_x_addr_i(bound_x_addr_m),
		.bound_x_min_i(bound_x_min_m),
		.bound_x_max_i(bound_x_max_m),
		.bound_y_min_i(bound_y_min_m),
		.bound_y_max_i(bound_y_max_m),
		.ram_addr(ram_addr_m),
		.ram_data(ram_d_m),
		.axis_cols(axis_cols),
		.axis_rows(axis_rows),
		.M_AXIS_ACLK(aclk),
		.M_AXIS_ARESETN(aresetn),
		.M_AXIS_TVALID(m_axis_tvalid),
		.M_AXIS_TDATA(m_axis_tdata),
		.M_AXIS_TSTRB(m_axis_tstrb),
		.M_AXIS_TLAST(m_axis_tlast),
		.M_AXIS_TUSER  (m_axis_tuser),
		.M_AXIS_TREADY(m_axis_tready)
	);

	// Add user logic here
	blk_mem_gen_0 blk_mem_inst (
		.clka (aclk ), // input wire clka
		.wea  (ram_we_s  ), // input wire [0 : 0] wea
		.addra(ram_addr_s), // input wire [18 : 0] addra
		.dina (ram_d_s ), // input wire [0 : 0] dina
		.clkb (aclk ), // input wire clkb
		.addrb(ram_addr_m), // input wire [18 : 0] addrb
		.doutb(ram_d_m)  // output wire [0 : 0] doutb
	);

	bound_buffer inst_bound_buffer (
		.aclk            (aclk            ),
		.aresetn         (aresetn         ),
		.bound_y_min     (bound_y_min     ),
		.bound_y_min_we  (bound_y_min_we  ),
		.bound_y_max     (bound_y_max     ),
		.bound_y_max_we  (bound_y_max_we  ),
		.bound_x_min_addr(bound_x_min_addr),
		.bound_x_min     (bound_x_min     ),
		.bound_x_min_we  (bound_x_min_we  ),
		.bound_x_max_addr(bound_x_max_addr),
		.bound_x_max     (bound_x_max     ),
		.bound_x_max_we  (bound_x_max_we  ),
		.read            (bound_read_m    ), // m_tuser
		.clr             (s_axis_tuser    ), // s_tuser
		.bound_y_min_o   (bound_y_min_m   ),
		.bound_y_max_o   (bound_y_max_m   ),
		.bound_x_addr_o  (bound_x_addr_m  ),
		.bound_x_min_o   (bound_x_min_m   ),
		.bound_x_max_o   (bound_x_max_m   )
	);

	assign char_addr = bound_x_addr_m;

	// User logic ends

	endmodule
