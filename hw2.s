.text
.align 2
.global main
main:
    stmfd sp!,{fp,lr}   @save fp,lr to sp
    ldr v2,[a2,#12]		@load intB to a3
	ldr v3,[a2,#16]		@load intp to a4
	ldr v1,[a2,#8]		@load intA to a2
	bl ReadIntA
	bl ReadIntB
	ldrb v3,[v3]
	sub v3,v3,#48		@turn intp ascii code to integer
	adr v4,JUMPTABLE
    cmp v3,#8			@TABLEMAX=9
    mov lr,pc
    add lr,lr,#4		@lr store => b Print
    ldrls pc,[v4,v3,lsl #2]	@switch
    b End

JUMPTABLE:
	.word CASE0 
	.word CASE1 
	.word CASE2 
	.word CASE3 
	.word CASE4 
	.word CASE5 
	.word CASE6
	.word CASE7 
	.word CASE8
CASE0:					@add
	stmfd sp!,{lr}
	mov a2,v1			@arg1
	mov a3,v2			@arg2
	bl Intp0
	mov a4,a1
	ldr a1,=String0
	mov a2,v1
	mov a3,v2
	bl printf
	ldmfd sp!,{lr}
	bx lr	
CASE1:					@sub
	stmfd sp!,{lr}
	mov a2,v1			@arg1
	mov a3,v2			@arg2
	bl Intp1
	mov a4,a1
	ldr a1,=String1
	mov a2,v1
	mov a3,v2
	bl printf
	ldmfd sp!,{lr}
	bx lr
CASE2:					@rbit
	stmfd sp!,{lr}
	mov a2,v1			@arg2=IntA
	bl Intp2
	mov a3,a1
	ldr a1,=String2
	mov a2,v1
	bl printf
	ldmfd sp!,{lr}
	bx lr
CASE3:					@devide
	stmfd sp!,{lr}
	mov a2,v1			@arg1
	mov a3,v2			@arg2
	bl Intp3
	mov a4,a1
	ldr a1,=String3
	mov a2,v1
	mov a3,v2
	bl printf
	ldmfd sp!,{lr}
	bx lr
CASE4:					@max
	stmfd sp!,{lr}
	mov a2,v1			@arg1
	mov a3,v2			@arg2
	bl Intp4
	mov a4,a1
	ldr a1,=String4
	mov a2,v1
	mov a3,v2
	bl printf
	ldmfd sp!,{lr}
	bx lr
CASE5:					@exp
	stmfd sp!,{lr}
	mov a2,v1			@arg1
	mov a3,v2			@arg2
	bl Intp5
	mov a4,a1
	ldr a1,=String5
	mov a2,v1
	mov a3,v2
	bl printf
	ldmfd sp!,{lr}
	bx lr
CASE6:					@gcd
	stmfd sp!,{lr}
	mov a2,v1			@arg1
	mov a3,v2			@arg2
	bl Intp6
	mov a4,a1
	ldr a1,=String6
	mov a2,v1
	mov a3,v2
	bl printf
	ldmfd sp!,{lr}
	bx lr
CASE7:					@long mul
	stmfd sp!,{lr}
	mov a2,v1			@arg1
	mov a3,v2			@arg2
	bl Intp7
	mov a4,a1
	stmfd sp!,{a2}
	ldr a1,=String7
	mov a2,v1
	mov a3,v2
	bl printf
	ldmfd sp!,{v1}
	ldmfd sp!,{lr}
	bx lr
CASE8:					@lcm
	stmfd sp!,{lr}
	mov a2,v1			@arg1
	mov a3,v2			@arg2
	bl Intp8
	mov a4,a1
	ldr a1,=String8
	mov a2,v1
	mov a3,v2
	bl printf
	ldmfd sp!,{lr}
	bx lr

ReadIntA:
	mov a1,v1			@move IntA data from main to func 
	mov a2,#0			@v2 is used to store number IntA
	ldrb a3,[a1],#1		@load one byte from parameter
	mov a4,#10			@v4=10
	cmp a3,#0			@check the loaded char is \0 or not
	moveq v1,a2			@return IntA to a2
	bxeq lr				@branch back to the link if v3 is space
	mul a2,a4,a2		@if a1 isn't space IntA=IntA*10
	sub a3,a3,#48		@and turn the new digit from ascii to number
	add a2,a2,a3		@IntA=IntA+digit
	b ReadIntA+8		@branch to ldrb instruction
ReadIntB:
	mov a1,v2			@move IntB data from main to func 
	mov a2,#0			@v2 is used to store number IntB
	ldrb a3,[a1],#1		@load one byte from parameter
	mov a4,#10			@v4=10
	cmp a3,#0			@check the loaded char is \0 or not
	moveq v2,a2			@return IntB to a2
	bxeq lr				@branch back to the link if v3 is space
	mul a2,a4,a2		@if a1 isn't space IntB=IntB*10
	sub a3,a3,#48		@and turn the new digit from ascii to number
	add a2,a2,a3		@IntB=IntB+digit
	b ReadIntB+8		@branch to ldrb instruction

Intp0:
    add a1,a2,a3		@execute addition
    bx lr
Intp1:
    sub a1,a2,a3		@execute subtraction
    bx lr
Intp2: 
	stmfd sp!,{a2}
	mov a3,#0			@a3 is used to count to 32
	mov a4,#0			@a4 is used to store reverse IntA
	and a1,a2,#1		@a1=>temp
	add a4,a4,a1		@IntA[0]=a1[0]
	add a3,a3,#1		@counter++
	cmp a3,#32			@check counter==32
	movlt a4,a4,ASL #1	@a4 clean a space to store next bit of IntA
	movlt a2,a2,ASR #1	@a2 shift right to store new bit
	blt Intp2+12		@loop,branch => AND a1,a2,#1
	mov a1,a4			@return
	ldmfd sp!,{a2}
    bx lr
Intp3:
	stmfd sp!,{a2,a3}
    mov a4,#0			@a4 is used to be quotient
    cmp a2,a3			@compare divident with divisor
	subge a2,a2,a3		@if divident > divisor => do sub
    addge a4,a4,#1		@quotient++
    bge Intp3+8		@loop
    mov a1,a4
	ldmfd sp!,{a2,a3}
    bx lr
Intp4:
	cmp a2,a3			@compare
	movge a1,a2			@return
	movlt a1,a3			@return
    bx lr
    
Intp5:
	mov a4,#0			@counter to check the multiple times
	mov a1,#1			@multiplier
	mul a1,a2,a1		@multiple
	add a4,a4,#1		@count++
	cmp a4,a3			@chech the times
	blt Intp5+8		@loop
    bx lr
    
Intp6:
	cmp a2,a3			@compare
	bge l1
	blt l2
	l1:					@a2/a3
		sub a2,a2,a3
		cmp a2,#0
		beq l3
		b Intp6
	l2:					@a2/a3
		sub a3,a3,a2
		cmp a3,#0
		beq l4
		b Intp6
	l3:					@gcd found
		mov a1,a3
		bx lr
	l4:					@gcd found
		mov a1,a2
		bx lr
Intp7:
	smull a1,a4,a2,a3	@long multiply
	mov a2,a1
	mov a1,a4
	bx lr
Intp8:					@lcm = IntA*IntB/gcd
	stmfd sp!,{lr}
	stmfd sp!,{a2,a3}
	
	bl Intp6			@call gcd func
	ldmfd sp!,{a2,a3}
	mov a4,a1			@a4=gcd of IntA and IntB 
	mul a1,a2,a3		@a1=IntA*IntB
	mov a2,a1			@argument1 of Intp3
	mov a3,a4			@argument2 of Intp3
	bl Intp3			@call division func
	mov a1,a1			@return
    ldmfd sp!,{lr}
    bx lr

End:                     @why can't End be put at the end of file
    ldmfd sp! ,{fp,lr}   @load sp back to fp,lr
    mov pc,lr            @return
    
String0:
    .asciz "Function 0: addition of %d and %d is %d."
String1:
    .asciz "Function 1: subtraction of %d and %d is %d."
String2:
	.asciz "Function 2: Bit-reverse of %d (dec) is %08X (hex)."
String3:
	.asciz "Function 3: division of %d and %d is %d."
String4:
	.asciz "Function 4: maximun of %d and %d is %d."
String5:
	.asciz "Function 5: %d to the power of %d is %d."
String6:
	.asciz "Function 6: greatest common divisor of %d and %d is %d."
String7: 
	.asciz "Function 7: Long-multiplication of %08X (hex) and %08X (hex) is %08X %08X (hex)."
String8: 
	.asciz "Function 8: least common multiply of %d and %d is %d."
