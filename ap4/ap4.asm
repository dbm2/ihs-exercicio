; Desenvolvido em macOS
; Compilar: 
;		nasm -f macho -o ap4.o ap4.asm 
; Exececutar: 
; 		ld -macosx_version_min 10.7.0 -lSystem -o ap4 ap4.o
;		./ap4

bits 32

global start

section .data
	pi				dq 	0.0
	two				dq	2.0
	four			dq 	4.0
	N				db	10
	resultString	db	"Resultado", 0x0a, 0x00

section .bss
	i 				resq	1

section .text
start:
	
	mov cx, [N]

	loopSum:
		fld1	; st0 = 1
		
		mov ax, cx
		mov bl, 2
		div bl

		cmp ah, 0
		jne loopSumContinue

		fchs	; st0 = -1 se cx é impar

		loopSumContinue:
			fld1			; st1 = +-1, st0 = 1
			mov [i], cx		; armazena o valor de cx em i
			fild dword[i] 	; st2 = +- 1, st1 = 1, st0 = cx ou i
			fmul dword[two]	; st2 = +- 1, st1 = 1, st0 = 2*i
			fadd st1, st0	; st1 = +- 1, st0 = 2i + 1

			fdiv st1, st0	; st0 = +-1 / (2i + 1)

			fld dword[pi]
			faddp			;st0 = pi + (+-1 / (2i + 1))
			fst dword[pi]

		loop loopSum

	fld dword[pi]
	fld dword[four]
	fmul
	fst dword[pi]

	mov eax, 1
	mov ebx, 0
	int 0x80