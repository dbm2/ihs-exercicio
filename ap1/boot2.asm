org 0x0500
jmp 0x0000:start

helloBankString: 						db 	'Bem-vindo ao Banco!', 0
bankOptionsString: 						db 	'Qual operacao voce deseja realizar?', 0
bankOptionNewAccountString: 			db 	'#1 Cadastrar nova conta.', 0
bankOptionSearchAccountString:			db 	'#2 Buscar uma conta.', 0
bankOptionEditAccountString: 			db 	'#3 Editar uma conta.', 0
bankOptionDeleteAccountString: 			db 	'#4 Deletar uma conta.', 0
bankOptionListAllAgenciesString: 		db 	'#5 Listar agencias.', 0 
bankOptionListAgencyAccountsString: 	db 	'#6 Listar contas de uma agencia.', 0
bankInsertOptionString: 				db 	'Digite o codigo da operacao: ', 0
bankOptionInvalidString: 				db 	'Error: insira uma opcao valida.', 0

struc user
	.name: 		resb 	20			;String (max: 20 chars)
	.cpf: 		resb 	11			;String (max: 11 chars)
	.agency: 	resw 	1			;Integer (max value: 65536)
	.account: 	resw	1			;Integer (max value: 65536)
endstruc

start:
	mov ax, 0
	mov ds, ax
	
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

	push bankOptionListAgencyAccountsString
	call printStringAndBreakLine

bankMainLoop:

	call printBreakLine

	push bankInsertOptionString
	call printString

	call readInputCharacter
	call printBreakLine

	pop ax

	cmp al, 1
	je bankRoutineNewAccount

	cmp al, 2
	je bankRoutineSearchAccount

	cmp al, 3
	je bankRoutineEditAccount

	cmp al, 4
	je bankRoutineDeleteAccount

	cmp al, 5
	je bankRoutineListAllAgencies

	cmp al, 6
	je bankRoutineListAgencyAccounts

	push bankOptionInvalidString
	call printStringAndBreakLine

	jmp bankMainLoop


	bankRoutineNewAccount:
		jmp bankMainLoop

	bankRoutineSearchAccount:
		jmp bankMainLoop

	bankRoutineEditAccount:
		jmp bankMainLoop

	bankRoutineDeleteAccount:
		jmp bankMainLoop

	bankRoutineListAllAgencies:
		jmp bankMainLoop

	bankRoutineListAgencyAccounts:
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