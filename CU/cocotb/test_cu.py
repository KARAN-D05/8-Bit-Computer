import cocotb
from cocotb.triggers import Timer

LOAD_A = 0x01
LDA    = 0x03
STA    = 0x05
ADD    = 0x20
JMP    = 0x40
JC     = 0x41
HLT    = 0x49


@cocotb.test()
async def test_load_a(dut):

    dut.opcode.value = LOAD_A

    dut.t_state.value = 0
    await Timer(1, unit="ns")

    assert dut.load_IR.value == 1
    assert dut.enable_PC.value == 1

    dut.t_state.value = 1
    await Timer(1, unit="ns")

    assert dut.load_A.value == 1
    assert dut.Bus_Select.value == 4
    assert dut.TC_clear.value == 1


@cocotb.test()
async def test_lda(dut):

    dut.opcode.value = LDA

    dut.t_state.value = 0
    await Timer(1, unit="ns")

    assert dut.load_IR.value == 1
    assert dut.enable_PC.value == 1

    dut.t_state.value = 1
    await Timer(1, unit="ns")

    assert dut.load_MAR.value == 1

    dut.t_state.value = 2
    await Timer(1, unit="ns")

    assert dut.load_A.value == 1
    assert dut.Bus_Select.value == 3
    assert dut.TC_clear.value == 1


@cocotb.test()
async def test_sta(dut):

    dut.opcode.value = STA

    dut.t_state.value = 0
    await Timer(1, unit="ns")

    assert dut.load_IR.value == 1
    assert dut.enable_PC.value == 1

    dut.t_state.value = 1
    await Timer(1, unit="ns")

    assert dut.load_MAR.value == 1

    dut.t_state.value = 2
    await Timer(1, unit="ns")

    assert dut.Write_RAM.value == 1
    assert dut.TC_clear.value == 1


@cocotb.test()
async def test_add(dut):

    dut.opcode.value = ADD

    dut.t_state.value = 0
    await Timer(1, unit="ns")

    assert dut.load_IR.value == 1
    assert dut.enable_PC.value == 1

    dut.t_state.value = 1
    await Timer(1, unit="ns")

    assert dut.load_A.value == 1
    assert dut.load_FR.value == 1
    assert dut.Bus_Select.value == 2
    assert dut.ALU_sel.value == 0
    assert dut.TC_clear.value == 1


@cocotb.test()
async def test_jmp(dut):

    dut.opcode.value = JMP

    dut.t_state.value = 0
    await Timer(1, unit="ns")

    assert dut.load_IR.value == 1
    assert dut.enable_PC.value == 1

    dut.t_state.value = 1
    await Timer(1, unit="ns")

    assert dut.load_PC.value == 1
    assert dut.TC_clear.value == 1


@cocotb.test()
async def test_jc(dut):

    dut.opcode.value = JC

    # Carry = 0
    dut.carry.value = 0
    dut.t_state.value = 1

    await Timer(1, unit="ns")

    assert dut.load_PC.value == 0
    assert dut.TC_clear.value == 1

    # Carry = 1
    dut.carry.value = 1

    await Timer(1, unit="ns")

    assert dut.load_PC.value == 1
    assert dut.TC_clear.value == 1


@cocotb.test()
async def test_hlt(dut):

    dut.opcode.value = HLT

    dut.t_state.value = 0
    await Timer(1, unit="ns")

    assert dut.load_IR.value == 1
    assert dut.enable_PC.value == 1

    dut.t_state.value = 1
    await Timer(1, unit="ns")

    assert dut.TC_enable.value == 0