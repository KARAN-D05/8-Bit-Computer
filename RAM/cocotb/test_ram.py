import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


@cocotb.test()
async def test(dut):

    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    random.seed(42)

    expected_mem = [0] * 256

    dut.write.value = 0
    dut.inp.value = 0
    dut.addr.value = 0

    await Timer(1, unit="ns")

    for _ in range(100000):

        addr = random.randint(0, 255)
        data = random.randint(0, 255)

        dut.addr.value = addr
        dut.inp.value = data
        dut.write.value = 1

        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")

        expected_mem[addr] = data
        expected = expected_mem[addr]

        dut.write.value = 0

        read_addr = random.randint(0, 255)

        dut.addr.value = read_addr

        await Timer(1, unit="ns")

        expected = expected_mem[read_addr]

        assert int(dut.out.value) == expected, (
            f"ADDR={read_addr:02X} "
            f"Expected={expected:02X} "
            f"Got={int(dut.out.value):02X}"
        )