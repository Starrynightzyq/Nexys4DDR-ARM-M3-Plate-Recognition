
`timescale 1ns/1ps

module tb_judge ();/* this is automatically generated */

	logic rst_n;
	logic srst ;
	logic clk  ;

	// clock
	initial begin
		clk = '0;
		forever #(0.5) clk = ~clk;
	end

	// reset
	initial begin
		rst_n <= '0;
		srst <= '0;
		#20
			rst_n <= '1;
		repeat (5) @(posedge clk);
		srst <= '1;
		repeat (1) @(posedge clk);
		srst <= '0;
	end

	// (*NOTE*) replace reset, clock, others

	localparam IDLE   = 2'h0;
	localparam RECOGN = 2'h1;
	localparam DONE   = 2'h2;

	logic [    15:0] max_diff     ;
	logic [     3:0] min_continue ;
	logic [     7:0] min_counter  ;
	logic [ 7*4-1:0] char_index_c ;
	logic [7*16-1:0] char_diff_c  ;
	logic            char_valid_c ;
	logic [ 7*4-1:0] char_index_co;
	logic            char_valid_co;

	judge inst_judge (
		.clk          (clk          ),
		.rst_n        (rst_n        ),
		
		.max_diff     (max_diff     ),
		.min_continue (min_continue ),
		.min_counter  (min_counter  ),
		
		.char_index_c (char_index_c ),
		.char_diff_c  (char_diff_c  ),
		.char_valid_c (char_valid_c ),
		
		.char_index_co(char_index_co),
		.char_valid_co(char_valid_co)
	);

	initial begin
		// do something
		max_diff <= 30;
		min_continue <= 2;
		min_counter <= 10;

		char_index_c <= {4'ha, 4'ha, 4'ha, 4'ha, 4'ha, 4'ha, 4'ha, 4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'hf0, 16'hf0, 16'hf0, 16'hf0};
		char_valid_c <= 0;
		repeat(10)@(posedge clk);

		char_index_c <= {   4'h4,   4'h3,   4'h2,   4'h1,   4'h0,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h10, 16'h10, 16'h10, 16'h10};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h4,   4'h3,   4'h2,   4'h1,   4'h0,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h10, 16'h10, 16'h10, 16'h10};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h5,   4'h3,   4'h2,   4'h1,   4'h0,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h10, 16'h10, 16'h10, 16'h10};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h4,   4'h3,   4'h2,   4'h1,   4'h0,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h10, 16'h10, 16'h10, 16'h10};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h4,   4'h3,   4'h2,   4'h1,   4'h0,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h10, 16'h10, 16'h10, 16'h10};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h4,   4'h3,   4'h2,   4'h1,   4'h0,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h10, 16'h10, 16'h10, 16'h10};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h4,   4'h3,   4'h2,   4'h1,   4'h0,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h10, 16'h10, 16'h10, 16'h10};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h4,   4'h3,   4'h2,   4'h1,   4'h0,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h10, 16'h10, 16'h10, 16'h10};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h4,   4'h3,   4'h2,   4'h1,   4'h0,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h10, 16'h10, 16'h10, 16'h10};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

// test 2
		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h4,   4'h4,   4'h3,   4'h1,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h4,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		char_index_c <= {   4'h6,   4'h5,   4'h3,   4'h3,   4'h2,  4'ha,  4'ha};
		char_diff_c <= {16'hf0, 16'hf0, 16'hf0, 16'h50, 16'h50, 16'h50, 16'h50};
		char_valid_c <= 1;
		repeat(1)@(posedge clk);
		char_valid_c <= 0;
		repeat(50)@(posedge clk);

		repeat(10)@(posedge clk);
		$finish;
	end

	// dump wave
	initial begin
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_judge.fsdb");
			$fsdbDumpvars(0, "tb_judge", "+mda", "+functions");
		end
	end

endmodule
