module input_state_machine (
    input wire digital_in,
    input wire clock,
    input wire reset
);
    localparam preamble_wait = 0;
    reg state;

    always @(posedge clock) begin
        if (reset) begin
            state <= preamble_wait;
        end else begin

        end
    end

    always @(*) begin
        case (state)
            default:
                begin end
        endcase
    end
endmodule
