import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

async def reset(dut):

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0


def clear_ram(dut):

    for i in range(256):
        dut.ram_inst.mem[i].value = 0


async def run_until_halt(dut, timeout=50000):

    for _ in range(timeout):

        await RisingEdge(dut.clk)

        if int(dut.TC_enable.value) == 0:
            return

    assert False, "Processor did not halt."

@cocotb.test()
async def test_maximum(dut):

    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    for _ in range(100):

        clear_ram(dut)
        await reset(dut)

        a = random.randint(0,255)
        b = random.randint(0,255)

        dut.ram_inst.mem[0x08].value = a
        dut.ram_inst.mem[0x09].value = b

        expected = max(a,b)

        await run_until_halt(dut)

        result = int(dut.ram_inst.mem[0x0A].value)

        assert result == expected, (
            f"MAX FAILED  "
            f"A={a:02X} "
            f"B={b:02X} "
            f"Expected={expected:02X} "
            f"Got={result:02X}"
        )

@cocotb.test()
async def test_multiplication(dut):

    cocotb.start_soon(Clock(dut.clk,10,unit="ns").start())

    for _ in range(1000):

        clear_ram(dut)
        await reset(dut)

        multiplicand = random.randint(0,15)
        multiplier   = random.randint(0,15)

        dut.ram_inst.mem[0x06].value = 1
        dut.ram_inst.mem[0x07].value = multiplicand
        dut.ram_inst.mem[0x08].value = multiplier

        expected = multiplicand * multiplier

        await run_until_halt(dut)

        result = int(dut.ram_inst.mem[0x09].value)

        assert result == expected, (
            f"MULT FAILED  "
            f"{multiplicand} x {multiplier} "
            f"Expected={expected:02X} "
            f"Got={result:02X}"
        )

@cocotb.test()
async def test_matrix_multiplication(dut):

    cocotb.start_soon(Clock(dut.clk,10,unit="ns").start())

    for _ in range(250):

        clear_ram(dut)
        await reset(dut)

        A = [
            [random.randint(0,7), random.randint(0,7)],
            [random.randint(0,7), random.randint(0,7)]
        ]

        B = [
            [random.randint(0,7), random.randint(0,7)],
            [random.randint(0,7), random.randint(0,7)]
        ]

        dut.ram_inst.mem[0x00].value = A[0][0]
        dut.ram_inst.mem[0x01].value = A[0][1]
        dut.ram_inst.mem[0x02].value = A[1][0]
        dut.ram_inst.mem[0x03].value = A[1][1]

        dut.ram_inst.mem[0x04].value = B[0][0]
        dut.ram_inst.mem[0x05].value = B[0][1]
        dut.ram_inst.mem[0x06].value = B[1][0]
        dut.ram_inst.mem[0x07].value = B[1][1]

        C00 = A[0][0]*B[0][0] + A[0][1]*B[1][0]
        C01 = A[0][0]*B[0][1] + A[0][1]*B[1][1]
        C10 = A[1][0]*B[0][0] + A[1][1]*B[1][0]
        C11 = A[1][0]*B[0][1] + A[1][1]*B[1][1]

        await run_until_halt(dut)

        assert int(dut.ram_inst.mem[0x10].value) == (C00 & 0xFF)
        assert int(dut.ram_inst.mem[0x11].value) == (C01 & 0xFF)
        assert int(dut.ram_inst.mem[0x12].value) == (C10 & 0xFF)
        assert int(dut.ram_inst.mem[0x13].value) == (C11 & 0xFF)