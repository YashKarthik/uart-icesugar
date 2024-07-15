`default_nettype none

module top(
    clk,
    TX,
    /* SW[0]: reset for clock
    *  SW[1]: i_tx_start for transmitter
    *  SW[2], SW[3]: bits for tx
    *  */
    SW,
    LED_R,
    LED_G
);
    input wire clk;
    input wire[3:0] SW;

    output wire TX;
    output wire LED_R;
    output wire LED_G;

    wire baud_clk;
    wire LED_R_n;
    wire SW_t[4];
    assign SW_t[0] = ~SW[0];
    assign SW_t[1] = ~SW[1];
    assign SW_t[2] = ~SW[2];
    assign SW_t[3] = ~SW[3];

    assign LED_G = ~SW_t[1];
    assign LED_R = ~LED_R_n;

    clock baud(
        .i_clk(clk),
        .i_rst(SW_t[0]),
        .o_clk(baud_clk)
    );

    transmitter uart_tx(
        .i_clk(baud_clk),
        .i_tx_start(SW_t[1]),
        .busy(LED_R_n),
        .i_data(8'b01000001),
        .o_data(TX)
    );

endmodule
