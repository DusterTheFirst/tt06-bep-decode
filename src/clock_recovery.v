module clock_recovery (
    input wire digital_in,
    input wire clock,
    input wire reset,

    input wire any_edge,

    output reg manchester_clock
);
    reg [31:0] counter;
    reg [31:0] compare;

    always @(posedge clock) begin
        if (reset) begin
            counter <= 0;
            compare <= 0;
            manchester_clock <= 0;
        end else if (any_edge) begin
            compare <= counter;
            counter <= 0;
            manchester_clock <= ~manchester_clock;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
