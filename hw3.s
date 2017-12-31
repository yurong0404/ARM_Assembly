.text
.align 2
.global main
main:
	sub v1,pc,#8;		@save first pc to v1
	stmfd sp!,{fp,lr}   @save fp,lr to sp
	
	@---print title---------
	ldr a1,=StringTitle
	bl printf
	@----------------------
	
	mov lr,pc
	add lr,lr,#4
	b Loop
	b End
	
Loop:
	stmfd sp!,{v1-v5,lr}
	@----check Mark-----------------
	ldr a1,[v1],#4		@fetch machine code
	ldr a2,=Mark		@get Mark PC
	sub a3,v1,#4
	cmp a2,a3			@if read the PC of Mark,then return
	beq return
	mov v2,a1,LSR #20	@shift first 12 bit
	@----print pc----------
	ldr a1,=StringPC
	mov a2,v1			@v1 = pc
	sub a2,a2,#616		@turn PC to relative
	bl printf
	@-----cond------------------------------
	and a2,v2,#0xF00	@pick cond code
	mov a2,a2,LSR #8
	cmp a2,#0
	ldreq a1,=StringEQ
	beq PrintCond
	cmpne a2,#1
	ldreq a1,=StringNE
	beq PrintCond
	cmpne a2,#2
	ldreq a1,=StringCSHS
	beq PrintCond
	cmpne a2,#3
	ldreq a1,=StringCCLO
	beq PrintCond
	cmpne a2,#4
	ldreq a1,=StringMI
	beq PrintCond
	cmpne a2,#5
	ldreq a1,=StringPL
	beq PrintCond
	cmpne a2,#6
	ldreq a1,=StringVS
	beq PrintCond
	cmpne a2,#7
	ldreq a1,=StringVC
	beq PrintCond
	cmpne a2,#8
	ldreq a1,=StringHI
	beq PrintCond
	cmpne a2,#9
	ldreq a1,=StringLS
	beq PrintCond
	cmpne a2,#10
	ldreq a1,=StringGE
	beq PrintCond
	cmpne a2,#11
	ldreq a1,=StringLT
	beq PrintCond
	cmpne a2,#12
	ldreq a1,=StringGT
	beq PrintCond
	cmpne a2,#13
	ldreq a1,=StringLE
	beq PrintCond
	cmpne a2,#14
	ldreq a1,=StringAL
	beq PrintCond
	cmpne a2,#15
	ldreq a1,=StringNV
	PrintCond:
	bl printf
	@----end of cond----------------
	@------instruction---------------
	and a2,v2,#0x0FF	@pick 8 bits
	cmp a2,#0x12		@check bx	
	ldreq a1,=StringXXX
	beq PrintInst
	and a2,v2,#0x0C0	@check data processing instruction
	cmp a2,#000
	ldrne a1,=StringXXX
	bne PrintInst
	mov a2,v2,LSR #1
	and a2,a2,#0x00F	@pick opcode
	cmp a2,#0
	ldreq a1,=StringAND
	beq PrintInst
	cmpne a2,#1
	ldreq a1,=StringEOR
	beq PrintInst
	cmpne a2,#2
	ldreq a1,=StringSUB
	beq PrintInst
	cmpne a2,#3
	ldreq a1,=StringRSB
	beq PrintInst
	cmpne a2,#4
	ldreq a1,=StringADD
	beq PrintInst
	cmpne a2,#5
	ldreq a1,=StringADC
	beq PrintInst
	cmpne a2,#6
	ldreq a1,=StringSBC
	beq PrintInst
	cmpne a2,#7
	ldreq a1,=StringRSC
	beq PrintInst
	cmpne a2,#8
	ldreq a1,=StringTST
	beq PrintInst
	cmpne a2,#9
	ldreq a1,=StringTEQ
	beq PrintInst
	cmpne a2,#10
	ldreq a1,=StringCMP
	beq PrintInst
	cmpne a2,#11
	ldreq a1,=StringCMN
	beq PrintInst
	cmpne a2,#12
	ldreq a1,=StringORR
	beq PrintInst
	cmpne a2,#13
	ldreq a1,=StringMOV
	beq PrintInst
	cmpne a2,#14
	ldreq a1,=StringBIC
	beq PrintInst
	cmpne a2,#15
	ldreq a1,=StringMVN
	PrintInst:
	bl printf
	ldr a1,=StringNextLine
	bl printf
	@----end of instruction----------
	b Loop+4
	return:
	ldmfd sp!,{v1-v5,lr}
	bx lr
End:                     @why can't End be put at the end of file
    ldmfd sp! ,{fp,lr}   @load sp back to fp,lr
    mov pc,lr            @return

Mark:

StringTitle:
	.asciz "PC\tcondition\tinstruction\n"
StringPC:
	.asciz "%d\t"
StringNextLine:
	.asciz "\n"
StringEQ:.asciz "EQ\t\t"		@0000
StringNE:.asciz "NE\t\t"		@0001
StringCSHS:.asciz "CS/HS\t\t"	@0010
StringCCLO:.asciz "CC/LO\t\t"	@0011
StringMI:.asciz "MI\t\t"		@0100
StringPL:.asciz "PL\t\t"		@0101
StringVS:.asciz "VS\t\t"		@0110
StringVC:.asciz "VC\t\t"		@0111
StringHI:.asciz "HI\t\t"		@1000
StringLS:.asciz "LS\t\t"		@1001
StringGE:.asciz "GE\t\t"		@1010
StringLT:.asciz "LT\t\t"		@1011
StringGT:.asciz "GT\t\t"		@1100
StringLE:.asciz "LE\t\t"		@1101
StringAL:.asciz "AL\t\t"		@1110
StringNV:.asciz "NV\t\t"		@1111
StringXXX:.asciz "xxx"
StringAND:.asciz "AND"		@0000
StringEOR:.asciz "EOR"		@0001
StringSUB:.asciz "SUB"		@0010
StringRSB:.asciz "RSB"		@0011
StringADD:.asciz "ADD"		@0100
StringADC:.asciz "ADC"		@0101
StringSBC:.asciz "SBC"		@0110
StringRSC:.asciz "RSC"		@0111
StringTST:.asciz "TST"		@1000
StringTEQ:.asciz "TEQ"		@1001
StringCMP:.asciz "CMP"		@1010
StringCMN:.asciz "CMN"		@1011
StringORR:.asciz "ORR"		@1100
StringMOV:.asciz "MOV"		@1101
StringBIC:.asciz "BIC"		@1110
StringMVN:.asciz "MVN"		@1111
