module state_machine3 (
    input wire digital_in,
    input wire clock,
    input wire reset,

    input wire pos_edge,
    input wire neg_edge,

    output wire manchester_clock,
    output wire manchester_data
);

    reg [5:0] timer, next_timer;
    localparam period = 18;

    reg [2:0] state, next_state;
    localparam state_waiting_for_transmission = 0, // TODO: transmission detection (wait for long sequence of low bits)
               state_armed                    = 1,
               state_timing                   = 2,
               state_looking_for_edge         = 3,
               state_found_edge               = 4,
               state_end_of_transmission      = ~0; // TODO: when to switch to waiting for transmission

    reg decoded, next_decoded;
    reg clock_mask, next_clock_mask;

    assign manchester_data = decoded;
    assign manchester_clock = clock_mask & !clock;

    always @(posedge clock) begin
        if (reset) begin
            timer <= 0;
            state <= state_armed;
            decoded <= 0;
            clock_mask <= 0;
        end else begin
            timer <= next_timer;
            state <= next_state;
            decoded <= next_decoded;
            clock_mask <= next_clock_mask;
        end
    end

    always @(*) begin
        next_state = state;
        next_decoded = decoded;
        next_timer = 0;
        next_clock_mask = 0;

        case (state)
            state_armed: if (pos_edge || neg_edge) begin
                next_state = state_timing;
            end
            state_timing: begin
                next_timer = timer + 1;

                if (timer > period / 4) begin
                    next_timer = 0;
                    next_state = state_looking_for_edge;
                end
            end
            state_looking_for_edge: begin
                next_timer = timer + 1;

                if (pos_edge) begin
                    next_decoded = 0;
                    next_clock_mask = 1;
                    next_timer = 0;
                    next_state = state_found_edge;
                end else if (neg_edge) begin
                    next_decoded = 1;
                    next_clock_mask = 1;
                    next_timer = 0;
                    next_state = state_found_edge;
                end else if (timer >= period) begin
                    next_state = state_end_of_transmission;
                end
            end
            state_found_edge: begin
                next_timer = timer + 1;
                if (timer >= period / 4) begin
                    next_timer = 0;
                    next_state = state_timing;
                end
            end
            state_end_of_transmission: begin end
        endcase
    end
endmodule
