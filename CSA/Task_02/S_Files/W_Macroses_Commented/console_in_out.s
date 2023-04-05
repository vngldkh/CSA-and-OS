	.file	"console_in_out.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"Write your string (it must not be longer than 1000 symbols).\nTo stop writing press CTRL+D twice!"
	.text
	.globl	console_input
	.type	console_input, @function
console_input:
.LFB0:
	# Подготовительные действия
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	# str[] - первый входной парматер, хранится в rdi
	# Сохраняем его на стек
	mov	QWORD PTR -24[rbp], rdi
	# Записываем адрес строки
	# "Write your string (it must not be longer than 1000 symbols).\nTo stop writing press CTRL+D twice!"
	# в rdi, т.к. это первый аргумент
	lea	rax, .LC0[rip]
	mov	rdi, rax
	# Вызываем puts
	call	puts@PLT
	# Инициализируем i
	mov	DWORD PTR -4[rbp], 0
.L3:
	# Вызываем getchar (без параметрво)
	call	getchar@PLT
	# Результат хранится в ax, записываем его в new_symbol на стек
	mov	BYTE PTR -5[rbp], al

	# Сохраняем в str[i] новый символ
	mov	eax, DWORD PTR -4[rbp]
	lea	edx, 1[rax]
	mov	DWORD PTR -4[rbp], edx
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rdx, rax
	movzx	eax, BYTE PTR -5[rbp]
	mov	BYTE PTR [rdx], al

	# Сравниваем new_symbol с EOF
	cmp	BYTE PTR -5[rbp], -1
	# Если ==, выходим из цикла
	je	.L2

	# Иначе - проверяем второе условие
	# Сравниваем i с 999
	cmp	DWORD PTR -4[rbp], 999
	# Если <=, возвращаемся в тело цикла
	jle	.L3
.L2:
	# Сравниваем i с 1000
	cmp	DWORD PTR -4[rbp], 1000
	# Если !=, сразу переходим к выходу
	jne	.L4

	# Иначе - вставляем в конец массива символ конца строки прежде
	# Получаем адрес str[i]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	# Записываем в str[i] 0
	mov	BYTE PTR [rax], 0
.L4:
	# Возвращаем 0 => eax = 0
	mov	eax, 0
	# Выходим из функции
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	console_input, .-console_input
	.section	.rodata
.LC1:
	.string	"\nCount of vowels - %d\n"
.LC2:
	.string	"Count of consonants - %d\n"
	.text
	.globl	console_output
	.type	console_output, @function
console_output:
.LFB1:
	# Подготовительные действия
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16

	# В di хранился первый параметр - vowels, записываем его на стек
	mov	DWORD PTR -4[rbp], edi
	# В si хранился второй параметр - consonants, записываем его на стек
	mov	DWORD PTR -8[rbp], esi

	# Записываем в si vowels - второй аргумент
	mov	eax, DWORD PTR -4[rbp]
	mov	esi, eax
	# В di записываем адрес строки "\nCount of vowels - %d\n" - первый аргумент
	lea	rax, .LC1[rip]
	mov	rdi, rax
	# 0 аргументов с плавающей точкой => eax = 0
	mov	eax, 0
	# Вызываем printf
	call	printf@PLT

	# Аналогично для строки printf("Count of consonants - %d\n", consonants);
	mov	eax, DWORD PTR -8[rbp]
	mov	esi, eax
	lea	rax, .LC2[rip]
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT

	# Выходим из функции
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	console_output, .-console_output
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
