
/* ----------------------------------------------------------------------------------------------- //
Project Title: Design of a Parametric Systolic Array for Matrix Multiplication
By: Marwan Eid
File Description: Systolic Array (SA) Design Module
Version: 1.0
// ----------------------------------------------------------------------------------------------- */

`timescale 1ns/1ps

module SA # ( parameter int N = 'd4, parameter int WDATA = 'd4 ) (
    input  logic                clk,
    input  logic                rst_n,
    input  logic [WDATA-1:0]    matrix_N    [1:N],
    input  logic [WDATA-1:0]    matrix_W    [1:N],
    output logic [WDATA-1:0]    matrix_S    [1:N],
    output logic [WDATA-1:0]    matrix_E    [1:N],
    output logic [2*WDATA-1:0]  matrix_out  [1:N] [1:N],
    output logic                valid
    );

    // Internal Signals
    wire [WDATA-1:0] sig_V [1:N] [1:N];

    // Variables
    int valid_cnt;
    int valid_trig;

    // Generate Block
    generate

        for (genvar i = 'd1; i <= N; i++) begin : PE_row_inst

            if (i == 'd1) begin

                PE_row # ( .N (N), .WDATA (WDATA) )
                    PE_row_inst (
                    .clk            (clk),
                    .rst_n          (rst_n),
                    .matrix_N       (matrix_N),
                    .matrix_W       (matrix_W [i]),
                    .matrix_S       (sig_V [i+1]),
                    .matrix_E       (matrix_E [i]),
                    .matrix_out     (matrix_out [i])
                );

            end

            else if (i == N) begin

                PE_row # ( .N (N), .WDATA (WDATA) )
                    PE_row_inst (
                    .clk            (clk),
                    .rst_n          (rst_n),
                    .matrix_N       (sig_V [i]),
                    .matrix_W       (matrix_W [i]),
                    .matrix_S       (matrix_S),
                    .matrix_E       (matrix_E [i]),
                    .matrix_out     (matrix_out [i])
                );

            end

            else begin

                PE_row # ( .N (N), .WDATA (WDATA) )
                    PE_row_inst (
                    .clk            (clk),
                    .rst_n          (rst_n),
                    .matrix_N       (sig_V [i]),
                    .matrix_W       (matrix_W [i]),
                    .matrix_S       (sig_V [i+1]),
                    .matrix_E       (matrix_E [i]),
                    .matrix_out     (matrix_out [i])
                );

            end

        end : PE_row_inst

    endgenerate

    always @ (posedge clk) begin

        if (!rst_n) begin       // Synchronous Reset

            valid <= 1'b0;

        end

        else begin

            valid_cnt++;

            valid_trig = 'd3 * N - 'd2;     // Predicted I/O Latency

            if (valid_cnt >= valid_trig) begin

                valid <= 1'b1;

            end

            else begin

                valid <= 1'b0;

            end

        end

    end

endmodule: SA
