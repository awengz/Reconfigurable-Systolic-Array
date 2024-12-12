
/* ----------------------------------------------------------------------------------------------- //
Project Title: Design of a Parametric Systolic Array for Matrix Multiplication
By: Marwan Eid
File Description: Systolic Array (SA) Interface
Version: 1.0
// ----------------------------------------------------------------------------------------------- */

`timescale 1ns/1ps

interface SA_if # ( parameter int N = 'd4, parameter int WDATA = 'd4, parameter CFG_WIDTH = $clog2(N)+1 );

    // Inputs
    logic                clk;
    logic                rst_n;
    logic [WDATA-1:0]    matrix_N    [1:N];
    logic [WDATA-1:0]    matrix_W    [1:N];
	logic [CFG_WIDTH-1:0]row_cfg_in;
	logic [CFG_WIDTH-1:0]col_cfg_in;
    
    // Outputs
    logic [WDATA-1:0]   matrix_S    [1:N];
    logic [WDATA-1:0]   matrix_E    [1:N];
    logic [2*WDATA-1:0] matrix_out  [1:N] [1:N];
    logic               valid;

endinterface: SA_if
