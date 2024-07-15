`default_nettype none

module transmitter(
    i_clk,
    i_tx_start,
    i_data,
    o_data,
    busy
);
    input wire i_clk;
    input wire i_tx_start;
    input wire[7:0] i_data;

    output reg busy;
    output reg o_data;

    reg continue_tx;
    reg[9:0] s_data;
    reg[3:0] bit_counter;

    always @ (posedge i_clk) begin
        if (continue_tx) begin
            o_data <= s_data[0];
            s_data <= s_data >> 1;

            busy <= 1;
            bit_counter <= bit_counter + 1;
            continue_tx <= (bit_counter < 9) ? 1'b1 : 1'b0;
        end else if (i_tx_start) begin
            continue_tx <= 1;
            bit_counter <= 0;
            s_data <= {1'b1, i_data, 1'b0};
            busy <= 0;
            o_data <= 1;
        end else begin
            o_data <= 1;
            busy <= 0;
        end
    end
endmodule
