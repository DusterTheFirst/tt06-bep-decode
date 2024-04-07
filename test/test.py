# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-FileCopyrightText: © 2024 Zachary Kohnen <z.j.kohnen@student.tue.nl>
# SPDX-License-Identifier: MIT

import math
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.handle import HierarchyObject, LogicObject, LogicArray, Range


class TopLevelDUT(HierarchyObject):
    ui_in: LogicObject  # Dedicated inputs [7:0]
    uo_out: LogicObject  # Dedicated outputs [7:0]
    uio_in: LogicObject  # IOs: Input path
    uio_out: LogicObject  # IOs: Output path
    uio_oe: LogicObject  # IOs: Enable path (active high: 0=input, 1=output)
    ena: LogicObject  # will go high when the design is enabled
    clk: LogicObject  # clock
    rst_n: LogicObject  # reset_n - low to reset


# @cocotb.test()
# async def test_adder(dut: TopLevelDUT):
#     dut._log.info("Start")

#     # Our example module doesn't use clock and reset, but we show how to use them here anyway.
#     clock = Clock(dut.clk, 10, units="us")
#     cocotb.start_soon(clock.start())

#     # Reset
#     dut._log.info("Reset")
#     dut.ena.value = LogicArray(0b1)
#     dut.ui_in.value = LogicArray(0b0, Range(7, 0))
#     dut.uio_in.value = LogicArray(0b0, Range(7, 0))
#     dut.rst_n.value = LogicArray(0b0)
#     await ClockCycles(dut.clk, 10)
#     dut.rst_n.value = LogicArray(0b1)

#     # Set the input values, wait one clock cycle, and check the output
#     dut._log.info("Test")
#     # seven_segment_decimal_value = dut.ui_in[3:0]
#     for i in range(2 ** 8):
#         dut.ui_in.set(i)
#         await ClockCycles(dut.clk, ((2 ** 3) * 2))
#         dut.ui_in.set(i + 1)
#         await ClockCycles(dut.clk, (2 ** 3))

#     seven_segment_decimal = dut.uo_out
#     seven_segment_hex = dut.uio_out

#     # assert dut.uo_out.value == 50
#     # assert dut.uio_out.value == 0

@cocotb.test()
async def shift_in(dut: TopLevelDUT):
    dut._log.info("Start")

    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = LogicArray(0b1)
    dut.ui_in.value = LogicArray(0b0, Range(7, 0))
    dut.uio_in.value = LogicArray(0b0, Range(7, 0))
    dut.rst_n.value = LogicArray(0b0)
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = LogicArray(0b1)

    dut._log.info("Test")

    test_case = 0b101010101010101010101010101010101101001110010001110100111001000100001101111111111111111111111110000000100011100100011111100111110000000011000000000000001100100001100100010100000000110001001010
    bits = math.ceil(math.log2(test_case))
    test_case_bits = [(test_case >> bit) & 1 for bit in range(bits - 1, -1, -1)]

    for i in test_case_bits:
        await ClockCycles(dut.clk, 1, rising = False)
        dut.ui_in[0].set(i)
        await ClockCycles(dut.clk, 1, rising = True)

    dut.rst_n.value = LogicArray(0b0)
    await ClockCycles(dut.clk, 10)