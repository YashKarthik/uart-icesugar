`default_nettype none

module clock(i_clk, i_rst, o_clk);
    input wire i_clk;
    input wire i_rst;
    output reg o_clk;

    reg [10:0] counter;

    always @ (posedge i_clk, posedge i_rst) begin
        if (i_rst) begin
            counter <= 0;
            o_clk <= 0;
        end else if (counter == 1249) begin
            counter <= 0;
            o_clk <= 1;
        end else begin
            counter <= counter + 1;
            o_clk <= 0;
        end
    end
endmodule
