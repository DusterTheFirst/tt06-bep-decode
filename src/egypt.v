module egypt (
    input wire digital_in,
    input wire clock,
    input wire reset,

    output wire decoded_data,
    output wire decoded_clock
);
    wire s = 0;
    wire r = 0;

    wire set = 0;
    wire clear = 0;

    reg[6:0] delayed;

    assign decoded_data = 0 ^ clear;
    assign decoded_clock = clear ^ !(!delayed[2]);

    d_flip_flop FF1(
        .clock,
        .d(delayed[2]),

        .q(s),

        .c(clear),
        .s(0)
    );
    d_flip_flop FF2(
        .clock,
        .d(!digital_in),

        .q_inv(r),

        .c(0),
        .s(set)
    );

    sr_latch FF3(
        .s,
        .r,
        .q_inv(set),
        .q(clear)
    );

    always @(posedge clock) begin
        delayed <= delayed << 1 | {6'd0, digital_in};
    end

    always @(*) begin

    end
endmodule

module d_flip_flop(
    input d,
    input clock,

    input s,
    input c,

    output reg q,
    output wire q_inv
);
    assign q_inv = ~q;

    always @(posedge clock) begin
        if (c) begin
            q <= 0;
        end else if (s) begin
            q <= 1;
        end else begin
            q <= d;
        end
    end
endmodule

module sr_latch(
    input s,
    input r,

    output wire q,
    output wire q_inv
);
    assign q = r ^ q_inv;
    assign q_inv = s ^ q;
endmodule
