`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2026 08:44:00 PM
// Design Name: 
// Module Name: uart_controller
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


module uart_controller (
    input  wire       clk,
    input  wire       reset,

    // Transmitter interface
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output wire       tx,
    output wire       tx_busy,

    // Receiver interface
    input  wire       rx,
    output wire [7:0] rx_data,
    output wire       rx_done
);

    wire baud_tick;


    // -----------------------------
    // Baud Rate Generator
    // -----------------------------

    baud_generator baud_gen (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick)
    );


    // -----------------------------
    // UART Transmitter
    // -----------------------------

    uart_tx transmitter (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );


    // -----------------------------
    // UART Receiver
    // -----------------------------

    uart_rx receiver (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule