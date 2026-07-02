import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_a_register(dut):

    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.loadA.value = 0
    dut.inp.value = 0
    dut.rst.value = 1

    await Timer(1, unit="ns")

    assert dut.out.value == 0

    dut.rst.value = 0

    await RisingEdge(dut.clk)

    dut.inp.value = 0x55
    dut.loadA.value = 1

    await RisingEdge(dut.clk)

    await Timer(1, unit="ns")

    assert dut.out.value == 0x55

    dut.loadA.value = 0
    dut.inp.value = 0xAA

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    assert dut.out.value == 0x55

    dut.loadA.value = 1
    dut.inp.value = 0xAA

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    assert dut.out.value == 0xAA

    dut.loadA.value = 0
    dut.inp.value = 0xEF

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    assert dut.out.value == 0xAA
