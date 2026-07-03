import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test(dut):

    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.rst.value = 1
    dut.clear.value = 0
    dut.enable.value = 0

    await Timer(1, unit="ns")

    dut.rst.value = 0

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    expected = 0

    for _ in range(10000):

        clear = random.randint(0,1)
        enable   = random.randint(0,1)

        dut.clear.value = clear 
        dut.enable.value   = enable

        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")

        if clear:
            expected = 0
        elif enable:
            expected = (expected + 1) & 0x7

        assert int(dut.out.value) == expected, (
            f"Expected {expected:02X}, "
            f"Got {int(dut.out.value)}, "
            f"clear={clear}, enable={enable}"
        )