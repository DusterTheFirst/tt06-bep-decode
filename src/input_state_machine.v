module input_state_machine (
    input wire digital_in,
    input wire clock,
    input wire reset,

    input wire pos_edge,
    input wire neg_edge,

    output reg manchester_clock
);
    localparam preamble_wait = 0;
    localparam clock_start = 1;
    localparam clock_lock = 2;

    reg[1:0] state;
    reg[1:0] next_state;

    reg[4:0] period;
    reg[4:0] next_period;

    reg[4:0] counter;
    reg[4:0] next_counter;

    reg manchester_clock_next;

    always @(posedge clock) begin
        if (reset) begin
            state <= preamble_wait;
            period <= 0;
            counter <= 0;
            manchester_clock <= '0;
        end else begin
            state <= next_state;
            period <= next_period;
            counter <= next_counter;
            manchester_clock <= manchester_clock_next;
        end
    end

    always @(*) begin
        next_state = state;
        next_period = period;
        next_counter = counter;
        manchester_clock_next = manchester_clock;

        case (state)
            preamble_wait: begin
                if (pos_edge) begin
                    next_state = clock_start;
                end
            end
            clock_start: begin
                next_period = period + 1;

                if (neg_edge) begin
                    next_state = clock_lock;
                end
            end
            clock_lock: begin
                if (next_counter == 0) begin
                    next_counter = period;
                    manchester_clock_next = ~manchester_clock_next;
                end else begin
                    next_counter = next_counter - 1;
                end
            end
            default: begin end
        endcase
    end
endmodule
