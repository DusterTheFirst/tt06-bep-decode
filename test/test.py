# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-FileCopyrightText: © 2024 Zachary Kohnen <z.j.kohnen@student.tue.nl>
# SPDX-License-Identifier: MIT

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


@cocotb.test()
async def test_adder(dut: TopLevelDUT):
    dut._log.info("Start")

    # Our example module doesn't use clock and reset, but we show how to use them here anyway.
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

    # Set the input values, wait one clock cycle, and check the output
    dut._log.info("Test")
    # seven_segment_decimal_value = dut.ui_in[3:0]
    dut.ui_in.set(20)

    await ClockCycles(dut.clk, 1)

    seven_segment_decimal = dut.uo_out
    seven_segment_hex = dut.uio_out

    assert dut.uo_out.value == 50
    assert dut.uio_out.value == 0
