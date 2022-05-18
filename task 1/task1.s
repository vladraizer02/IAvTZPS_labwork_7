SECTION .text
GLOBAL main
EXTERN printhex
EXTERN printf

%macro first_step 0
	mov rdx, [B+8*0]
	clc
 	mulx R8, rax, [A+8*0]
	mov [C+8*0], rax
 
	mulx R9, rax, [A+8*1]
	adc R8, rax
	mulx R10, rax, [A+8*2]
	adc R9, rax
	mulx R11, rax, [A+8*3]
	adc R10, rax
	mulx R12, rax, [A+8*4]
	adc R11, rax
	mulx R13, rax, [A+8*5]
	adc R12, rax
	mulx R14, rax, [A+8*6]
	adc R13, rax
	mulx R15, rax, [A+8*7]
	adc R14, rax
	adc R15, 0
%endmacro

%macro second_step 0
	%assign i 1
	%rep 7
		mov rdx, [B+8*i]
		
		xor rax, rax
		mulx rbx, rcx, [A + 8*0]
		adox R8, rcx
		adcx R9, rbx
		mov [C+8*i], R8
		
		mov rdi, [R+8*0]
		
		mulx rbx, rdi, [A + 8*1]
		adox rdi, R9
		adcx R10, rbx
		
		mov [R+8*0], rdi
		mov rdi, [R+8*1]
		
		mulx rbx, rdi, [A + 8*2]
		adox rdi, R10
		adcx R11, rbx
		
		mov [R+8*1], rdi
		mov rdi, [R+8*2]
		
		mulx rbx, rdi, [A + 8*3]
		adox rdi, R11
		adcx R12, rbx
		
		mov [R+8*2], rdi
		mov rdi, [R+8*3]
		
		mulx rbx, rdi, [A + 8*4]
		adox rdi, R12
		adcx R13, rbx
		
		mov [R+8*3], rdi
		mov rdi, [R+8*4]
		
		mulx rbx, rdi, [A + 8*5]
		adox rdi, R13
		adcx R14, rbx
		
		mov [R+8*4], rdi
		mov rdi, [R+8*5]
		
		mulx rbx, rdi, [A + 8*6]
		adox rdi, R14
		adcx R15, rbx
		
		mov [R+8*5], rdi
		mov rdi, [R+8*6]
		
		mulx rbx, rdi, [A + 8*7]
		adox rdi, R15
		adcx rbx, rax
		
		mov [R+8*6], rdi
		mov rdi, [R+8*7]
		
		mov rdi, rbx
		adox rdi, rax
		
		mov [R+8*7], rdi

	%assign i i+1
	%endrep
%endmacro

%macro third_step 0
	%assign i 0
	%rep 8
		mov r8, [R+i*8]
		mov [C+64+i*8], r8
	%assign i i+1
	%endrep
%endmacro

main:
;;;;;;;;;;;;;;;;;;;;; шаг 1

	first_step

;;;;;;;;;;;;;;;;;;;;; шаг 2

	second_step

;;;;;;;;;;;;;;;;;;;;; шаг 3

	third_step

;;;;;;;;;;;;;;;;;;;;; Вывод чисел

	mov rdi, msg1 ;arg_1
	xor rax, rax ;arg_2
	call printf wrt ..plt 

	mov rsi, A
	mov rcx, 64
	call printhex

	mov rdi, msg2 ;arg_1
	xor rax, rax ;arg_2
	call printf wrt ..plt 

	mov rsi, B
	mov rcx, 64
	call printhex

	mov rdi, msg3 ;arg_1
	xor rax, rax ;arg_2
	call printf wrt ..plt 

	mov rsi, C
	mov rcx, 128
	call printhex

	mov rax, 60 
	mov rdi, 0 
	syscall 

SECTION .data
A DQ 	0xed85d4c1f1f9b755, 0x34c9006ae24d224e, 0x9090d91b7096c87d, 0x67cca311b00e2b04, 0x73a84f9e8b8e5dc6, 0xfdf90a0d7a7cc7ce, 0x31201acbf3f0e1ac, 0xc9363a5be9cb5aaa
B DQ 	0xb1745ec6b8707900, 0x3227bb01df375499, 0x2d454bde85012415, 0x73885168590c979e, 0x8739aadb86c17863, 0x5cefe361c298c21a, 0x66f7b2cbf0c57c03, 0x7a1b1881358b5369
C DQ 	0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000
R DQ 	0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000

SECTION .rodata
msg1: db "A:", 0x0a, 0 
msg2: db "B:", 0x0a, 0 
msg3: db "C:", 0x0a, 0 
