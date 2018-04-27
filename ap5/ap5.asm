bits 32
global main
extern printf, scanf

section .data
	factorialResult		dq	4.0

	two			dq	2.0
	counter			dq	0.0	

	inputAngleString	db	"Valor do angulo: ", 0x00
	inputAngleScanf		db	"%f", 0x00

	inputDiffString		db	"Valor da diferenca maxima: ", 0x00
	inputDiffScanf		db	"%f", 0x00
	
	stringCarry		db	0x0a, 0x00

	printTest		db	"teste = %f", 0x0a, 0x00

section .bss
	inputAngle		resq		1
	inputDiff		resq		1
	factorialCounter 	resq		1

section .text
main:
	;push dword inputAngleString
	;call printf
	;add esp, 4
	
	;push dword inputAngle
	;push dword inputAngleScanf
	;call scanf
	;add esp, 8

	;push dword stringCarry
	;call printf
	;add esp, 4

	;push dword inputDiffString
	;call printf
	;add esp, 8
	
	;push dword inputDiff
	;push dword inputDiffScanf
	;call scanf
	;add esp, 8
	
		

	;loop_sum:
		;fdl1			;s0 = 1
		;fld qword[two]		;s0 = 2, s1 = 1
		;fld qword[counter]	;s0 = counter, s1 = 2, s2= 1
		;fmulp			;s0 = counter*2, s1 = 1
		;faddp			;s0 = counter*2 + 1

		;fstp qword[factorialResult]

		
		call factorial
	
		;jump loop_sum
		

	push dword[factorialResult+4]
	push dword[factorialResult]
	push dword printTest
	call printf
	add esp, 12


	mov eax, 1
	mov ebx, 0
	int 0x80

factorial:
	fld qword[factorialResult]	
	fstp qword[factorialCounter]

	fld1		;s0 = 1
	
	loop_factorial:
		mov [factorialResult], cx
		fld qword[factorialResult]
		fmulp
		
		fld1			;st0 = 1
		fsubr qword[factorialCounter]	;st0=factorialCounter-1; st1 = 1
		fstp qword[factorialCounter]	;st0 = 1
		fstp st0
		fld0
		fcomp qword[factorialCounter]
		cmp c3, 1
		je endFactorial
		
		jmp loop_factorial
		
		
	endFactorial:
		fstp qword[factorialResult]
		ret
