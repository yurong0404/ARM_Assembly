.text
.align 2
.global main
main:
    stmfd sp! ,{fp,lr}   @save fp,lr to sp
    ldr r4,[r1,#4]       @load agrs data
    ldr r0,=string
    bl printf            @print the data in r0
    
Read:
    ldr r0,=string1      
    ldrb r1,[r4],#1      @load 1 byte data

    cmp r1,#0            @compare r0 is null
    beq End              @if r0 is null, go to end 
    
    cmp r1,#32           @if ro==" "
    beq Read             @if CPSR Z bit =1,  go to read

    cmp r1,#47           @if r0>0
    bgt smallthan9
CmpA:
    cmp r1,#65           @compare with A
    blt Print
CmpZ:
    cmp r1,#90           @compare with Z
    bgt Print
    add r1,r1,#32        @turn the capital letter to small one
    b Print

smallthan9:
    cmp r1,#58	         @if r0<=9
    blt Read
    b CmpA

Print:
    bl printf
    b Read
    
End:                     @why can't End be put at the end of file
    ldmfd sp! ,{fp,lr}   @load sp back to fp,lr
    mov pc,lr            @return


string:
    .ascii "The string output:\0"
string1:
    .ascii "%c"
