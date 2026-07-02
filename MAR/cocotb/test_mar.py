import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test (dut):

    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.load.value = 0
    dut.inp.value = 0
    dut.rst.value = 1

    await Timer(1, unit="ns")

    assert dut.out.value == 0

    dut.rst.value = 0

    await RisingEdge(dut.clk)

    dut.inp.value = 0xCC
    dut.load.value = 1

    await RisingEdge(dut.clk)

    await Timer(1, unit="ns")

    assert dut.out.value == 0xCC

    dut.load.value = 0
    dut.inp.value = 0x10

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    assert dut.out.value == 0xCC

    dut.load.value = 1
    dut.inp.value = 0x13

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    assert dut.out.value == 0x13

    dut.load.value = 0
    dut.inp.value = 0xEF

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    assert dut.out.value == 0x13