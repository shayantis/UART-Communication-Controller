`timescale 1ns / 1ps

module uart_rx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       rx,

    output reg [7:0]  rx_data,
    output reg        rx_done
);

    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam HALF_BIT     = CLKS_PER_BIT / 2;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;

    integer count;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin

        if (reset) begin

            state     <= IDLE;
            count     <= 0;
            bit_count <= 0;
            shift_reg <= 8'h00;
            rx_data   <= 8'h00;
            rx_done   <= 1'b0;

        end

        else begin

            // Default: rx_done is only one clock wide
            rx_done <= 1'b0;

            case (state)

                // =====================================================
                // IDLE
                // =====================================================

                IDLE: begin

                    count     <= 0;
                    bit_count <= 0;

                    // UART idle = HIGH
                    // LOW means start bit detected
                    if (rx == 1'b0) begin
                        state <= START;
                        count <= 0;
                    end

                end


                // =====================================================
                // START BIT
                // Wait half a bit and verify that RX is still LOW
                // =====================================================

                START: begin

                    if (count == HALF_BIT - 1) begin

                        count <= 0;

                        if (rx == 1'b0) begin
                            state     <= DATA;
                            bit_count <= 0;
                        end

                        else begin
                            // False start
                            state <= IDLE;
                        end

                    end

                    else begin
                        count <= count + 1;
                    end

                end


                // =====================================================
                // DATA BITS
                // UART sends LSB first
                // =====================================================

                DATA: begin

                    if (count == CLKS_PER_BIT - 1) begin

                        count <= 0;

                        // Sample current data bit
                        shift_reg[bit_count] <= rx;

                        if (bit_count == 3'd7) begin

                            bit_count <= 0;
                            state     <= STOP;

                        end

                        else begin

                            bit_count <= bit_count + 1'b1;

                        end

                    end

                    else begin

                        count <= count + 1;

                    end

                end


                // =====================================================
                // STOP BIT
                // =====================================================

                STOP: begin

                    if (count == CLKS_PER_BIT - 1) begin

                        count <= 0;

                        if (rx == 1'b1) begin

                            rx_data <= shift_reg;
                            rx_done <= 1'b1;

                        end

                        state <= IDLE;

                    end

                    else begin

                        count <= count + 1;

                    end

                end


                // =====================================================
                // DEFAULT
                // =====================================================

                default: begin

                    state     <= IDLE;
                    count     <= 0;
                    bit_count <= 0;

                end

            endcase

        end

    end

endmodule