
`timescale 1ns/1ps

module tb_reorder_v1_0 (); /* this is automatically generated */

	logic rstb;
	logic srst;
	logic clk;

	// clock
	initial begin
		clk = '0;
		forever #(0.5) clk = ~clk;
	end

	// reset
	initial begin
		rstb <= '0;
		srst <= '0;
		#20
		rstb <= '1;
		repeat (5) @(posedge clk);
		srst <= '1;
		repeat (1) @(posedge clk);
		srst <= '0;
	end

	// (*NOTE*) replace reset, clock, others

	parameter integer NUMBER_OF_COLS       = 640;
	parameter integer NUMBER_OF_ROWS       = 480;
	parameter integer C_S_AXIS_TDATA_WIDTH = 8;
	parameter integer C_M_AXIS_TDATA_WIDTH = 8;
	parameter integer C_M_AXIS_START_COUNT = 32;

	logic                            [2:0] bound_x_min_addr;
	logic                           [15:0] bound_x_min;
	logic                                  bound_x_min_we;
	logic                            [2:0] bound_x_max_addr;
	logic                           [15:0] bound_x_max;
	logic                                  bound_x_max_we;
	logic                           [15:0] bound_y_min;
	logic                                  bound_y_min_we;
	logic                           [15:0] bound_y_max;
	logic                                  bound_y_max_we;
	logic                                  aclk;
	logic                                  aresetn;
	logic                                  s_axis_tready;
	logic     [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata;
	logic [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] s_axis_tstrb;
	logic                                  s_axis_tlast;
	logic                                  s_axis_tuser;
	logic                                  s_axis_tvalid;
	logic                                  m_axis_tvalid;
	logic     [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata;
	logic [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] m_axis_tstrb;
	logic                                  m_axis_tlast;
	logic                                  m_axis_tuser;
	logic                                  m_axis_tready;

	logic                                  MEX_AXIS_ACLK;
	logic                                  MEX_AXIS_ARESETN;
	logic                                  MEX_AXIS_TVALID;
	logic     [C_M_AXIS_TDATA_WIDTH-1 : 0] MEX_AXIS_TDATA;
	logic [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] MEX_AXIS_TSTRB;
	logic                                  MEX_AXIS_TLAST;
	logic                                  MEX_AXIS_TUSER;
	logic                                  MEX_AXIS_TREADY;

	// logic [2:0]  bound_min_addr;
	// logic [15:0] bound_min_d;
	// logic        bound_min_we;
	// logic [2:0]  bound_max_addr;
	// logic [15:0] bound_max_d;
	// logic        bound_max_we;

	assign aclk = clk;
	assign MEX_AXIS_ACLK = clk;

	assign aresetn = ~srst;
	assign MEX_AXIS_ARESETN = ~srst;

	assign MEX_AXIS_TREADY = s_axis_tready;
	assign s_axis_tdata = MEX_AXIS_TDATA;
	assign s_axis_tstrb = MEX_AXIS_TSTRB;
	assign s_axis_tlast = MEX_AXIS_TLAST;
	assign s_axis_tuser = MEX_AXIS_TUSER;
	assign s_axis_tvalid = MEX_AXIS_TVALID;

	assign m_axis_tready = 1'b1;

	M_AXIS_EX #(
			.NUMBER_OF_COLS      (NUMBER_OF_COLS),
			.NUMBER_OF_ROWS      (NUMBER_OF_ROWS),
			.C_M_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
			.C_M_START_COUNT(C_M_AXIS_START_COUNT)
		) inst_M_AXIS_EX (
			.M_AXIS_ACLK    (MEX_AXIS_ACLK),
			.M_AXIS_ARESETN (MEX_AXIS_ARESETN),
			.M_AXIS_TVALID  (MEX_AXIS_TVALID),
			.M_AXIS_TDATA   (MEX_AXIS_TDATA),
			.M_AXIS_TSTRB   (MEX_AXIS_TSTRB),
			.M_AXIS_TLAST   (MEX_AXIS_TLAST),
			.M_AXIS_TUSER   (MEX_AXIS_TUSER),
			.M_AXIS_TREADY  (MEX_AXIS_TREADY)
		);
	reorder_v1_0 #(
			.NUMBER_OF_COLS(NUMBER_OF_COLS),
			.NUMBER_OF_ROWS(NUMBER_OF_ROWS),
			.C_S_AXIS_TDATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
			.C_M_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
			.C_M_AXIS_START_COUNT(C_M_AXIS_START_COUNT)
		) inst_reorder_v1_0 (
			.bound_x_min_addr (bound_x_min_addr),
			.bound_x_min      (bound_x_min),
			.bound_x_min_we   (bound_x_min_we),
			.bound_x_max_addr (bound_x_max_addr),
			.bound_x_max      (bound_x_max),
			.bound_x_max_we   (bound_x_max_we),
			.bound_y_min      (bound_y_min),
			.bound_y_min_we   (bound_y_min_we),
			.bound_y_max      (bound_y_max),
			.bound_y_max_we   (bound_y_max_we),
			.aclk             (aclk),
			.aresetn          (aresetn),
			.s_axis_tready    (s_axis_tready),
			.s_axis_tdata     (s_axis_tdata),
			.s_axis_tstrb     (s_axis_tstrb),
			.s_axis_tlast     (s_axis_tlast),
			.s_axis_tuser     (s_axis_tuser),
			.s_axis_tvalid    (s_axis_tvalid),
			.m_axis_tvalid    (m_axis_tvalid),
			.m_axis_tdata     (m_axis_tdata),
			.m_axis_tstrb     (m_axis_tstrb),
			.m_axis_tlast     (m_axis_tlast),
			.m_axis_tuser     (m_axis_tuser),
			.m_axis_tready    (m_axis_tready)
		);

	initial begin
		// do something

		repeat(1000)@(posedge clk);

		bound_x_min_we <= 0;
		bound_x_min_addr <= 0;
		bound_x_min <= 0;
		bound_x_max_we <= 0;
		bound_x_max_addr <= 0;
		bound_x_max <= 0;
		bound_y_min <= 0;
		bound_y_max <= 0;
		bound_y_min_we <= 0;
		bound_y_max_we <= 0;
		repeat(100)@(posedge clk);

		bound_x_min_we <= 1;
		bound_x_min <= 10;
		bound_x_min_addr <= 0;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		repeat(10)@(posedge clk);
		bound_x_max_we <= 1;
		bound_x_max <= 20;
		bound_x_max_addr <= 0;
		bound_y_min <= 100;
		bound_y_max <= 200;
		bound_y_min_we <= 1;
		bound_y_max_we <= 1;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		bound_x_max_we <= 0;
		bound_y_min_we <= 0;
		bound_y_max_we <= 0;
		repeat(100)@(posedge clk);

		bound_x_min_we <= 1;
		bound_x_min_addr <= 1;
		bound_x_min <= 30;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		repeat(10)@(posedge clk);
		bound_x_max_we <= 1;
		bound_x_max_addr <= 1;
		bound_x_max <= 50;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		bound_x_max_we <= 0;
		repeat(100)@(posedge clk);

		bound_x_min_we <= 1;
		bound_x_min_addr <= 2;
		bound_x_min <= 70;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		repeat(10)@(posedge clk);
		bound_x_max_we <= 1;
		bound_x_max_addr <= 2;
		bound_x_max <= 80;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		bound_x_max_we <= 0;
		repeat(100)@(posedge clk);

		bound_x_min_we <= 1;
		bound_x_min_addr <= 3;
		bound_x_min <= 90;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		repeat(10)@(posedge clk);
		bound_x_max_we <= 1;
		bound_x_max_addr <= 3;
		bound_x_max <= 110;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		bound_x_max_we <= 0;
		repeat(100)@(posedge clk);

		bound_x_min_we <= 1;
		bound_x_min_addr <= 4;
		bound_x_min <= 130;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		repeat(10)@(posedge clk);
		bound_x_max_we <= 1;
		bound_x_max_addr <= 4;
		bound_x_max <= 140;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		bound_x_max_we <= 0;
		repeat(100)@(posedge clk);

		bound_x_min_we <= 1;
		bound_x_min_addr <= 5;
		bound_x_min <= 150;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		repeat(10)@(posedge clk);
		bound_x_max_we <= 1;
		bound_x_max_addr <= 5;
		bound_x_max <= 170;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 190;
		bound_x_max_we <= 0;
		repeat(100)@(posedge clk);

		bound_x_min_we <= 1;
		bound_x_min_addr <= 6;
		bound_x_min <= 190;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		repeat(10)@(posedge clk);
		bound_x_max_we <= 1;
		bound_x_max_addr <= 6;
		bound_x_max <= 200;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		bound_x_max_we <= 0;
		repeat(100)@(posedge clk);

		bound_x_min_we <= 1;
		bound_x_min_addr <= 7;
		bound_x_min <= 210;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		repeat(10)@(posedge clk);
		bound_x_max_we <= 1;
		bound_x_max_addr <= 7;
		bound_x_max <= 230;
		repeat(1)@(posedge clk);
		bound_x_min_we <= 0;
		bound_x_max_we <= 0;
		repeat(100)@(posedge clk);

		repeat(10)@(posedge clk);
		// $finish;
	end

	// dump wave
	initial begin
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_reorder_v1_0.fsdb");
			$fsdbDumpvars(0, "tb_reorder_v1_0", "+mda", "+functions");
		end
	end

endmodule
