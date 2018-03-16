org 0x7c00

helloBankString: db 'Hello Word', 0

mov si, helloBankString

printString:
	mov ax, 0
	mov ds,ax
	mov cl,0

	loopPrintString:
		lodsb
		cmp cl,al
		je callbackPrintString
		mov ah, 0xE
		mov bh,0
		int 0x10
		jmp loopPrintString

	callbackPrintString:
		ret

exit:
	times 510-($-$$) db 0
	dw 0AA55h ; some BIOSes require this signature
