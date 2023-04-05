	.file	"file_in_out.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"w"
	.text
	.globl	note_random_input
	.type	note_random_input, @function
note_random_input:
.LFB6:
	# Подготовительные действия
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	# Первый аргмент str[] хранился в di, записываем на стек
	mov	QWORD PTR -24[rbp], rdi
	# Второй аргумент argv хранился в si, записываем на стек
	mov	QWORD PTR -32[rbp], rsi

	mov	rax, QWORD PTR -32[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	# Записываем в rsi адрес "w" - второй аргумент
	lea	rdx, .LC0[rip]
	mov	rsi, rdx
	# Первый параметр - путь к входному файлу, запиываем в rdi
	mov	rdi, rax
	# Вызываем fopen
	call	fopen@PLT
	# Возвращаемое значение указатель на FILE
	# Сохраняем его на стеке
	mov	QWORD PTR -8[rbp], rax
	# Проверяем на NULL
	cmp	QWORD PTR -8[rbp], 0
	# Если не NULL, переходим к следующей инструкции (.L2)
	jne	.L2
	# Иначе - возвращаем 2, переходим к выходу из функции
	mov	eax, 2
	jmp	.L3
.L2:
	# Инициализируем i
	mov	DWORD PTR -12[rbp], 0
	# Переходим к проверке в цикле
	jmp	.L4
.L5:
	# fprintf(fin, "%c", str[i++]);
	mov	eax, DWORD PTR -12[rbp]
	lea	edx, 1[rax]
	mov	DWORD PTR -12[rbp], edx
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	mov	rdx, QWORD PTR -8[rbp]
	# В si записываем второй аргумент - fin
	mov	rsi, rdx
	# Первый аргумент - str[i]
	mov	edi, eax
	# Компилятор вызывает fput, так как записывается только один символ
	call	fputc@PLT
.L4:
	# Записываем str[i] в ax
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	# Сравниваем str[i] с EOF
	cmp	al, -1
	# Если !=, переходим в тело цикла
	jne	.L5

	# Первый аргумент - fin, записываем его в di
	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	# Вызываем fclose
	call	fclose@PLT
	mov	eax, 0
.L3:
	# Выходим из программы
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

.LFE6:
	.size	note_random_input, .-note_random_input
	.globl	random_input
	.type	random_input, @function
random_input:
.LFB7:
	# Подготовительные действия
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	# Первый аргмент str[] хранился в di, записываем на стек
	mov	QWORD PTR -24[rbp], rdi
	# Второй аргумент argv хранился в si, записываем его на стек
	mov	QWORD PTR -32[rbp], rsi

	# Получаем *argv[3], записываем в ax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	movzx	eax, BYTE PTR [rax]

	# Сравниваем *argv[3] с '0'
	cmp	al, 48
	# Если ==, проходим мимо тела условного опреатора
	je	.L7

	# Получаем *argv[3], записываем в ax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	movzx	eax, BYTE PTR [rax]
	# Сравниваем *argv[3] с '1'
	cmp	al, 49
	# Если ==, проходим мимо тела условного опреатора
	je	.L7
	# Иначе возвращаемся из функции с кодом ошибки 1
	mov	eax, 1
	jmp	.L8
.L7:
	# Вызываем rand (без параметров)
	call	rand@PLT
	# Результат хранится в ax
	# Вычисляем rand() % 1001
	movsx	rdx, eax
	imul	rdx, rdx, 1098413215
	shr	rdx, 32
	sar	edx, 8
	mov	ecx, eax
	sar	ecx, 31
	sub	edx, ecx
	# Записываем полученный результат на стек (size)
	mov	DWORD PTR -4[rbp], edx

	# Получаем str[size]
	mov	edx, DWORD PTR -4[rbp]
	imul	edx, edx, 1001
	sub	eax, edx
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	# Записываем EOF в str[i]
	mov	BYTE PTR [rax], -1

	# Записываем *argv[3] в ax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	movzx	eax, BYTE PTR [rax]
	# Сравниваем *argv[3] с '0'
	cmp	al, 48
	# Если != 0, переходим в другую ветвь
	jne	.L9
	# Тело if
	# Инициализируем i
	mov	DWORD PTR -12[rbp], 0
	# Переходим к проверке условия цикла
	jmp	.L10
.L11:
	# Вызываем rand (без аргументов)
	call	rand@PLT
	# Результат хранится в ax
	# Вычисляем 'A' + rand() % 26
	movsx	rdx, eax
	imul	rdx, rdx, 1321528399
	shr	rdx, 32
	sar	edx, 3
	mov	ecx, eax
	sar	ecx, 31
	sub	edx, ecx
	imul	ecx, edx, 26
	sub	eax, ecx
	mov	edx, eax
	mov	eax, edx
	add	eax, 65
	# Записываем полученный результат на стек (x)
	mov	BYTE PTR -13[rbp], al
	# Получаем str[i]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rdx, rax
	movzx	eax, BYTE PTR -13[rbp]
	# str[i] = x
	mov	BYTE PTR [rdx], al

	# ++i
	add	DWORD PTR -12[rbp], 1
.L10:
	# Записываем i в ax
	mov	eax, DWORD PTR -12[rbp]
	# Сравниваем i с size
	cmp	eax, DWORD PTR -4[rbp]
	# Если <, возвращаемся в тело цикла
	jl	.L11
	# Иначе - выходим из него и из тела if
	jmp	.L12
.L9:
	# Инициализируем i
	mov	DWORD PTR -8[rbp], 0
	# Переходим к проверке условия цикла
	jmp	.L13
.L14:
	# Вызываем rand (без аргументов)
	call	rand@PLT
	# Результат хранится в ax
	# Вычисляем '0' + rand() % 127
	movsx	rdx, eax
	imul	rdx, rdx, -2130574327
	shr	rdx, 32
	add	edx, eax
	sar	edx, 6
	mov	esi, eax
	sar	esi, 31
	mov	ecx, edx
	sub	ecx, esi
	mov	edx, ecx
	sal	edx, 7
	sub	edx, ecx
	sub	eax, edx
	mov	ecx, eax
	mov	eax, ecx
	lea	ecx, 48[rax]
	mov	eax, DWORD PTR -8[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	edx, ecx
	# Записываем полученный результат в str[i]
	mov	BYTE PTR [rax], dl

	# ++i
	add	DWORD PTR -8[rbp], 1
.L13:
	# Записываем в ax i
	mov	eax, DWORD PTR -8[rbp]
	# Сравниваем i с size
	cmp	eax, DWORD PTR -4[rbp]
	# Если <, возвращаемся к телу цикла
	jl	.L14
.L12:
	# str[] - первый аргумент, записываем в di
	# argv - второй аргумент, записываем в si
	mov	rdx, QWORD PTR -32[rbp]
	mov	rax, QWORD PTR -24[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	# Вызываем note_random_input
	call	note_random_input
.L8:
	# Выходим из функции
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

.LFE7:
	.size	random_input, .-random_input
	.section	.rodata
.LC1:
	.string	"r"
	.text
	.globl	file_input
	.type	file_input, @function
file_input:
.LFB8:
	# Подготовительные действия
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32

	# str[] - первый аргумент, записываем из di на стек
	mov	QWORD PTR -24[rbp], rdi
	# argv - второй аргумент, записываем из si на стек
	mov	QWORD PTR -32[rbp], rsi

	# Получаем argv[1]
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC1[rip]
	# Записываем "r" в si
	mov	rsi, rdx
	# Записываем argv[1] в di
	mov	rdi, rax
	# Вызываем fopen
	call	fopen@PLT
	# Полученный файловый поток хранится в ax
	mov	QWORD PTR -8[rbp], rax
	# Проверяем на NULL
	cmp	QWORD PTR -8[rbp], 0
	# Если !=, пропускаем тело if
	jne	.L16
	# Возвращаемся из функции с кодом 2
	mov	eax, 2
	jmp	.L17
.L16:
	# Инициализируем i
	mov	DWORD PTR -12[rbp], 0
.L19:
	# Первый аргумент - fin, записываем в di
	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	# Вызываем fgetc
	call	fgetc@PLT
	# Полученный результат хранится в ax, записываем на стек (new_symbol)
	mov	BYTE PTR -13[rbp], al
	# Получаем str[i++]
	mov	eax, DWORD PTR -12[rbp]
	lea	edx, 1[rax]
	mov	DWORD PTR -12[rbp], edx
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rdx, rax
	movzx	eax, BYTE PTR -13[rbp]
	# Записываем new_symbol в str[i]
	mov	BYTE PTR [rdx], al
	# Проверяем символ на EOF
	cmp	BYTE PTR -13[rbp], -1
	# Если ==, выходим из цикла
	je	.L18
	# Иначе - переходим к следующему сравнению
	# Сравниваем i с 999
	cmp	DWORD PTR -12[rbp], 999
	# Если <=, возвращаемся к телу цикла
	jle	.L19
.L18:
	# Сравниваем i с 1000
	cmp	DWORD PTR -12[rbp], 1000
	# Если !=, пропускаем тело if
	jne	.L20
	# Тело if
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	# str[i] = EOF
	mov	BYTE PTR [rax], -1
.L20:
	# Записываем fin в rdi
	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	# Закрываем файловый поток
	call	fclose@PLT
	# Возвращаем 0, т.к. никаких ошибок не было
	mov	eax, 0
.L17:
	# Выходим из функции
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

.LFE8:
	.size	file_input, .-file_input
	.section	.rodata
.LC2:
	.string	"Count of vowels - %d\n"
.LC3:
	.string	"Count of consonants - %d\n"
	.text
	.globl	file_output
	.type	file_output, @function
file_output:
.LFB9:
	# Подготовительные дейтсвия
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	# Первый аргумент - vowels, из di сохраняем на стек
	mov	DWORD PTR -20[rbp], edi
	# Второй аргумент - consonants, из si сохраняем на стек
	mov	DWORD PTR -24[rbp], esi
	# Третий аргумент - argv, из dx сохраняем на стек
	mov	QWORD PTR -32[rbp], rdx

	# Получаем *argv[2], записываем в di
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC0[rip]
	# Записываем "w" в si
	mov	rsi, rdx
	mov	rdi, rax
	# Вызываем fopen
	call	fopen@PLT
	# Полученный файловый поток хранится в ax, сохраняем на стек
	mov	QWORD PTR -8[rbp], rax
	# Проверяем на NULL
	cmp	QWORD PTR -8[rbp], 0
	jne	.L22
	mov	eax, 1
	jmp	.L23
.L22:
	# Первый аргумент - fin, записываем в di
	# Второй аргумент - адрес строки "Count of vowels - %d\n", записываем в si
	# Третий аргумент - vowels, записываем в dx
	mov	edx, DWORD PTR -20[rbp]
	mov	rax, QWORD PTR -8[rbp]
	lea	rcx, .LC2[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 0
	call	fprintf@PLT

	# Аналогично выводим fprintf(fin, "Count of consonants - %d\n", consonants);
	mov	edx, DWORD PTR -24[rbp]
	mov	rax, QWORD PTR -8[rbp]
	lea	rcx, .LC3[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 0
	call	fprintf@PLT

	# Выходим из функции с кодом 0
	mov	eax, 0
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	file_output, .-file_output
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
