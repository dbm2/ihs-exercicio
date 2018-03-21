org 0x7C00
jmp 0x0000:start

start:
	xor ax, ax
	mov ds, ax


resetDiskSystem:		;Reset the disk (drive A)
	mov ah, 0
	mov dl, 0
	int 13h
	jc resetDiskSystem	;If was not possible, try again


loadApplicationInMemory:
	mov ah, 0x02
	mov al, 10
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 0
	mov bx, 0x0000
	mov es, bx
	mov bx, 0x0500
	int 13h
	jc loadApplicationInMemory


jmp 0x0000:0x0500	;Go to the Application

exit:
	times 510-($-$$) db 0
	dw 0xaa55