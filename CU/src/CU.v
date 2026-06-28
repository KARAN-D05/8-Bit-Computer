// Control Unit

module CU #(
    parameter STATES = 8
)(
    input [$clog2(STATES)-1:0] t_state,
    input [7:0] opcode,
    input carry,
    input zero,
    input neg,
    input agtb,
    input aeqb,
    output reg load_A,
    output reg load_B,
    output reg load_PC,
    output reg enable_PC,
    output reg Write_RAM,
    output reg load_MAR,
    output reg load_FR,
    output reg load_IR,
    output reg [2:0] ALU_sel,
    output reg [2:0] Bus_Select,
    output reg TC_clear,
    output reg TC_enable
);

localparam NOP    = 8'h00;
    
localparam LOAD_A = 8'h01;
localparam LOAD_B = 8'h02;
localparam LDA   = 8'h03;
localparam LDB   = 8'h04;
localparam STA   = 8'h05;
localparam STB   = 8'h06;

localparam ADD   = 8'h20;
localparam SUB   = 8'h21;
localparam AND_  = 8'h22;   
localparam OR_   = 8'h23;   
localparam XOR_  = 8'h24;
localparam NOT_  = 8'h25;
localparam PASS_A = 8'h26;
localparam PASS_B = 8'h27;

localparam JMP   = 8'h40;
localparam JC    = 8'h41;
localparam JZ    = 8'h42;
localparam JEQ   = 8'h43;
localparam JGT   = 8'h44;
localparam JLT   = 8'h45;
localparam JN    = 8'h46;
localparam JNC   = 8'h47;
localparam JNZ   = 8'h48;
localparam HLT   = 8'h49;

  always @(*) begin

    load_A     = 0;
    load_B     = 0;
    load_PC    = 0;
    enable_PC  = 0;
    Write_RAM  = 0;
    load_MAR   = 0;
    load_FR    = 0;
    load_IR    = 0;

    ALU_sel    = 3'b000;
    Bus_Select = 3'b000;

    TC_clear   = 0;
    TC_enable  = 1;
      
    case (opcode)

    LOAD_A: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_A     = 1;
                Bus_Select = 3'b100;
                TC_clear   = 1;
            end

        endcase
    end

    LOAD_B: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_B     = 1;
                Bus_Select = 3'b100;
                TC_clear   = 1;
            end

        endcase
    end

    LDA: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_MAR   = 1;
            end

            3'd2: begin
                load_A     = 1;
                Bus_Select = 3'b011;
                TC_clear   = 1;
            end

        endcase
    end

    LDB: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_MAR   = 1;
            end

            3'd2: begin
                load_B    = 1;
                Bus_Select = 3'b011;
                TC_clear   = 1;
            end

        endcase
    end

    STA: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_MAR   = 1;
            end

            3'd2: begin
                Write_RAM = 1;
                TC_clear = 1;
            end

        endcase
    end

    STB: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_MAR   = 1;
            end

            3'd2: begin
                Write_RAM = 1;
                TC_clear = 1;
                Bus_Select = 3'b001;
            end

        endcase
    end

    ADD: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_A   = 1;
                load_FR = 1;
                Bus_Select = 3'b010;
                ALU_sel = 3'b000;
                TC_clear = 1;
            end

        endcase
    end

    SUB: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_A   = 1;
                load_FR = 1;
                Bus_Select = 3'b010;
                ALU_sel = 3'b001;
                TC_clear = 1;
            end

        endcase
    end

    AND_: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_A   = 1;
                load_FR = 1;
                Bus_Select = 3'b010;
                ALU_sel = 3'b010;
                TC_clear = 1;
            end

        endcase
    end

    OR_: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_A   = 1;
                load_FR = 1;
                Bus_Select = 3'b010;
                ALU_sel = 3'b011;
                TC_clear = 1;
            end

        endcase
    end

    XOR_: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_A   = 1;
                load_FR = 1;
                Bus_Select = 3'b010;
                ALU_sel = 3'b100;
                TC_clear = 1;
            end

        endcase
    end

    NOT_: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_A   = 1;
                load_FR = 1;
                Bus_Select = 3'b010;
                ALU_sel = 3'b101;
                TC_clear = 1;
            end

        endcase
    end

    PASS_A: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_A   = 1;
                load_FR = 1;
                Bus_Select = 3'b010;
                ALU_sel = 3'b110;
                TC_clear = 1;
            end

        endcase
    end

    PASS_B: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_A   = 1;
                load_FR = 1;
                Bus_Select = 3'b010;
                ALU_sel = 3'b111;
                TC_clear = 1;
            end

        endcase
    end

    JMP: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
                load_PC  = 1;
                TC_clear = 1;
            end

        endcase
    end

    JC: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
            if (carry)
                load_PC = 1;

            TC_clear = 1;
        end

        endcase
    end

    JZ: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
            if (zero)
                load_PC = 1;

            TC_clear = 1;
        end

        endcase
    end

    JGT: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
            if (agtb)
                load_PC = 1;

            TC_clear = 1;
        end

        endcase
    end

    JEQ: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
            if (aeqb)
                load_PC = 1;

            TC_clear = 1;
        end

        endcase
    end

    JN: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
            if (neg)
                load_PC = 1;

            TC_clear = 1;
        end

        endcase
    end

    JLT: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
            if (aeqb == 0 & agtb == 0)
                load_PC = 1;

            TC_clear = 1;
        end

        endcase
    end

    JNC: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
            if (~carry)
                load_PC = 1;

            TC_clear = 1;
        end

        endcase
    end

    JNZ: begin
        case (t_state)

            3'd0: begin
                load_IR   = 1;
                enable_PC = 1;
            end

            3'd1: begin
            if (~zero)
                load_PC = 1;

            TC_clear = 1;
        end

        endcase
    end

    HLT: begin
    case (t_state)

        3'd0: begin
            load_IR   = 1;
            enable_PC = 1;
        end

        3'd1: begin
            TC_enable = 0;
        end

        endcase
   end

    NOP: begin
    case (t_state)

        3'd0: begin
            load_IR   = 1;
            enable_PC = 1;
        end

        3'd1: begin
            TC_clear = 1;
        end

    endcase
end

 endcase
     
end

endmodule
