`default_nettype none

module top(
    clk,
    TX,
    RX,
    /* SW[0]: reset
    *  SW[1]: i_tx_start for transmitter
    *  SW[2]: send r_data back to computer
    *  */
    SW,
    LED_R,
    LED_G,
    LED_B
);
    input wire clk;
    input wire RX;
    input wire[3:0] SW;

    output wire TX;
    output wire LED_R;
    output wire LED_G;
    output wire LED_B;

    parameter reg[7:0] ASCII_START = 8'd32;
    parameter reg[7:0] ASCII_END = 8'd126;
    reg[7:0] uart_tx_byte = ASCII_START;
    reg[7:0] next_byte = ASCII_START;
    wire[7:0] r_data;

    wire baud_clk;
    wire LED_R_inv;
    wire LED_B_inv;

    assign LED_R = ~LED_R_inv;
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
        .busy(LED_R_inv),
        .i_data(uart_tx_byte),
        .o_data(TX)
    );

    receiver uart_rx(
        .i_clk(clk),
        .i_rx(RX),
        .i_rst(~SW[0]),
        .o_data(r_data),
        .ready(LED_B_inv)
    );

    always @ (posedge LED_R_inv) begin
        uart_tx_byte <= next_byte;
    end

    always @ (posedge baud_clk) begin
        if (~SW[2]) begin
            next_byte <= r_data;
        end else begin
            if (uart_tx_byte == ASCII_END) begin
                next_byte <= ASCII_START;
            end else begin
                next_byte  <= uart_tx_byte + 1;
            end
        end
    end

endmodule
