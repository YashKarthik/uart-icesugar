`default_nettype none
`include "clock.v"

module receiver(
    i_clk,
    i_rx,
    i_rst,
    o_data,
    ready
);
    input wire i_clk;
    input wire i_rx;
    input wire i_rst;
    output reg ready;
    output reg[7:0] o_data;

    reg continue_rx;
    reg prev;
    reg rx_steady_val;
    reg [3:0] steady;
    reg[7:0] s_data;
    reg[3:0] bit_counter;

    wire baud_clk;
    wire baud_rst;
    wire internal_clk;
    assign baud_rst = (steady == 4'b1111) ? 1 : 0;

    clock #(.N(4999)) internal_clk_gen(
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_clk(internal_clk)
    );

    clock baud_gen(
        .i_clk(i_clk),
        .i_rst(i_rst | baud_rst),
        .o_clk(baud_clk)
    );

    always @ (posedge internal_clk) begin
        if (steady == 4'b1111) begin
            rx_steady_val <= prev;
        end else if (prev == i_rx) begin
            steady <= steady + 1;
        end else begin
            steady <= 0;
            prev <= i_rx;
        end
    end

    always @ (posedge baud_clk) begin
        if (continue_rx) begin
            s_data <= s_data >> 1;
            s_data[7] <= rx_steady_val;
            ready <= 0;
            bit_counter <= bit_counter + 1;
            continue_rx <= (bit_counter < 7) ? 1'b1 : 1'b0;
            o_data <= 0;
        end else if (~i_rx) begin
            continue_rx <= 1;
            bit_counter <= 0;
            s_data <= 0;
            ready <= 0;
            o_data <= 0;
        end else begin
            o_data <= s_data;
            ready <= 1;
        end
    end
endmodule
