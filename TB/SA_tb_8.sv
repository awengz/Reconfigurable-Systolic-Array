
/* ----------------------------------------------------------------------------------------------- //
Project Title: Design of a Parametric Systolic Array for Matrix Multiplication
By: Marwan Eid
File Description: Systolic Array (SA) Testbench Module (N = 8)
Version: 1.0
// ----------------------------------------------------------------------------------------------- */

`timescale 1ns/1ps

module SA_tb_8;

    // Parameters Definition
    parameter int N     = 'd8;
    parameter int WDATA = 'd4;

    // Variables
    logic [WDATA-1:0]   matrix_A [1:N] [1:N];
    logic [WDATA-1:0]   matrix_B [1:N] [1:N];
    logic [2*WDATA-1:0] matrix_C [1:N] [1:N];
    int fail_cnt;

    // Interface Instantiation
    SA_if # ( .N (N), .WDATA (WDATA) )
    intf();

    // Module Instantiation
    SA # ( .N (N), .WDATA (WDATA) )
    SA_inst (
        .clk        (intf.clk),
        .rst_n      (intf.rst_n),
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

    // Matrices Generation
    initial begin

        for (int i = 'd1; i <= N; i++) begin

            for (int j = 'd1; j <= N; j++) begin

                matrix_A [i] [j] = $urandom_range ('d15, 'd1);
                matrix_B [i] [j] = $urandom_range ('d15, 'd1);
                matrix_C [i] [j] = 'd0;

            end

        end

        for (int i = 'd1; i <= N; i++) begin

            for (int j = 'd1; j <= N; j++) begin

                for (int k = 'd1; k <= N; k++) begin

                    matrix_C [i] [j] += matrix_A [i] [k] * matrix_B [k] [j];

                end

            end

        end

    end

    // Drive Task
    task drive (input bit [WDATA-1:0]   W_1, W_2, W_3, W_4, W_5, W_6, W_7, W_8,
                                        N_1, N_2, N_3, N_4, N_5, N_6, N_7, N_8);

        intf.matrix_W[1] <= W_1;
        intf.matrix_W[2] <= W_2;
        intf.matrix_W[3] <= W_3;
        intf.matrix_W[4] <= W_4;
        intf.matrix_W[5] <= W_5;
        intf.matrix_W[6] <= W_6;
        intf.matrix_W[7] <= W_7;
        intf.matrix_W[8] <= W_8;

        intf.matrix_N[1] <= N_1;
        intf.matrix_N[2] <= N_2;
        intf.matrix_N[3] <= N_3;
        intf.matrix_N[4] <= N_4;
        intf.matrix_N[5] <= N_5;
        intf.matrix_N[6] <= N_6;
        intf.matrix_N[7] <= N_7;
        intf.matrix_N[8] <= N_8;

        #10;

    endtask: drive

    // Stimulus Generation
    initial begin

        reset;
        
        // Cycle 1

        drive ( matrix_A [1] [1], 'd0, 'd0, 'd0,
                'd0, 'd0, 'd0, 'd0,
                matrix_B [1] [1], 'd0, 'd0, 'd0,
                'd0, 'd0, 'd0, 'd0);

        // Cycle 2

        drive ( matrix_A [1] [2], matrix_A [2] [1], 'd0, 'd0,
                'd0, 'd0, 'd0, 'd0,
                matrix_B [2] [1], matrix_B [1] [2], 'd0, 'd0,
                'd0, 'd0, 'd0, 'd0);
        
        // Cycle 3

        drive ( matrix_A [1] [3], matrix_A [2] [2], matrix_A [3] [1], 'd0,
                'd0, 'd0, 'd0, 'd0,
                matrix_B [3] [1], matrix_B [2] [2], matrix_B [1] [3], 'd0,
                'd0, 'd0, 'd0, 'd0);

        // Cycle 4

        drive ( matrix_A [1] [4], matrix_A [2] [3], matrix_A [3] [2], matrix_A [4] [1],
                'd0, 'd0, 'd0, 'd0,
                matrix_B [4] [1], matrix_B [3] [2], matrix_B [2] [3], matrix_B [1] [4],
                'd0, 'd0, 'd0, 'd0);

        // Cycle 5

        drive ( matrix_A [1] [5], matrix_A [2] [4], matrix_A [3] [3], matrix_A [4] [2],
                matrix_A [5] [1], 'd0, 'd0, 'd0,
                matrix_B [5] [1], matrix_B [4] [2], matrix_B [3] [3], matrix_B [2] [4],
                matrix_B [1] [5], 'd0, 'd0, 'd0);

        // Cycle 6

        drive ( matrix_A [1] [6], matrix_A [2] [5], matrix_A [3] [4], matrix_A [4] [3],
                matrix_A [5] [2], matrix_A [6] [1], 'd0, 'd0,
                matrix_B [6] [1], matrix_B [5] [2], matrix_B [4] [3], matrix_B [3] [4],
                matrix_B [2] [5], matrix_B [1] [6], 'd0, 'd0);

        // Cycle 7

        drive ( matrix_A [1] [7], matrix_A [2] [6], matrix_A [3] [5], matrix_A [4] [4],
                matrix_A [5] [3], matrix_A [6] [2], matrix_A [7] [1], 'd0,
                matrix_B [7] [1], matrix_B [6] [2], matrix_B [5] [3], matrix_B [4] [4],
                matrix_B [3] [5], matrix_B [2] [6], matrix_B [1] [7], 'd0);

        // Cycle 8

        drive ( matrix_A [1] [8], matrix_A [2] [7], matrix_A [3] [6], matrix_A [4] [5],
                matrix_A [5] [4], matrix_A [6] [3], matrix_A [7] [2], matrix_A [8] [1],
                matrix_B [8] [1], matrix_B [7] [2], matrix_B [6] [3], matrix_B [5] [4],
                matrix_B [4] [5], matrix_B [3] [6], matrix_B [2] [7], matrix_B [1] [8]);

        // Cycle 9

        drive ( 'd0, matrix_A [2] [8], matrix_A [3] [7], matrix_A [4] [6],
                matrix_A [5] [5], matrix_A [6] [4], matrix_A [7] [3], matrix_A [8] [2],
                'd0, matrix_B [8] [2], matrix_B [7] [3], matrix_B [6] [4],
                matrix_B [5] [5], matrix_B [4] [6], matrix_B [3] [7], matrix_B [2] [8]);

        // Cycle 10

        drive ( 'd0, 'd0, matrix_A [3] [8], matrix_A [4] [7],
                matrix_A [5] [6], matrix_A [6] [5], matrix_A [7] [4], matrix_A [8] [3],
                'd0, 'd0, matrix_B [8] [3], matrix_B [7] [4],
                matrix_B [6] [5], matrix_B [5] [6], matrix_B [4] [7], matrix_B [3] [8]);

        // Cycle 11

        drive ( 'd0, 'd0, 'd0, matrix_A [4] [8],
                matrix_A [5] [7], matrix_A [6] [6], matrix_A [7] [5], matrix_A [8] [4],
                'd0, 'd0, 'd0, matrix_B [8] [4],
                matrix_B [7] [5], matrix_B [6] [6], matrix_B [5] [7], matrix_B [4] [8]);

        // Cycle 12

        drive ( 'd0, 'd0, 'd0, 'd0,
                matrix_A [5] [8], matrix_A [6] [7], matrix_A [7] [6], matrix_A [8] [5],
                'd0, 'd0, 'd0, 'd0,
                matrix_B [8] [5], matrix_B [7] [6], matrix_B [6] [7], matrix_B [5] [8]);

        // Cycle 13

        drive ( 'd0, 'd0, 'd0, 'd0,
                'd0, matrix_A [6] [8], matrix_A [7] [7], matrix_A [8] [6],
                'd0, 'd0, 'd0, 'd0,
                'd0, matrix_B [8] [6], matrix_B [7] [7], matrix_B [6] [8]);


        // Cycle 14

        drive ( 'd0, 'd0, 'd0, 'd0,
                'd0, 'd0, matrix_A [7] [8], matrix_A [8] [7],
                'd0, 'd0, 'd0, 'd0,
                'd0, 'd0, matrix_B [8] [7], matrix_B [7] [8]);

        // Cycle 15

        drive ( 'd0, 'd0, 'd0, 'd0,
                'd0, 'd0, 'd0, matrix_A [8] [8],
                'd0, 'd0, 'd0, 'd0,
                'd0, 'd0, 'd0, matrix_B [8] [8]);

        // Cycle 16

        drive ( 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0, 'd0,
                'd0, 'd0, 'd0, 'd0 , 'd0, 'd0, 'd0, 'd0);

        #65

        $display("Comparison Summary:\n");

        for (int i = 'd1; i <= N; i++) begin

            for (int j = 'd1; j <= N; j++) begin

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

endmodule: SA_tb_8
