/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none
`include "seven_segment_decode.v"
`include "binary_to_bcd.v"
`include "serial_decode.v"

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
  assign uo_out = 0;
  // assign uio_out = {seven_segment_hex, 1'b0};
  assign uio_out = 8'b00000000;
  assign uio_oe  = 8'b00000000;

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

  serial_decode data_decode (
    .reset(!rst_n),
    .serial_clock(clk),
    .serial_data(ui_in[0])
  );

endmodule
