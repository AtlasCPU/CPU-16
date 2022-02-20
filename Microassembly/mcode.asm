;ATLAS CPU-16 Microcode v1.0
;Hayden Buscher - 2022

;PC_ST, OP1_ST, OP2_ST, IR_ST, MDR_ST, MEM_ST, REG1_ST, REG2_ST, SP_ST, STAT_ST
;F_DOUT, PC_DOUT, SWP_DOUT, WRD_DOUT, MDR_DOUT, MEM_DOUT, VECT_DOUT, REG1_DOUT, REG2_DOUT, SP_DOUT
;PC_AOUT, MAR_AOUT
;COND_N, COND_Z, COND_V, COND_C
;ALU_ADD, ALU_ADC, ALU_SUB, ALU_SBB, ALU_AND, ALU_OR, ALU_XOR, ALU_NOT, ALU_LSH, ALU_RSH, ALU_INC, ALU_DEC, ALU_SEX
;PC_INC, COND_POS
;F_ALUIN, F_ST
;MAR_ST, IRQ_EN
;MODE_RST, MODE_DMA, MODE_FLT, MODE_FETCH

;First half of mCode ROM

$0	;CTRL1
MODE_RST,@RST	;0000 - RST
PC_INC,@HLT	;0001 - HLT
PC_INC,@FETCH	;0002 - CAL
PC_INC,@FETCH	;0003 - NOP
PC_INC,@FETCH	;0004 - NOP
PC_INC,@FETCH	;0005 - NOP
PC_INC,@FETCH	;0006 - NOP
PC_INC,@FETCH	;0007 - RTS

$8	;CTRL2
PC_INC,F_DOUT,REG2_ST,@FETCH	;0010 - STF [reg]
PC_INC,@FETCH	;0011 - NOP
PC_INC,@FETCH	;0012 - NOP
PC_INC,@FETCH	;0013 - NOP
PC_INC,REG2_DOUT,SWP_ST,@SWP	;0014 - SWP [reg]
PC_INC,REG1_DOUT,MDR_ST,@EXG	;0015 - EXG [reg],[reg]
PC_INC,SP_DOUT,OP1_ST,@LNK	;0016 - LNK
PC_INC,REG2_DOUT,OP1_ST,MAR_ST,@ULNK	;0017 - ULNK

$10	;FLGS
PC_INC,F_DOUT,OP1_ST,@ANF	;0020 - ANF $m
PC_INC,F_DOUT,OP1_ST,@ORF	;0021 - ORF $m
PC_INC,F_DOUT,OP1_ST,@XOF	;0022 - XOF $m
PC_INC,REG2_DOUT,F_ST,@FETCH	;0023 - LDF
PC_INC,STAT_DOUT,OP1_ST,@ANT	;0024- ANT $m
PC_INC,STAT_DOUT,OP1_ST,@ORT	;0025 - ORT $m
PC_INC,STAT_ST_DOUT,OP1_ST,@XOT	;0025 - XOT $m
PC_INC,REG2_DOUT,STAT_ST,@FETCH	;0027 - LDT

$18	;JMP [ads]
PC_INC,@FETCH	;0030 - NOP
PC_INC,@JMP_#m	;0031 - JMP $m
PC_INC,@JMP_#m_REL	;0032 - JMP $m(PC)
REG2_DOUT,PC_ST,@FETCH	;0033 - JMP (reg)
PC_INC,REG2_DOUT,OP1_ST,@JMP_RIND	;0034 - JMP $m(reg)
PC_INC,REG2_DOUT,OP1_ST,@JMP_PINC	;0035 - JMP (reg)+
PC_INC,REG2_DOUT,OP1_ST,@JMP_PDEC	;0036 - JMP -(reg)
PC_INC,@FETCH	;0037 - NOP

$20
PC_INC,@FETCH	;0040 - NOP
PC_INC,@JSR_#m	;0041 - JSR $m
PC_INC,@JSR_#m_REL	;0042 - JSR $m(PC)
REG2_DOUT,PC_ST,@FETCH	;0043 - JSR (reg)
PC_INC,REG2_DOUT,OP1_ST,@JSR_RIND	;0044 - JSR $m(reg)
PC_INC,REG2_DOUT,OP1_ST,@JSR_PINC	;0045 - JSR (reg)+
PC_INC,REG2_DOUT,OP1_ST,@JSR_PDEC	;0046 - JSR -(reg)
PC_INC,@FETCH	;0047 - NOP




$2D
PC_INC,COND_Z,@JMP_#m_REL	;0055 - BNE $m(PC)

$40
PC_INC,REG1_DOUT,MDR_ST,@MOV_REG_REG	;0100 - MOV [reg],[reg]
PC_INC,REG1_DOUT,MDR_ST,@MOV_REG_DIR	;0101 - MOV [reg],$m

