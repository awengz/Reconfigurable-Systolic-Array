
/* ----------------------------------------------------------------------------------------------- //
Project Title: Design of a Parametric Systolic Array for Matrix Multiplication
By: Marwan Eid
File Description: Processing Element (PE) Row Design Module
Version: 1.0
// ----------------------------------------------------------------------------------------------- */

`timescale 1ns/1ps

module PE_row # ( parameter int N = 'd4, parameter int WDATA = 'd4, parameter CFG_WIDTH = $clog2(N)+1, parameter ROW = 0) (
    input  logic                clk,
    input  logic                rst_n,
	input  logic [CFG_WIDTH-1:0]row_cfg_in,
	input  logic [CFG_WIDTH-1:0]col_cfg_in,
    input  logic [WDATA-1:0]    matrix_N [1:N],
    input  logic [WDATA-1:0]    matrix_W,
    output logic [WDATA-1:0]    matrix_S [1:N],
    output logic [WDATA-1:0]    matrix_E,
    output logic [2*WDATA-1:0]  matrix_out [1:N]
    );

    // Internal Signals
    wire [WDATA-1:0] sig_H [2:N];
	
	wire [N:1] pe_enable; 

    // Generate Block
    genvar i;
	generate

        for ( i = 'd1; i <= N; i++) begin : PE_inst
			assign pe_enable[i] = (i>col_cfg_in) ? 0 : ((ROW > row_cfg_in) ? 0 : 1);
            
			if (i == 1'd1) begin

                PE # ( .WDATA (WDATA) )
                PE_inst (
                    .clk        (clk),
                    .rst_n      (rst_n),
					.pe_enable  (pe_enable[i]),
                    .in_data_N  (matrix_N [i]),
                    .in_data_W  (matrix_W),
                    .out_data_S (matrix_S [i]),
                    .out_data_E (sig_H [i+1]),
                    .result     (matrix_out [i])
                );

            end

            else if (i == N) begin

                PE # ( .WDATA (WDATA) )
                PE_inst (
                    .clk        (clk),
                    .rst_n      (rst_n),
					.pe_enable  (pe_enable[i]),
                    .in_data_N  (matrix_N [i]),
                    .in_data_W  (sig_H [i]),
                    .out_data_S (matrix_S [i]),
                    .out_data_E (matrix_E),
                    .result     (matrix_out [i])
                );

            end

            else begin

                PE # ( .WDATA (WDATA) )
                PE_inst (
                    .clk        (clk),
                    .rst_n      (rst_n),
					.pe_enable  (pe_enable[i]),
                    .in_data_N  (matrix_N [i]),
                    .in_data_W  (sig_H [i]),
                    .out_data_S (matrix_S [i]),
                    .out_data_E (sig_H [i+1]),
                    .result     (matrix_out [i])
                );

            end

        end: PE_inst

    endgenerate

endmodule: PE_row
