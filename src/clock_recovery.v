module clock_recovery (
    input wire digital_in,
    input wire clock,
    input wire reset,
    input wire pos_edge,
    input wire neg_edge,

    output reg manchester_clock
);

    reg [3:0] next_counter;
    reg [3:0] next_period;
    reg next_manchester_clock;

    reg [3:0] counter;
    reg [3:0] period;

    always @(posedge clock) begin
        if (reset) begin
            manchester_clock <= 0;
            counter <= 0;
            period <= 10;
        end else begin
            counter <= next_counter;
            manchester_clock <= next_manchester_clock;
            // period <= next_period;
        end
    end

    always @(*) begin
        if (counter >= period || pos_edge || neg_edge) begin
            next_counter = 0;
            next_period = counter;
            next_manchester_clock = ~manchester_clock;
        end else begin
            next_counter = counter + 1;
            next_period = period;
            next_manchester_clock = manchester_clock;
        end
    end
endmodule
