`default_nettype none

module top(
    clk,
    TX,
    /* SW[0]: reset for baud clock
    *  SW[1]: i_tx_start for transmitter
    *  SW[2], SW[3]: inc/dec trasmission bits
    *  */
    SW,
    LED_R,
    LED_G,
    LED_B
);
    input wire clk;
    input wire[3:0] SW;

    output wire TX;
    output wire LED_R;
    output wire LED_G;
    output wire LED_B;

    parameter reg[7:0] ASCII_START = 8'd32;
    parameter reg[7:0] ASCII_END = 8'd126;
    reg[7:0] uart_tx_byte = ASCII_START;

    wire baud_clk;
    wire LED_B_inv;

    assign LED_R = SW[0];
    assign LED_G = SW[1];
    assign LED_B = ~LED_B_inv;

    clock baud(
        .i_clk(clk),
        .i_rst(~SW[0]),
        .o_clk(baud_clk)
    );

    transmitter uart_tx(
        .i_clk(baud_clk),
        .i_tx_start(~SW[1]),
        .busy(LED_B_inv),
        .i_data(uart_tx_byte),
        .o_data(TX)
    );

    always @ (negedge LED_B_inv) begin
        if (~SW[2]) begin

            if (uart_tx_byte == ASCII_END) begin
                uart_tx_byte <= ASCII_START;
            end else begin
                uart_tx_byte <= uart_tx_byte + 1;
            end

        end else if (~SW[3]) begin

            if (uart_tx_byte == ASCII_START) begin
                uart_tx_byte <= ASCII_END;
            end else begin
                uart_tx_byte <= uart_tx_byte - 1;
            end

        end
    end

endmodule
