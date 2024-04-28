module input_sm (
    input wire digital_in,
    input wire clock,
    input wire reset
);

    reg previous_in;
    reg pos_edge;
    reg neg_edge;

    always @(posedge clock) begin
        if (reset) begin
            previous_in <= 0;
        end else begin
            previous_in <= digital_in;
        end
    end

    always @(*) begin
        pos_edge = (digital_in != previous_in) & digital_in;
        neg_edge = (digital_in != previous_in) & ~digital_in;
    end
endmodule
