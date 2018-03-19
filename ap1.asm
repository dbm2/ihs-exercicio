org 0x7c00
jmp start

helloBankString: db 'Bem-vindo ao Banco!', 0
bankOptionsString: db 'Qual operacao voce deseja realizar?', 0
bankOptionNewAccountString: db '#1 Cadastrar nova conta', 0
bankOptionSearchAccountString: db '#2 Buscar uma conta', 0
bankOptionEditAccountString: db '#3 Editar uma conta', 0
bankOptionDeleteAccountString: db '#4 Deletar uma conta', 0
bankOptionListAllAgenciesString: db '#5 Listar agencias', 0 
bankOptionListAgencieAccountsString: db '#6 Listar contas de uma agencia', 0
bankInsertOptionString: db 'Digite o codigo da operacao:', 0

start:
	push helloBankString
	call printStringAndBreakLine

	push bankOptionsString
	call printStringAndBreakLine

	push bankOptionNewAccountString
	call printStringAndBreakLine

	push bankOptionSearchAccountString
	call printStringAndBreakLine

	push bankOptionEditAccountString
	call printStringAndBreakLine

	push bankOptionDeleteAccountString
	call printStringAndBreakLine

	push bankOptionListAllAgenciesString
	call printStringAndBreakLine

	push bankOptionListAgencieAccountsString
	call printStringAndBreakLine

	push bankInsertOptionString
	call printString

	;call readInputCharacter

	jmp exit

	printString:	;Function to print an string stored in the stack.
		pop bx
		pop si
		push bx

		mov ax, 0
		mov ds, ax
		mov cl, 0

		loopPrintString:
			lodsb
			cmp cl, al
			je callbackPrintString
			mov ah, 0xE
			mov bh, 0
			int 0x10
			jmp loopPrintString

		callbackPrintString:
			ret

	printStringAndBreakLine:	;Function to print an string stored in the stack and break the line after.
		pop bx
		pop si
		push bx

		mov ax, 0
		mov ds, ax
		mov cl, 0

		loopPrintStringAndBreakLine:
			lodsb
			cmp cl, al
			je callbackPrintStringAndBreakLine
			mov ah, 0xE
			mov bh, 0
			int 0x10
			jmp loopPrintStringAndBreakLine

		callbackPrintStringAndBreakLine:
			mov bx, 0			
			mov ah, 0xE
			mov bh, 0
			mov al, 10
			int 0x10

  			mov ah, 0x3
    		mov bh, 0
    		int 10h

			mov dl, 0 
    		mov ah, 2
   			mov bh, 0
    		int 0x10

			ret

	readInputCharacter:		;Function to read an inputed character. The character value will be returned in the stack.
		mov ah, 1
		int 0x21

		cmp al, 13
		je callBackReadInputCharacter

		mov ah, 0xE
		mov bh, 0
		int 0x10
		jmp readInputCharacter


		callBackReadInputCharacter:
			ret


exit:
	times 510-($-$$) db 0
	dw 0AA55h ; some BIOSes require this signature
