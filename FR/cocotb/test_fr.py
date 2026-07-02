import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles

@cocotb.test()
async def test(dut):

    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.load.value = 0
    dut.carry.value = 0
    dut.neg.value = 0
    dut.agtb.value = 0
    dut.aeqb.value = 0
    dut.zero.value = 0
    dut.rst.value = 1

    await Timer(1, unit="ns")

    assert dut.carry_out.value == 0
    assert dut.neg_out.value == 0
    assert dut.agtb_out.value == 0
    assert dut.aeqb_out.value == 0
    assert dut.zero_out.value == 0

    dut.rst.value = 0

    await RisingEdge(dut.clk)

    dut.load.value = 1
    dut.carry.value = 0
    dut.neg.value = 1
    dut.agtb.value = 0
    dut.aeqb.value = 1
    dut.zero.value = 0

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    assert dut.carry_out.value == 0
    assert dut.neg_out.value == 1
    assert dut.agtb_out.value == 0
    assert dut.aeqb_out.value == 1
    assert dut.zero_out.value == 0

    dut.carry.value = 1
    dut.neg.value = 0
    dut.agtb.value = 1
    dut.aeqb.value = 0
    dut.zero.value = 1

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    assert dut.carry_out.value == 1
    assert dut.neg_out.value == 0
    assert dut.agtb_out.value == 1
    assert dut.aeqb_out.value == 0
    assert dut.zero_out.value == 1