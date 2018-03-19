org 0x7c00
jmp start

helloBankString: db 'Bem-vindo ao Banco!', 0
bankOptionsString: db 'Qual operacao voce deseja realizar?', 0
bankOptionNewAccountString: db '#1 Cadastrar nova conta.', 0
bankOptionSearchAccountString: db '#2 Buscar uma conta.', 0
bankOptionEditAccountString: db '#3 Editar uma conta.', 0
bankOptionDeleteAccountString: db '#4 Deletar uma conta.', 0
bankOptionListAllAgenciesString: db '#5 Listar agencias.', 0 
bankOptionListAgencieAccountsString: db '#6 Listar contas de uma agencia.', 0
bankInsertOptionString: db 'Digite o codigo da operacao: ', 0
bankOptionInvalidString: db 'Error: insira uma opcao valida.', 0

op1: db 'op1', 0
op2: db 'op2', 0
op3: db 'op3', 0
op4: db 'op4', 0
op5: db 'op5', 0
op6: db 'op6', 0

start:
	push helloBankString
	call printStringAndBreakLine

	call printBreakLine

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

bankMainLoop:

	call printBreakLine

	push bankInsertOptionString
	call printString

	call readInputCharacter
	call printBreakLine

	pop ax

	cmp al, 1
	je bankRountineNewAccount

	cmp al, 2
	je bankRountineSearchAccount

	cmp al, 3
	je bankRoutineEditAccount

	cmp al, 4
	je bankRoutineDeleteAccount

	cmp al, 5
	je bankRoutineListAllAgencies

	cmp al, 6
	je bankRoutineListAgencieAccounts

	push bankOptionInvalidString
	call printStringAndBreakLine

	jmp bankMainLoop


	bankRountineNewAccount:
		push op1
		call printStringAndBreakLine
		jmp bankMainLoop

	bankRountineSearchAccount:
		push op2
		call printStringAndBreakLine
		jmp bankMainLoop

	bankRoutineEditAccount:
		jmp bankMainLoop

	bankRoutineDeleteAccount:
		jmp bankMainLoop

	bankRoutineListAllAgencies:
		jmp bankMainLoop

	bankRoutineListAgencieAccounts:
		jmp bankMainLoop


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
			call printBreakLine
			ret

	printBreakLine:
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
		mov ah, 0
		int 0x16

		mov ah, 0xE
		mov bh, 0
		int 0x10

		sub al, '0'

		pop bx
		push ax
		push bx

		ret


exit:
	times 510-($-$$) db 0
	dw 0AA55h ; some BIOSes require this signature
