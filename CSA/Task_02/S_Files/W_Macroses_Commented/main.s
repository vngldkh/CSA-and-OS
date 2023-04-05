	.file	"main.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"Wrong number of arguments!"
.LC1:
	.string	"Wrong input!"
	.align 8
.LC2:
	.string	"The file doesn't exist or couldn't be read!"
.LC3:
	.string	"The file couldn't be changed!"
.LC5:
	.string	"\nRead:\t\t%f\n"
.LC6:
	.string	"Calc:\t\t%f\n"
.LC7:
	.string	"Write:\t\t%f\n"
.LC8:
	.string	"Total:\t\t%f\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	# Подготовительные действия
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 1136
	# Сохраняем argc на стеке
	mov	DWORD PTR -1124[rbp], edi
	# Сохраняем argv на стеке
	mov	QWORD PTR -1136[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax

	# Первый if
	# Сравниваем argc с 2
	cmp	DWORD PTR -1124[rbp], 2
	# Если == 2, переходим к .L2
	je	.L2
	# Сравниваем argc с 4
	cmp	DWORD PTR -1124[rbp], 4
	# Если <= 4, переходим к .L3
	jle	.L3
.L2:
	# Тело if
	# Строка "Wrong number of arguments!\n" - первый аргумент
	# Поэтому кладём её адрес в rdi
	lea	rax, .LC0[rip]
	mov	rdi, rax
	# Так как аргументов кроме строки,\ нет, компилятор вызывает puts вместо printf
	call	puts@PLT
	mov	eax, 1
	# Выходим из тела if
	jmp	.L12
.L3:
	# Вызываем clock (без входных параметров)
	call	clock@PLT
	# Результат лежит в регистре ax
	# Сохраняем start_read на стеке
	mov	QWORD PTR -1104[rbp], rax

	# Сравниваем argc с 1
	cmp	DWORD PTR -1124[rbp], 1
	# Если != 1, переходим к .L5 (первый else)
	jne	.L5

	# Тело if
	# Записываем адрес на str в di, так как это первый аргумент
	lea	rax, -1024[rbp]
	mov	rdi, rax
	# Вызываем console_input
	call	console_input@PLT

	# Результат выполнения функции хранится в ax
	# Записываем res на стек
	mov	DWORD PTR -1116[rbp], eax
	jmp	.L6
.L5:
	# else if (argc == 3)
	# Сравниваем argc с 3
	cmp	DWORD PTR -1124[rbp], 3
	# Если != 3, переходим к .L7 (второй else)
	jne	.L7

	# str - первый аргумент, записываем его адрес в di
	# argv - второй аргумент, записываем его в si
	mov	rdx, QWORD PTR -1136[rbp]
	lea	rax, -1024[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	# Вызываем file_input
	call	file_input@PLT
	# Результат выполнения функции хранится в ax
	# Записываем его в res
	mov	DWORD PTR -1116[rbp], eax
	jmp	.L6
.L7:
	# Последняя ветвь
	# str - первый аргумент, записываем его адрес в di
	# argv - второй аргумент, записываем его в si
	mov	rdx, QWORD PTR -1136[rbp]
	lea	rax, -1024[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	random_input@PLT
	# Результат выполнения функции хранится в ax
	# Записываем его в res
	mov	DWORD PTR -1116[rbp], eax
.L6:
	# Проверяем резльтат ввода
	# Сравниваем res с 1
	cmp	DWORD PTR -1116[rbp], 1
	# Если != 1, переходим к .L8 (else)
	jne	.L8
	# Записываем адрес на строку "Wrong input!\n" в di, т.к. это первый аргумент
	lea	rax, .LC1[rip]
	mov	rdi, rax
	# Так как кроме строки больше нет параметров, компилятор вызывает puts
	call	puts@PLT
	# Выходим из main с кодом ошибки 1
	mov	eax, 1
	jmp	.L12
.L8:
	# else if (res == 2)
	# Сравниваем res с 2
	cmp	DWORD PTR -1116[rbp], 2
	# Если != 2, выходим из условного оператора
	jne	.L9
	# Записываем адрес строки "The file doesn't exist or couldn't be read!\n" в di - первый параметр
	lea	rax, .LC2[rip]
	mov	rdi, rax
	# Так как кроме строки больше нет параметров, компилятор вызывает puts вместо printf
	call	puts@PLT
	# Выходим из main с кодом ошибки 2
	mov	eax, 2
	jmp	.L12
.L9:
	# Вызываем clock (без параметров)
	call	clock@PLT
	# Результат выполнения хранится в ax
	# Вычитаем оттуда start_read
	sub	rax, QWORD PTR -1104[rbp]
	# Записываем результат в end_red на стек
	mov	QWORD PTR -1096[rbp], rax

	# Вызываем clock (без параметров)
	call	clock@PLT
	# Возвращаемое значение в ax
	# Записываем в start_calc на стек
	mov	QWORD PTR -1088[rbp], rax

	# Записываем адрес на str в di - первый параметр
	lea	rax, -1024[rbp]
	mov	rdi, rax
	# Вызываем count_vowels
	call	count_vowels@PLT
	# Возвращаемое значение в ax
	# Записываем его в vowels на стек
	mov	DWORD PTR -1112[rbp], eax

	# Записываем адрес на str в di - первый параметр
	lea	rax, -1024[rbp]
	mov	rdi, rax
	# Вызываем count_consonants
	call	count_consonants@PLT
	# Возвращаемое значение в ax
	# Записываем его в consonants на стек
	mov	DWORD PTR -1108[rbp], eax

	# Вызываем clock (без параметров)
	call	clock@PLT
	# Возвращаемое значение в ax
	# Вычитаем из него start_calc
	sub	rax, QWORD PTR -1088[rbp]
	# Полученное значение записываем в end_calc на стек
	mov	QWORD PTR -1080[rbp], rax

	# Вызываем clock (без параметров)
	call	clock@PLT
	# Возвращаемое значение в ax
	# Записываем его в start_write на стек
	mov	QWORD PTR -1072[rbp], rax

	# Сравниваем argc с 1
	cmp	DWORD PTR -1124[rbp], 1
	# Если != 1, переходим к .L10 (else)
	jne	.L10

	# Записываем vowels в di - первый параметр
	# записываем consonantsв si - второй параметр
	mov	edx, DWORD PTR -1108[rbp]
	mov	eax, DWORD PTR -1112[rbp]
	mov	esi, edx
	mov	edi, eax
	# Вызываем console_output
	call	console_output@PLT
	jmp	.L11
.L10:
	# else
	# Первый аргумент - vowels, записываем в di
	# Второй аргумент - consonants, записываем в si
	# Третий аргумент - argv, записываем в dx
	mov	rdx, QWORD PTR -1136[rbp]
	mov	ecx, DWORD PTR -1108[rbp]
	mov	eax, DWORD PTR -1112[rbp]
	mov	esi, ecx
	mov	edi, eax
	# Вызываем file_output
	call	file_output@PLT
	# Возвращаемое значение хранится в ax
	# Сравниваем его с 0
	test	eax, eax
	# Если == 0, выходим из условного оператора
	je	.L11
	# Иначе - выводим сообщение об ошибке
	# Записываем адрес строки "The file couldn't be changed!\n" в di - первый аргумент
	lea	rax, .LC3[rip]
	mov	rdi, rax
	# Вызываем puts
	call	puts@PLT
.L11:
	# Вызываем clock (без параметров)
	call	clock@PLT
	# Результат хранится в ax
	# Вычитаем из него start_write
	sub	rax, QWORD PTR -1072[rbp]
	# Полученное значение записываем в end_write на стек
	mov	QWORD PTR -1064[rbp], rax

	# Очищаем xmm0
	pxor	xmm0, xmm0
	# Записываем end_read в xmm0
	cvtsi2sd	xmm0, QWORD PTR -1096[rbp]
	# Записываем CLOCKS_PER_SEC в xmm1
	movsd	xmm1, QWORD PTR .LC4[rip]
	# xmm0 = xmm0 / xmm1 = ((double)end_read)/CLOCKS_PER_SEC
	divsd	xmm0, xmm1
	# Полученное значение сохраняем в time_read на стеке
	movsd	QWORD PTR -1056[rbp], xmm0

	# Аналогично считаем time_calc
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -1080[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -1048[rbp], xmm0

	# Аналогично считаем time_write
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -1064[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -1040[rbp], xmm0

	# Записываем time_read в xmm0
	movsd	xmm0, QWORD PTR -1056[rbp]
	# Добавляем time_calc
	addsd	xmm0, QWORD PTR -1048[rbp]
	# Записываем time_write в xmm1
	movsd	xmm1, QWORD PTR -1040[rbp]
	# xmm0 += xmm1
	addsd	xmm0, xmm1
	# Результат записываем в total
	movsd	QWORD PTR -1032[rbp], xmm0

	# Записываем time_read в xmm0 - первый аргумент с плавающей точкой
	mov	rax, QWORD PTR -1056[rbp]
	movq	xmm0, rax
	# Записываем в di адрес строки "\nRead:\t\t%f\n" - первый аргумент
	lea	rax, .LC5[rip]
	mov	rdi, rax
	# 1 аргумент с плавающей точкой => ax = 1
	mov	eax, 1
	# Вызываем printf
	call	printf@PLT

	# Аналогично выполняется строка printf("Calc:\t\t%f\n", time_calc);
	mov	rax, QWORD PTR -1048[rbp]
	movq	xmm0, rax
	lea	rax, .LC6[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT

	# Аналогично выполняется строка printf("Write:\t\t%f\n", time_write);
	mov	rax, QWORD PTR -1040[rbp]
	movq	xmm0, rax
	lea	rax, .LC7[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT

	# Аналогично выполняется строка printf("Total:\t\t%f\n", total);
	mov	rax, QWORD PTR -1032[rbp]
	movq	xmm0, rax
	lea	rax, .LC8[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT

	# Код завершился без ошибок => из main должен вернуться 0
	# В ax хранится возвращаемое значение => eax = 0
	mov	eax, 0
.L12:
	# Проверяем, что на стеке было освобождено столько же памяти, сколько и выделено
	mov	rdx, QWORD PTR -8[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L13
	call	__stack_chk_fail@PLT
.L13:
	# Заканчиваем программу
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC4:
	.long	0
	.long	1093567616
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
