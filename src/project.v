/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none
`include "seven_segment_decode.v"
`include "binary_to_bcd.v"
`include "serial_decode.v"
`include "edge_detect.v"
`include "input_state_machine.v"
`include "clock_recovery.v"

module tt_um_dusterthefirst_project (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = {seven_segment_decimal, decimal_digit_place == 0};
  assign uo_out = {&thermostat_id, &room_temp, &set_temp, 5'b0};
  // assign uio_out = {seven_segment_hex, 1'b0};
  assign uio_out[7:1] = 7'b0000000;
  assign uio_oe  = 8'b10000000;

  wire pos_edge, neg_edge;

  edge_detect input_edge_detect (
    .digital_in(ui_in[1]),
    .clock(clk),
    .reset(~rst_n),

    .pos_edge,
    .neg_edge
  );

  wire any_edge = pos_edge || neg_edge;

  clock_recovery input_clock_recovery (
    .digital_in(ui_in[1]),
    .clock(clk),
    .reset(~rst_n),

    .any_edge,

    .manchester_clock(uio_out[0])
  );

  input_state_machine input_state_machine (
    .digital_in(ui_in[1]),
    .clock(clk),
    .reset(~rst_n)
  );

  // wire [6:0] seven_segment_decimal;
  // wire [6:0] seven_segment_hex;

  // wire [3:0] decimal_digit;
  // wire [1:0] decimal_digit_place;

  // binary_to_bcd bcd_encode (
  //   .clock(clk),
  //   .reset_n(rst_n),

  //   .binary(ui_in),
  //   .digit(decimal_digit),

  //   .digit_place(decimal_digit_place)
  // );

  // seven_segment_decode_decimal seven_decimal (
  //   .digit(decimal_digit),
  //   .abcdefg(seven_segment_decimal)
  // );

  // seven_segment_decode_hex seven_hex (
  //   .digit(ui_in[3:0]),
  //   .abcdefg(seven_segment_hex)
  // );

  // wire [31:0] preamble;
  // wire [15:0] type_1;
  // wire [15:0] type_2;
  // wire [31:0] constant;
  wire [31:0] thermostat_id;
  wire [15:0] room_temp;
  wire [15:0] set_temp;
  // wire [7:0] state;
  // wire [7:0] tail_1;
  // wire [7:0] tail_2;
  // wire [7:0] tail_3;

  serial_decode data_decode (
    .reset(!rst_n),
    .serial_clock(clk),
    .serial_data(ui_in[0]),

    .thermostat_id(thermostat_id),
    .room_temp(room_temp),
    .set_temp(set_temp)
  );

endmodule
