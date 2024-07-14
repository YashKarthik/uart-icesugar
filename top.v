`default_nettype none
`include "clock.v"
`include "transmitter.v"

module top(
    clk,
    TX,
    /* SW[0]: reset for clock
    *  SW[1]: i_tx_start for transmitter
    *  SW[2], SW[3]: bits for tx
    *  */
    SW,
    LED_R
);
    input wire clk;
    input wire[3:0] SW;

    output reg TX;
    output wire LED_R;

    wire baud_clk;

    clock baud(
        .i_clk(clk),
        .i_rst(SW[0]),
        .o_clk(baud_clk)
    );

    transmitter uart_tx(
        .i_clk(baud_clk),
        .i_tx_start(SW[1]),
        .busy(LED_R),
        .i_data({ 1'b1, SW[2], 1'b1, SW[3], 1'b1, SW[2], SW[3], 1'b0 }),
        .o_data(TX)
    );

endmodule
