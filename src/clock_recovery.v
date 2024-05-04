module clock_recovery (
    input wire digital_in,
    input wire clock,
    input wire reset,
    input wire pos_edge,
    input wire neg_edge,

    output wire manchester_clock
);
    reg [3:0] counter;
    reg [3:0] next_counter;

    assign manchester_clock = counter > period >> 1;

    reg [3:0] period;
    reg [3:0] next_period;

    always @(posedge clock) begin
        if (reset) begin
            counter <= 0;
            period <= 6;
        end else begin
            counter <= next_counter;
            period <= next_period;
        end
    end

    always @(*) begin
        next_counter = counter + 1;
        next_period = period;

        if (pos_edge || neg_edge) begin
            // Early
            if (counter < period >> 1) begin
                next_period = period + 1;
                // next_counter = 0;
            end

            // Late
            if (counter > period >> 1) begin
                next_period = period - 1;
                // next_counter = 0;
            end
        end

        if (counter >= period) begin
            next_counter = 0;
        end
    end
endmodule
