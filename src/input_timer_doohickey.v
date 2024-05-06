module input_timer_doohickey (
    input wire digital_in,
    input wire clock,
    input wire reset,

    input wire pos_edge,
    input wire neg_edge
);
    reg [5:0] timer;

    always @(posedge clock) begin
        if (reset) begin
            timer <= 0;
        end else begin
            timer <= timer + 1;
        end
    end

    always @(*) begin

    end
endmodule
