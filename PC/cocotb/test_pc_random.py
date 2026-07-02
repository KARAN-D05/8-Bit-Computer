import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test(dut):

    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.rst.value = 1
    dut.load.value = 0
    dut.en.value = 0
    dut.inp.value = 0

    await Timer(1, unit="ns")

    dut.rst.value = 0

    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    expected = 0

    for _ in range(1000):

        load = random.randint(0,1)
        en   = random.randint(0,1)
        inp  = random.randint(0,255)

        dut.load.value = load
        dut.en.value   = en
        dut.inp.value  = inp

        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")

        if load:
            expected = inp
        elif en:
            expected = (expected + 1) & 0xFF

        assert int(dut.out.value) == expected, (
            f"Expected {expected:02X}, "
            f"Got {int(dut.out.value)}, "
            f"load={load}, en={en}, inp={inp:02X}"
        )
