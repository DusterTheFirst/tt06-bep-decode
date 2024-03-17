module binary_to_bcd (
    input wire reset_n,
    input wire clock,

    input wire [7:0] binary,
    output reg [3:0] digit,

    output reg [1:0] digit_place
);
    parameter clock_cycles_per_digit = 10;

    reg [$clog2(clock_cycles_per_digit) - 1:0] clock_counter;

    wire [3:0] next_digit;

    always @(posedge clock) begin
        if (reset_n == 1'b0) begin
            digit_place <= 2;

            digit <= 0;
        end else if (clock_counter >= clock_cycles_per_digit) begin
            clock_counter <= 0;
            case (digit_place)
                2: digit_place <= 1;
                1: digit_place <= 0;
                0: digit_place <= 2;
                default: digit_place <= 2;
            endcase

            digit <= next_digit;
        end else begin
            clock_counter <= clock_counter + 1;
        end
    end

    reg [7:0] next_digit_8;
    assign next_digit = next_digit_8[3:0];

    always @(*) begin
        case (digit_place)
            0: next_digit_8 = binary % 10;
            1: next_digit_8 = (binary / 10) % 10;
            2: next_digit_8 = (binary / 100) % 10;
            default: next_digit_8 = 8'b00001111;
        endcase
    end

    wire _unused = &{1'b0, next_digit_8[7:4], 1'b0};
endmodule
