`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2026 06:02:22 PM
// Design Name: 
// Module Name: baud_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module baud_generator #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire reset,
    output reg  baud_tick
);

    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    integer counter;

    always @(posedge clk) begin

        if (reset) begin
            counter  <= 0;
            baud_tick <= 0;
        end

        else begin

            if (counter == CLKS_PER_BIT - 1) begin
                counter  <= 0;
                baud_tick <= 1;
            end

            else begin
                counter  <= counter + 1;
                baud_tick <= 0;
            end

        end
    end

endmodule
