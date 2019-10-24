
`timescale 1ns/1ps

module tb_judge_one (); /* this is automatically generated */

	logic rst_n;
	logic srst;
	logic clk;

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

	localparam IDLE  = 2'b0;
	localparam COUNT = 2'b1;
	localparam DONE  = 2'h2;

	logic [ 4-1:0] char_index;
	logic [16-1:0] char_diff;
	logic          char_valid;

	logic  [ 15:0] max_diff;
	logic   [ 3:0] min_continue;
	logic   [ 7:0] min_counter;
	logic          all_done;

	logic [ 4-1:0] char_index_o;
	logic          recognize_done;

	judge_one inst_judge_one
		(
			.clk            (clk),
			.rst_n          (rst_n),
			.char_index     (char_index),
			.char_diff      (char_diff),
			.char_valid     (char_valid),
			.max_diff       (max_diff),
			.min_continue   (min_continue),
			.min_counter    (min_counter),
			.all_done       (all_done),
			.char_index_o   (char_index_o),
			.recognize_done (recognize_done)
		);

	initial begin
		// do something
		max_diff <= 30;
		min_continue <= 4;
		min_counter <= 10;
		all_done <= 0;

		char_index <= 10;
		char_diff <= 700;
		char_valid <= 0;
		repeat(10)@(posedge clk);
/*
		char_index <= 5;
		char_diff <= 20;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 10;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 4;
		char_diff <= 200;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 20;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 10;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 20;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 20;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 10;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 20;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 20;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);
*/

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 4;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 3;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 4;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 4;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 4;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 4;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);

		char_index <= 5;
		char_diff <= 50;
		char_valid <= 1;
		repeat(1)@(posedge clk);
		char_valid <= 0;
		repeat(50)@(posedge clk);



		repeat(200)@(posedge clk);
		all_done = 1;
		repeat(1)@(posedge clk);
		all_done = 0;		

		repeat(50)@(posedge clk);
		$finish;
	end

	// dump wave
	initial begin
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_judge_one.fsdb");
			$fsdbDumpvars(0, "tb_judge_one", "+mda", "+functions");
		end
	end

endmodule
