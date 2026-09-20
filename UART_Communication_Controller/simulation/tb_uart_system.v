`timescale 1ns / 1ps

module tb_uart_system;

    reg clk;
    reg reset;

    reg        tx_start;
    reg [7:0]  tx_data;

    wire       tx;
    wire       rx;

    wire       tx_busy;
    wire [7:0] rx_data;
    wire       rx_done;

    // -----------------------------------------
    // UART LOOPBACK
    // TX output connected directly to RX input
    // -----------------------------------------

    assign rx = tx;


    // -----------------------------------------
    // DUT
    // -----------------------------------------

    uart_controller uut (
        .clk(clk),
        .reset(reset),

        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),

        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );


    // -----------------------------------------
    // 50 MHz CLOCK
    // 20 ns period
    // -----------------------------------------

    always #10 clk = ~clk;


    // -----------------------------------------
    // TESTBENCH
    // -----------------------------------------

    initial begin

        clk      = 0;
        reset    = 1;
        tx_start = 0;
        tx_data  = 8'h00;

        // Reset
        #100;
        reset = 0;

        // =====================================
        // BYTE 1 : 0x55
        // =====================================

        #100;

        tx_data  = 8'h55;
        tx_start = 1;

        #20;
        tx_start = 0;

        wait(tx_busy == 0);

        #100000;


        // =====================================
        // BYTE 2 : 0xA5
        // =====================================

        tx_data  = 8'hA5;
        tx_start = 1;

        #20;
        tx_start = 0;

        wait(tx_busy == 0);

        #100000;


        // =====================================
        // BYTE 3 : 0x3C
        // =====================================

        tx_data  = 8'h3C;
        tx_start = 1;

        #20;
        tx_start = 0;

        wait(tx_busy == 0);

        #200000;


        // =====================================
        // END SIMULATION
        // =====================================

        $stop;

    end


    // -----------------------------------------
    // DISPLAY RECEIVED DATA
    // -----------------------------------------

    always @(posedge rx_done) begin

        $display(
            "Time = %0t ns : RX DATA = %h",
            $time,
            rx_data
        );

    end

endmodule