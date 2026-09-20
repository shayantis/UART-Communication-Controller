`timescale 1ns / 1ps

module uart_tx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       baud_tick,
    input  wire       tx_start,
    input  wire [7:0] tx_data,

    output reg        tx,
    output reg        tx_busy
);

    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;

    reg [7:0] tx_shift_reg;
    reg [2:0] bit_count;

    integer count;


    always @(posedge clk) begin

        if (reset) begin

            state        <= IDLE;
            tx            <= 1'b1;
            tx_busy       <= 1'b0;
            tx_shift_reg  <= 8'h00;
            bit_count     <= 3'b000;
            count         <= 0;

        end

        else begin

            case (state)

                // =====================================================
                // IDLE
                // =====================================================

                IDLE: begin

                    tx      <= 1'b1;
                    tx_busy <= 1'b0;
                    count   <= 0;

                    if (tx_start) begin

                        tx_shift_reg <= tx_data;
                        bit_count    <= 3'b000;

                        tx            <= 1'b0;
                        tx_busy       <= 1'b1;

                        count         <= 0;
                        state         <= START;

                    end

                end


                // =====================================================
                // START BIT
                // =====================================================

                START: begin

                    tx <= 1'b0;

                    if (count == CLKS_PER_BIT - 1) begin

                        count <= 0;
                        state <= DATA;

                    end

                    else begin

                        count <= count + 1;

                    end

                end


                // =====================================================
                // DATA BITS
                // =====================================================

                DATA: begin

                    // UART sends LSB first
                    tx <= tx_shift_reg[0];

                    if (count == CLKS_PER_BIT - 1) begin

                        count <= 0;

                        tx_shift_reg <= tx_shift_reg >> 1;

                        if (bit_count == 3'd7) begin

                            bit_count <= 0;
                            state <= STOP;

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

                    tx <= 1'b1;

                    if (count == CLKS_PER_BIT - 1) begin

                        count   <= 0;
                        tx_busy <= 1'b0;
                        state   <= IDLE;

                    end

                    else begin

                        count <= count + 1;

                    end

                end


                // =====================================================
                // DEFAULT
                // =====================================================

                default: begin

                    state        <= IDLE;
                    tx            <= 1'b1;
                    tx_busy       <= 1'b0;
                    count         <= 0;
                    bit_count     <= 0;
                    tx_shift_reg  <= 8'h00;

                end

            endcase

        end

    end

endmodule