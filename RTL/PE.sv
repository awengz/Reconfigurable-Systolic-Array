
/* ----------------------------------------------------------------------------------------------- //
Project Title: Design of a Parametric Systolic Array for Matrix Multiplication
By: Marwan Eid
File Description: Processing Element (PE) Design Module
Version: 1.0
// ----------------------------------------------------------------------------------------------- */

`timescale 1ns/1ps

module PE # ( parameter int WDATA = 'd4 ) (
    input  logic clk,
    input  logic rst_n,
	input  logic pe_enable,
    input  logic [WDATA-1:0] in_data_N,
    input  logic [WDATA-1:0] in_data_W,
    output logic [WDATA-1:0] out_data_S,
    output logic [WDATA-1:0] out_data_E,
    output logic [2*WDATA-1:0] result
    );

    always @ (posedge clk) begin

        if (!rst_n) begin       // Synchronous Reset
            out_data_S <= 'd0;
            out_data_E <= 'd0;
            result <= 'd0;
        end

        else begin
			if (pe_enable) begin
				out_data_S <= in_data_N;
				out_data_E <= in_data_W;
				result <= result + in_data_N * in_data_W;
			end
        end

    end

endmodule: PE