$69
PC_INC,REG1_DOUT,MAR_ST,OP1_ST,@MOV_PINC_DIR	;0151 - MOV (reg)+,$m

$78
PC_INC,@MOV_#m_REG	;0170 - MOV #m,[reg]

$27B
PC_INC,@CMP_#m_IREG	;1173 - CMP #m,(reg)


;Second half of mCode ROM
$407
MODE_RST,@RST	;RST VECTOR

$408																				
.@FETCH
MODE_FETCH,IRQ_EN,PC_AOUT,MEM_DOUT,IR_ST
.@INC_PC_END
PC_INC,@FETCH

;000x
.@RST
MODE_RST,F_ST,STAT_ST,+1
MODE_RST,WRD_DOUT,MAR_ST,+1
MODE_RST,MAR_AOUT,MEM_DOUT,PC_ST,@FETCH
.@HLT
IRQ_EN,@HLT
.@RTS

.@SWP
SWP_DOUT,REG2_ST,@FETCH
.@EXG
@FETCH
.@LNK
ALU_DEC,MDR_ST,MAR_ST,+1
REG2_DOUT,MAR_AOUT,MEM_ST,+1
MDR_DOUT,REG2_ST,+1
MDR_DOUT,OP1_ST,+1
PC_AOUT,MEM_DOUT,OP2_ST,+1
PC_INC,ALU_ADD,SP_ST,@FETCH
.@ULNK
MAR_AOUT,MEM_DOUT,REG2_ST,+1
ALU_INC,SP_ST,@FETCH

;001x
.@ANF
PC_AOUT,MEM_DOUT,OP2_ST,+1
PC_INC,ALU_AND,F_ST,@FETCH
.@ORF
PC_AOUT,MEM_DOUT,OP2_ST,+1
PC_INC,ALU_OR,F_ST,@FETCH
.@XOF
PC_AOUT,MEM_DOUT,OP2_ST,+1
PC_INC,ALU_XOR,F_ST,@FETCH
.@ANT
PC_AOUT,MEM_DOUT,OP2_ST,+1
PC_INC,ALU_AND,STAT_ST_ST,@FETCH
.@ORT
PC_AOUT,MEM_DOUT,OP2_ST,+1
PC_INC,ALU_OR,STAT_ST,@FETCH
.@XOT
PC_AOUT,MEM_DOUT,OP2_ST,+1
PC_INC,ALU_XOR,STAT_ST,@FETCH

;002x
.@JMP_#m
PC_AOUT,MEM_DOUT,MDR_ST,+1
MDR_DOUT,PC_ST,@FETCH
.@JMP_#m_REL
PC_DOUT,OP1_ST,+1
PC_AOUT,MEM_DOUT,OP2_ST,@ADD_PC_ST
.@JMP_RIND
PC_AOUT,MEM_DOUT,OP2_ST,@ADD_PC_ST
.@ADD_PC_ST
ALU_ADD,PC_ST,@FETCH
.@JMP_PINC
REG2_DOUT,PC_ST,+1
ALU_INC,REG2_ST,@FETCH
.@JMP_PDEC
ALU_DEC,REG2_ST,+1
ALU_DEC,PC_ST,@FETCH

;003x
.@JSR_#m
PC_AOUT,MEM_DOUT,MDR_ST,+1
MDR_DOUT,PC_ST,@FETCH





;ALU_DEC,MAR_ST,SP_ST,+1
;MAR_AOUT,PC_DOUT,MEM_ST,+1
;SP_DOUT,OP1_ST,+1
;ALU_DEC,MAR_ST,SP_ST,+1
;MAR_AOUT,F_DOUT,MEM_ST,@JMP_#m
;.@JSR_#m_REL
;ALU_DEC,MAR_ST,SP_ST,+1
;MAR_AOUT,PC_DOUT,MEM_ST,+1
;SP_DOUT,OP1_ST,+1
;ALU_DEC,MAR_ST,SP_ST,+1
;MAR_AOUT,F_DOUT,MEM_ST,@JMP_#m_REL



.@MOV_REG_REG
MDR_DOUT,REG2_ST,@FETCH

.@MOV_REG_DIR
PC_AOUT,MDR_DOUT,MEM_ST,@INC_PC_END

.@MOV_PINC_DIR
MAR_AOUT,MEM_DOUT,MDR_ST,+1
PC_AOUT,MEM_DOUT,MAR_ST,+1
PC_INC,MDR_DOUT,MAR_AOUT,MEM_ST,+1
ALU_INC,REG1_ST,@FETCH

.@MOV_#m_REG
PC_AOUT,MEM_DOUT,REG2_ST,@INC_PC_END

.@CMP_#m_IREG
PC_AOUT,MEM_DOUT,OP1_ST,+1
PC_INC,REG2_DOUT,MAR_ST,+1
MAR_AOUT,MEM_DOUT,OP2_ST,+1
ALU_SUB,F_ST,@FETCH