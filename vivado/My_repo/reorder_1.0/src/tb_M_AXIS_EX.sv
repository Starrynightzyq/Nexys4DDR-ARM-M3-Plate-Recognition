
`timescale 1ns/1ps

module tb_M_AXIS_EX (); /* this is automatically generated */

	logic rstb;
	logic srst;
	logic M_AXIS_ACLK;

	// clock
	initial begin
		M_AXIS_ACLK = '0;
		forever #(0.5) M_AXIS_ACLK = ~M_AXIS_ACLK;
	end

	// reset
	initial begin
		rstb <= '0;
		srst <= '0;
		#20
		rstb <= '1;
		repeat (5) @(posedge M_AXIS_ACLK);
		srst <= '1;
		repeat (1) @(posedge M_AXIS_ACLK);
		srst <= '0;
	end

	// (*NOTE*) replace reset, clock, others

	parameter integer C_M_AXIS_TDATA_WIDTH = 8;
	parameter integer C_M_START_COUNT      = 8;

	logic                                  M_AXIS_ARESETN;
	logic                                  M_AXIS_TVALID;
	logic     [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA;
	logic [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB;
	logic                                  M_AXIS_TLAST;
	logic                                  M_AXIS_TUSER;
	logic                                  M_AXIS_TREADY;

	assign M_AXIS_ARESETN = ~srst;

	M_AXIS_EX #(
			.C_M_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
			.C_M_START_COUNT(C_M_START_COUNT)
		) inst_M_AXIS_EX (
			.M_AXIS_ACLK    (M_AXIS_ACLK),
			.M_AXIS_ARESETN (M_AXIS_ARESETN),
			.M_AXIS_TVALID  (M_AXIS_TVALID),
			.M_AXIS_TDATA   (M_AXIS_TDATA),
			.M_AXIS_TSTRB   (M_AXIS_TSTRB),
			.M_AXIS_TLAST   (M_AXIS_TLAST),
			.M_AXIS_TUSER   (M_AXIS_TUSER),
			.M_AXIS_TREADY  (M_AXIS_TREADY)
		);

	initial begin
		// do something
		M_AXIS_TREADY = 1'b0;
		repeat(10)@(posedge M_AXIS_ACLK);
		M_AXIS_TREADY = 1'b1;
		repeat(1000)@(posedge M_AXIS_ACLK);
		M_AXIS_TREADY = 1'b0;
		repeat(10)@(posedge M_AXIS_ACLK);
		M_AXIS_TREADY = 1'b1;
		repeat(1000)@(posedge M_AXIS_ACLK);
		// M_AXIS_TREADY = 1'b0;

		// repeat(10)@(posedge M_AXIS_ACLK);
		// $finish;
	end

	// dump wave
	initial begin
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_M_AXIS_EX.fsdb");
			$fsdbDumpvars(0, "tb_M_AXIS_EX", "+mda", "+functions");
		end
	end

endmodule
