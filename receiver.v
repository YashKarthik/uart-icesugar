`default_nettype none

module receiver(
    i_clk,
    i_rx,
    o_data,
    busy
);
    input wire i_clk;
    input wire i_rx;
    output reg busy;
    output reg[7:0] o_data;

    reg continue_rx;
    reg[7:0] s_data;
    reg[3:0] bit_counter;

    always @ (negedge i_clk, negedge i_rx) begin
        if (continue_rx) begin
            s_data <= s_data >> 1;
            s_data[7] <= i_rx;

            busy <= 1;
            bit_counter <= bit_counter + 1;
            continue_rx <= (bit_counter < 7) ? 1'b1 : 1'b0;
            o_data <= 0;
        end else if (~i_rx) begin
            continue_rx <= 1;
            bit_counter <= 0;
            s_data <= 0;
            busy <= 1;
            o_data <= 0;
        end else begin
            o_data <= s_data;
            busy <= 0;
        end
    end
endmodule
