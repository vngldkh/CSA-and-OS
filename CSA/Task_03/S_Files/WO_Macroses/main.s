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
	# Подготовительные действия
	endbr64
	push	rbp
	mov	rbp, rsp
	add	rsp, -128
	# Сохраняем первый параметр (argc) на стеке (был в di)
	mov	DWORD PTR -116[rbp], edi
	# Сохраняем второй параметр (argv) на стеке (был в si)
	mov	QWORD PTR -128[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax

	# Первый параметр - NULL, сохраняем в di
	mov	edi, 0
	# Вызываем time
	call	time@PLT
	# Полученное значение хранится в ax, записываем в di - первый аргумент
	mov	edi, eax
	# Вызываем srand
	call	srand@PLT

	# Проверяем кол-во аргументов
	cmp	DWORD PTR -116[rbp], 2
	je	.L2
	cmp	DWORD PTR -116[rbp], 4
	jle	.L3
.L2:
	# Тело условного оператора
	# Попадаем сюда, если argc == 2 или >4
	# Выводим сообщение "Wrong number of arguments!\n"
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	puts@PLT
	# Возвращаем 1, поэтому кладём в eax 1
	mov	eax, 1
	jmp	.L12
.L3:
	# Если не попадаем в тело условного оператора выше

	# Вызываем clock (без параметров)
	call	clock@PLT
	# Полученное время (было в ax) записываем на стек (start_read)
	mov	QWORD PTR -96[rbp], rax

	# Сравниваем кол-во аргументов с 1
	cmp	DWORD PTR -116[rbp], 1
	# Если !=, переходим в другую ветвь
	jne	.L5

	# Записываем в di адрес x - первый аргумент
	lea	rax, -104[rbp]
	mov	rdi, rax
	# Вызываем consileInput
	call	consoleInput@PLT
	# Полученное число записываем на стек (res)
	mov	DWORD PTR -108[rbp], eax
	jmp	.L6
.L5:
	cmp	DWORD PTR -116[rbp], 3
	jne	.L7
	mov	rdx, QWORD PTR -128[rbp]
	lea	rax, -104[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	fileInput@PLT
	mov	DWORD PTR -108[rbp], eax
	jmp	.L6
.L7:
	mov	eax, 0
	call	random_arg@PLT
	movq	rax, xmm0
	mov	QWORD PTR -104[rbp], rax
	mov	rax, QWORD PTR -104[rbp]
	mov	rdx, QWORD PTR -128[rbp]
	mov	rdi, rdx
	movq	xmm0, rax
	call	noteRandomInput@PLT
	mov	DWORD PTR -108[rbp], eax
.L6:
	# Сравниваем res с 1
	cmp	DWORD PTR -108[rbp], 1
	# Если !=, переходим в другую ветвь
	jne	.L8
	# Иначе - выводим сообщение об ошибке
	lea	rax, .LC1[rip]
	mov	rdi, rax
	call	puts@PLT
	# Возвращаем 1 из функции => ax = 1
	mov	eax, 1
	jmp	.L12
.L8:
	# Сравниваем res c 2
	cmp	DWORD PTR -108[rbp], 2
	# Если !=, выходим из условного оператора (минуя его тело)
	jne	.L9
	# Иначе - выводим сообщение об ошибке
	lea	rax, .LC2[rip]
	mov	rdi, rax
	call	puts@PLT
	# Возвращаем 2 из функции => ax = 2
	mov	eax, 2
	jmp	.L12
.L9:
	# Вызываем clock (без параметров)
	call	clock@PLT
	# Полученное время лежит в ax
	# Вычитаем из него start_read
	sub	rax, QWORD PTR -96[rbp]
	# Сохраняем результат на стек (end_read)
	mov	QWORD PTR -88[rbp], rax

	# Вызываем clock (без параметров)
	call	clock@PLT
	# Полученное время лежит в ax
	# Сохраняем его на стеке (start_calc)
	mov	QWORD PTR -80[rbp], rax

	# Инициализируем iterations на стеке
	mov	DWORD PTR -112[rbp], 0

	# Записываем в xmm0 значение x - первый аргумент с плавающей точкой
	# В rdi записываем указатель на iterations - первый целочисленный аргумент
	mov	rax, QWORD PTR -104[rbp]
	lea	rdx, -112[rbp]
	mov	rdi, rdx
	movq	xmm0, rax
	# Вызываем func
	call	func@PLT
	# Результат лежит в xmm0
	# Сохраняем его на стеке
	movq	rax, xmm0
	mov	QWORD PTR -72[rbp], rax

	# Вызываем clock (без параметров)
	call	clock@PLTx
	# Вычитаем из полученного значения start_calc
	sub	rax, QWORD PTR -80[rbp]
	# Результат сохраняем на стеке (end_clac)
	mov	QWORD PTR -64[rbp], rax

	# Вызываем clock (без параметров)
	call	clock@PLT
	# Полученное время хранится в ax
	# Сохраняем его на стеке
	mov	QWORD PTR -56[rbp], rax

	# Сравниваем argc с 1
	cmp	DWORD PTR -116[rbp], 1
	# Если !=, переходим в тело else 
	jne	.L10
	# Первый аргумент с плавающей точкой - f, записываем в xmm0
	# Первый целочисленный аргумент - iterations, записываем в di
	mov	edx, DWORD PTR -112[rbp]
	mov	rax, QWORD PTR -72[rbp]
	mov	edi, edx
	movq	xmm0, rax
	# Вызываем consoleOut
	call	consoleOutput@PLT
	jmp	.L11
.L10:
	# Тело else

	# Первый аргумент с плавающей точкой - f, записываем в xmm0
	# Первый целочисленный аргумент - iterations, записываем в di
	# Второй целочисленный аргумент - argv, записываем в si
	mov	edx, DWORD PTR -112[rbp]
	mov	rcx, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR -72[rbp]
	mov	rsi, rcx
	mov	edi, edx
	movq	xmm0, rax
	# Вызываем fileOutput
	call	fileOutput@PLT
	# Сравниваем результат работы с 0
	test	eax, eax
	# Если !=, выводим соответствующее сообщение, выходим из функции
	je	.L11
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	puts@PLT
.L11:
	# Вызываем clock (без параметров)
	call	clock@PLT
	# Вычитаем из полученного времени start_read
	sub	rax, QWORD PTR -56[rbp]
	# Результат сохраняем на стеке (end_read)
	mov	QWORD PTR -48[rbp], rax

	# Считаем time_read
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -88[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	# Сохраняем его на стеке
	movsd	QWORD PTR -40[rbp], xmm0

	# Считаем time_calc
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -64[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	# Сохраняем его на стеке
	movsd	QWORD PTR -32[rbp], xmm0

	# Считаем time_write
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -48[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	# Сохраняем его на стеке
	movsd	QWORD PTR -24[rbp], xmm0

	# Считаем total
	movsd	xmm0, QWORD PTR -40[rbp]
	addsd	xmm0, QWORD PTR -32[rbp]
	movsd	xmm1, QWORD PTR -24[rbp]
	addsd	xmm0, xmm1
	# Сохраняем его на стеке
	movsd	QWORD PTR -16[rbp], xmm0

	# Выводим time_read
	# Первый целочисленный аргумент - адрес на "\nRead:\t\t%f\n", записываем в di
	# Первый аргумент с плавающей точкой - time_read, записываем в xmm0
	mov	rax, QWORD PTR -40[rbp]
	movq	xmm0, rax
	lea	rax, .LC5[rip]
	mov	rdi, rax
	mov	eax, 1
	# Вызываем printf
	call	printf@PLT

	# Аналогично выводим time_calc
	mov	rax, QWORD PTR -32[rbp]
	movq	xmm0, rax
	lea	rax, .LC6[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT

	# Аналогично выводим time_write
	mov	rax, QWORD PTR -24[rbp]
	movq	xmm0, rax
	lea	rax, .LC7[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT

	# Аналогично выводим total
	mov	rax, QWORD PTR -16[rbp]
	movq	xmm0, rax
	lea	rax, .LC8[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	mov	eax, 0
.L12:
	mov	rdx, QWORD PTR -8[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L13
	call	__stack_chk_fail@PLT
.L13:
	leave
	ret
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
