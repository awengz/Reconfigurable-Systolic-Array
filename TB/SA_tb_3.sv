
/* ----------------------------------------------------------------------------------------------- //
Project Title: Design of a Parametric Systolic Array for Matrix Multiplication
By: Marwan Eid
File Description: Systolic Array (SA) Testbench Module (N = 4), with 3x3 config
Version: 1.0
// ----------------------------------------------------------------------------------------------- */

`timescale 1ns/1ps

module SA_tb_4;

    // Parameters Definition
    parameter int N     = 'd4; // Size of systolic array
    parameter int WDATA = 'd4;
	parameter int K		= 'd3; // size of matrix, K is less than or equal to N

    // Variables
    logic [WDATA-1:0]   matrix_A [1:K] [1:K];
    logic [WDATA-1:0]   matrix_B [1:K] [1:K];
    logic [2*WDATA-1:0] matrix_C [1:K] [1:K];
    int fail_cnt;

    // Interface Instantiation
    SA_if # ( .N (N), .WDATA (WDATA) )
    intf();

    // Module Instantiation
    SA # ( .N (N), .WDATA (WDATA) )
    SA_inst (
        .clk        (intf.clk),
        .rst_n      (intf.rst_n),
		.row_cfg_in (intf.row_cfg_in),
		.col_cfg_in (intf.col_cfg_in),
        .matrix_N   (intf.matrix_N),
        .matrix_W   (intf.matrix_W),
        .matrix_S   (intf.matrix_S),
        .matrix_E   (intf.matrix_E),
        .matrix_out (intf.matrix_out),
        .valid      (intf.valid)
    );

    // Clock Generation
    initial intf.clk <= 1'b0;
    always #5 intf.clk = ~intf.clk;

    // Reset Task
    task reset;
        intf.rst_n <= 1'b0;
        #10
        intf.rst_n <= 1'b1;
    endtask: reset
	
	// Set Config
	task set_cfg(int row, int col);
		intf.row_cfg_in <= row;
		intf.col_cfg_in <= col;
		reset;
		
	endtask: set_cfg

    // Matrices Generation
    initial begin

        for (int i = 'd1; i <= K; i++) begin

            for (int j = 'd1; j <= K; j++) begin

                matrix_A [i] [j] = $urandom_range ('d15, 'd1);
                matrix_B [i] [j] = $urandom_range ('d15, 'd1);
                matrix_C [i] [j] = 'd0;

            end

        end

        for (int i = 'd1; i <= K; i++) begin

            for (int j = 'd1; j <= K; j++) begin

                for (int k = 'd1; k <= K; k++) begin

                    matrix_C [i] [j] += matrix_A [i] [k] * matrix_B [k] [j];

                end

            end

        end

    end

    // Drive Task
    task drive (input bit [WDATA-1:0]   W_1, W_2, W_3, W_4,
                                        N_1, N_2, N_3, N_4);

        intf.matrix_W[1] <= W_1;
        intf.matrix_W[2] <= W_2;
        intf.matrix_W[3] <= W_3;
        intf.matrix_W[4] <= W_4;

        intf.matrix_N[1] <= N_1;
        intf.matrix_N[2] <= N_2;
        intf.matrix_N[3] <= N_3;
        intf.matrix_N[4] <= N_4;

        #10;

    endtask: drive

    // Stimulus Generation
    initial begin

		reset;
		set_cfg(K,K);
		
		
		// for (1 to 2k)
		//		drive ()
        
        // Cycle 1

        drive ( matrix_A [1] [1], 'd0, 'd0, 'd0,
                matrix_B [1] [1], 'd0, 'd0, 'd0);

        // Cycle 2

        drive ( matrix_A [1] [2], matrix_A [2] [1], 'd0, 'd0,
                matrix_B [2] [1], matrix_B [1] [2], 'd0, 'd0);
        
        // Cycle 3

        drive ( matrix_A [1] [3], matrix_A [2] [2], matrix_A [3] [1], 'd0,
                matrix_B [3] [1], matrix_B [2] [2], matrix_B [1] [3], 'd0);

        // Cycle 4

        drive ( 'd0, matrix_A [2] [3], matrix_A [3] [2], 'd0,
                'd0, matrix_B [3] [2], matrix_B [2] [3], 'd0);

        // Cycle 5

        drive ( 'd0, 'd0, matrix_A [3] [3], 'd0,
                'd0, 'd0, matrix_B [3] [3], 'd0);

        // Cycle 6

        drive ( 'd0, 'd0, 'd0, 'd0,
                'd0, 'd0, 'd0, 'd0);

        #25

        $display("Comparison Summary:\n");

        for (int i = 'd1; i <= K; i++) begin

            for (int j = 'd1; j <= K; j++) begin

                if (matrix_C [i] [j] != intf.matrix_out [i] [j]) begin
                    $display("-------------------------------------------------------------------------------");
                    $display("Test Failed for Index %0d, %0d", i, j);
                    fail_cnt++;
                end

            end

        end

        if (fail_cnt == 'd0) begin
            $display("-------------------------------------------------------------------------------");
            $display("Test Passed");
        end

        else begin
            $display("-------------------------------------------------------------------------------");
            $display("Test Failed");
        end

        $display("-------------------------------------------------------------------------------");
        $display("matrix_A = %0p", matrix_A);
        $display("-------------------------------------------------------------------------------");
        $display("matrix_B = %0p", matrix_B);
        $display("-------------------------------------------------------------------------------");
        $display("matrix_C = %0p", matrix_C);
        $display("-------------------------------------------------------------------------------");
        $display("matrix_out = %0p", intf.matrix_out);
        $display("-------------------------------------------------------------------------------");

        $stop;

    end

endmodule: SA_tb_4
