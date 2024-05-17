module input_timer_doohickey (
    input wire digital_in,
    input wire clock,
    input wire reset,

    input wire pos_edge,
    input wire neg_edge
);
    localparam [7:0] min_timing = 9;
    localparam [7:0] max_timing = 18;
    reg [7:0] timer;
    reg counting;

    reg previous_next;
    reg previous;

    reg sample;

    always @(posedge clock) begin
        if (reset) begin
            timer <= 0;
            counting <= 0;

            previous <= 0;
        end else if (pos_edge) begin
            counting <= 1;
            timer <= 0;
        end else if (neg_edge) begin
            counting <= 0;

            previous <= previous_next;
        end

        if (counting) begin
            timer <= timer + 1;
        end
    end

    always @(*) begin
        if (absolute_difference(timer, min_timing) < absolute_difference(timer, max_timing)) begin
            previous_next = 0;
        end else begin
            previous_next = 1;
        end
    end
endmodule

function [7:0] absolute_difference;
    input [7:0] a, b;

    if (a > b) begin
        absolute_difference = a - b;
    end else begin
        absolute_difference = b - a;
    end
endfunction
