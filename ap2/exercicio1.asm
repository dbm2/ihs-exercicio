org 0x7C00
jmp start

string: db 'AP2 de IHS'


start:

	mov ax, 0
	mov ds, ax

	mov di, 100h
	mov word[di], ISR
	mov word[di + 2], 0x0000
	int 40h

	jmp exit

	ISR:	;ISR used in the 40h
		call printString
		iret


	printString:	;Function to print an string stored in the stack.
		mov bx, string
		mov cx, 10

		loopPrintString:
			mov al, byte[bx]

			mov ah, 0xE
			int 0x10

			inc bx

			loop loopPrintString

exit:
	times 510-($-$$) db 0
	dw 0xaa55