	.file	"funcs.c"
	.intel_syntax noprefix
	.text
	.globl	func
	.type	func, @function
func:
	# Подготовительные действия
	endbr64
	push	rbp
	mov	rbp, rsp

	# x - первый аргумент с плавающей точкой, хранится в xmm0
	# Указатель на iterations - первый целочисленный аргумент, хранится в rdi
	# Записываем x и указатель на iterations на стек
	movsd	QWORD PTR -40[rbp], xmm0
	mov	QWORD PTR -48[rbp], rdi

	# Записываем x в xmm1
	movsd	xmm1, QWORD PTR -40[rbp]
	# В xmm0 записываем 1
	movsd	xmm0, QWORD PTR .LC0[rip]
	# Прибавляем к 1 x
	addsd	xmm0, xmm1
	# Записываем полученное значение на стек (переменная new)
	movsd	QWORD PTR -24[rbp], xmm0

	# В xmm0 записываем 1
	movsd	xmm0, QWORD PTR .LC0[rip]
	# Записываем на стек (переменная prev)
	movsd	QWORD PTR -8[rbp], xmm0

	# Записываем в xmm0 значение x
	movsd	xmm0, QWORD PTR -40[rbp]
	# Сохраняем на стеке (переменная summand)
	movsd	QWORD PTR -16[rbp], xmm0

	# В rax записываем адрес на iterations
	mov	rax, QWORD PTR -48[rbp]
	mov	DWORD PTR [rax], 0
.L2:
	# В xmm0 записываем summand
	movsd	xmm0, QWORD PTR -16[rbp]
	# Умножаем его на x
	mulsd	xmm0, QWORD PTR -40[rbp]
	# Обновляем значение summand на стеке
	movsd	QWORD PTR -16[rbp], xmm0
	# Записываем в xmm0 значение new
	movsd	xmm0, QWORD PTR -24[rbp]
	# Обновляем значение prev на стеке
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	xmm0, QWORD PTR -24[rbp]
	# Прибавляем к new значение следующего члена ряда (summand)
	addsd	xmm0, QWORD PTR -16[rbp]
	# Обновляем значение new на стеке
	movsd	QWORD PTR -24[rbp], xmm0

	# Записываем в ax указатель на iterations
	mov	rax, QWORD PTR -48[rbp]
	# Записываем в ax значение iterations по полученному указателю
	mov	eax, DWORD PTR [rax]
	# ++(*iterations)
	lea	edx, 1[rax]
	# Получаем указатель на iterations
	mov	rax, QWORD PTR -48[rbp]
	# Обновляем его значение
	mov	DWORD PTR [rax], edx

	# Считаем fabs(new - prev)
	movsd	xmm0, QWORD PTR -24[rbp]
	subsd	xmm0, QWORD PTR -8[rbp]
	movq	xmm1, QWORD PTR .LC1[rip]
	andpd	xmm0, xmm1

	# Проверка условия цикла
	comisd	xmm0, QWORD PTR .LC2[rip]
	ja	.L2

	# Значение функции - возвращаемое значение => сохраняем в ax
	movsd	xmm0, QWORD PTR -24[rbp]
	movq	rax, xmm0
	movq	xmm0, rax
	pop	rbp
	ret
	.size	func, .-func
	.section	.rodata

.LC3:
	.string	"x? "
.LC4:
	.string	"%lf"
	.text
	.globl	consoleInput
	.type	consoleInput, @function
consoleInput:
	# Подготовительные действия
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16

	# Первый аргумент (хранится в rdi), адрес на x, сохраняем на стеке 
	mov	QWORD PTR -8[rbp], rdi

	# Сохраняем адрес строки "x? " в rdi, т.к. это первый аргумент
	lea	rax, .LC3[rip]
	mov	rdi, rax
	# 0 параметров с плавающей точкой => eax = 0
	mov	eax, 0
	# Вызываем printf
	call	printf@PLT

	# Адрес на x сохраняем в rsi - это второй аргумент
	mov	rax, QWORD PTR -8[rbp]
	mov	rsi, rax
	# Адрес строки "%lf" сохраняем в rdi - это первый аргумент
	lea	rax, .LC4[rip]
	mov	rdi, rax
	# 0 параметров с плавающей точкой => eax = 0
	mov	eax, 0
	# Вызываем scanf
	call	__isoc99_scanf@PLT

	# Записываем адрес на x в rax
	mov	rax, QWORD PTR -8[rbp]
	# Получаем его значение, сохраняем в xmm1
	movsd	xmm1, QWORD PTR [rax]
	# В xmm0 записываем -1
	movsd	xmm0, QWORD PTR .LC5[rip]
	# Сравниваем x с -1
	comisd	xmm0, xmm1
	# Если >, возвращаем 1, выходим из функции
	jnb	.L5
	# Иначе - проверяем второе условие
	# Записываем адрес на x в rax
	mov	rax, QWORD PTR -8[rbp]
	# Получаем его значение, сохраняем в xmm0
	movsd	xmm0, QWORD PTR [rax]
	# Записываем в xmm1 1
	movsd	xmm1, QWORD PTR .LC0[rip]
	# Сравниваем 1 с x
	comisd	xmm0, xmm1
	# Если >, продолжаем работу функции
	jb	.L9
.L5:
	# Иначе возвращаем 1, выходим из функции
	mov	eax, 1
	jmp	.L8
.L9:
	# Возвращаем 0, т.к. в ходе работы программы не возникло ошибок
	mov	eax, 0
.L8:
	leave
	ret
	.size	consoleInput, .-consoleInput
	.section	.rodata

.LC6:
	.string	"1/(1-x) = %lf\n"
.LC7:
	.string	"iterations: %d"
	.text
	.globl	consoleOutput
	.type	consoleOutput, @function
consoleOutput:
	# Подготовительные действия
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16

	# Сохраняем первый аргумент с плавающей точкой (x) на стеке
	movsd	QWORD PTR -8[rbp], xmm0
	# Первый целочисленный аргумент (count) сохраняем на стеке
	mov	DWORD PTR -12[rbp], edi

	# Записываем x в xmm0
	mov	rax, QWORD PTR -8[rbp]
	movq	xmm0, rax
	# Записываем адрес на "1/(1-x) = %lf\n" в rdi
	lea	rax, .LC6[rip]
	mov	rdi, rax
	mov	eax, 1
	# Первый целочесленный аргумент - адрес на "1/(1-x) = %lf\n" - лежит в di
	# Первый аргумент с плавающей точкой - x - лежит в xmm0
	# Вызываем printf
	call	printf@PLT

	# Сохраняем count в si - второй целочисленный аргумент
	mov	eax, DWORD PTR -12[rbp]
	mov	esi, eax
	# Адрес на строку "iterations: %d" - первый целочисленный аргумент
	lea	rax, .LC7[rip]
	mov	rdi, rax
	# 0 аргументов с плавающей точкой
	mov	eax, 0
	# Вызываем printf
	call	printf@PLT
	nop
	leave
	ret
	.size	consoleOutput, .-consoleOutput
	.section	.rodata

.LC8:
	.string	"r"
	.text
	.globl	fileInput
	.type	fileInput, @function
fileInput:
	# Подготовительные действия
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32

	# Первый аргумент (хранится в di) - указатель на x, сохраняем на стеке
	mov	QWORD PTR -24[rbp], rdi

	# Второй аргумент (хранится в si) - argv, сохраняем на стеке
	mov	QWORD PTR -32[rbp], rsi

	# Получаем argv[1]
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]

	# Второй аргумент - "r", сохраняем адрес в si
	lea	rdx, .LC8[rip]
	mov	rsi, rdx
	# Первый аргумент - argv[1], сохраняем в di
	mov	rdi, rax
	# Вызываем fopen
	call	fopen@PLT
	# Ссылка на поток хранится в ax - возвращаемое значение
	# Сохраняем его на стеке
	mov	QWORD PTR -8[rbp], rax
	# Проверяем на NULL
	cmp	QWORD PTR -8[rbp], 0
	# Если ==, возвращаем 2, выходим из функции
	# Иначе - обходим тело условного оператора
	jne	.L12
	mov	eax, 2
	jmp	.L13
.L12:
	# Адрес файлового потка - первый аргумент, кладём в rdi
	# Адрес строки "%lf" - второй аргумент
	# Указатель на x - третий аргумент, кладём в rdx
	# 0 аргументов с плавающей точкой
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -8[rbp]
	lea	rcx, .LC4[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 0
	# Вызываем scanf
	call	__isoc99_fscanf@PLT

	# Записываем в rax указатель на x
	mov	rax, QWORD PTR -24[rbp]
	# Получаем его значение, записываем в xmm1
	movsd	xmm1, QWORD PTR [rax]
	# В xmm1 записываем -1
	movsd	xmm0, QWORD PTR .LC5[rip]
	# Сравниваем x с -1
	comisd	xmm0, xmm1
	jnb	.L14
	# Аналогично сравниваем с 1
	mov	rax, QWORD PTR -24[rbp]
	movsd	xmm0, QWORD PTR [rax]
	movsd	xmm1, QWORD PTR .LC0[rip]
	comisd	xmm0, xmm1
	jb	.L17
.L14:
	mov	eax, 1
	jmp	.L13
.L17:
	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	# Закрываем файловый поток
	call	fclose@PLT
	mov	eax, 0
.L13:
	leave
	ret
	.size	fileInput, .-fileInput
	.section	.rodata
.LC9:
	.string	"w"
	.text
	.globl	fileOutput
	.type	fileOutput, @function
fileOutput:
	# Подготовительные действия
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	# Первый аргумент с плавающей точкой (хранится в xmm0) - значение x, сохраняем на стеке
	movsd	QWORD PTR -24[rbp], xmm0
	# Первый целочисленный аргумент (хранится в di) - count, сохраняем на стеке
	mov	DWORD PTR -28[rbp], edi
	# Второй целочисленный аргумент (хранится в si) - argv, сохраняем на стеке
	mov	QWORD PTR -40[rbp], rsi

	# Получаем argv[2], записываем в di - первй аргумент
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	# Записываем адрес "w" в si - второй аргумент
	lea	rdx, .LC9[rip]
	mov	rsi, rdx
	mov	rdi, rax
	# Открывем файловый поток
	call	fopen@PLT
	# Адрес на него хранится в ax, сохраняем на стеке
	mov	QWORD PTR -8[rbp], rax
	# Проверяем адрес на NULL
	cmp	QWORD PTR -8[rbp], 0
	jne	.L19
	mov	eax, 1
	jmp	.L20
.L19:
	# Первый целочисленный аргумент - адрес на файловый поток, сохраняем в di
	# Второй целочисленный аргумент - адрес "1/(1-x) = %lf\n", сохраняем в si
	# Первй аргумент с плавающей точкой - x, сохраняем в xmm0
	# Один аргумент с плавающей точкой => ax = 1
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -8[rbp]
	movq	xmm0, rdx
	lea	rdx, .LC6[rip]
	mov	rsi, rdx
	mov	rdi, rax
	mov	eax, 1
	# Вызываем fprintf
	call	fprintf@PLT

	# Первый целочисленный аргумент остаётся такой же - адрес на файловый поток
	# Второй целочисленный аргумент - адрес "iterations: %d", сохраняем в si
	# Третий целочисленный аргумент - count, сохраняем в dx
	# 0 аргументов с плавающей точкой => ax = 0
	mov	edx, DWORD PTR -28[rbp]
	mov	rax, QWORD PTR -8[rbp]
	lea	rcx, .LC7[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 0
	# Вызываем fprintf
	call	fprintf@PLT
	mov	eax, 0
.L20:
	leave
	ret
	.size	fileOutput, .-fileOutput
	.globl	random_arg
	.type	random_arg, @function

random_arg:
	# Подготовительные действия
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48

	# Кладём в xmm0 -1, сохраняем на стеке (min)
	movsd	xmm0, QWORD PTR .LC5[rip]
	movsd	QWORD PTR -24[rbp], xmm0

	# Кладём в xmm0 1, сохраняем на стеке (max)
	movsd	xmm0, QWORD PTR .LC0[rip]
	movsd	QWORD PTR -16[rbp], xmm0

	# Считаем max - min, сохраняем результат в xmm0
	movsd	xmm0, QWORD PTR -16[rbp]
	subsd	xmm0, QWORD PTR -24[rbp]

	# Записываем в xmm1 RAND_MAX
	movsd	xmm1, QWORD PTR .LC10[rip]
	# Делим на RAND_MAX
	divsd	xmm0, xmm1
	# Сохраняем результат на стеке
	movsd	QWORD PTR -40[rbp], xmm0
	# Вызываем rand
	call	rand@PLT
	# Полученное число лежит в ax, записываем в xmm0
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, eax
	# Умножаем полученное ранее число ((max - min) / RAND_MAX) на результат rand
	mulsd	xmm0, QWORD PTR -40[rbp]
	# Записываем min в xmm1
	movsd	xmm1, QWORD PTR -24[rbp]
	# Прибавляем его
	addsd	xmm0, xmm1
	# Полученное значение сохраняем на стеке (x)
	movsd	QWORD PTR -8[rbp], xmm0

	# Выводим x
	mov	rax, QWORD PTR -8[rbp]
	movq	xmm0, rax
	lea	rax, .LC4[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT

	# Записываем x в ax, т.к. это значение нужно вернуть
	movsd	xmm0, QWORD PTR -8[rbp]
	movq	rax, xmm0
	movq	xmm0, rax
	leave
	ret
	.size	random_arg, .-random_arg
	.globl	noteRandomInput
	.type	noteRandomInput, @function
noteRandomInput:
	# Подготовительные действич
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	# Первый аргумент с плавающей точкой - значение x (хранится в xmm0)
	# Записываем на стек
	movsd	QWORD PTR -24[rbp], xmm0
	# Первый целочисленный аргумент - argv, записываем на стек
	mov	QWORD PTR -32[rbp], rdi
	# Получаем argv[1], записываем в di
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC9[rip]
	mov	rsi, rdx
	mov	rdi, rax
	# Открываем файловый поток
	call	fopen@PLT
	# Адрес на него лежит в ax
	mov	QWORD PTR -8[rbp], rax
	# Проверяем на NULL
	cmp	QWORD PTR -8[rbp], 0
	jne	.L24
	mov	eax, 2
	jmp	.L25
.L24:
	# Первый аргумент с плавающей точкой - x, записываем в xmm0
	# Первый целочисленный аргумент - адрес на поток, записываем в di
	# Второй целочисленный аргумент - адрес на "%lf", записываем в si
	# 1 аргумент с плавающей точкой => ax = 0
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -8[rbp]
	movq	xmm0, rdx
	lea	rdx, .LC4[rip]
	mov	rsi, rdx
	mov	rdi, rax
	mov	eax, 1
	# Вызываем printf
	call	fprintf@PLT
	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	# Закрываем файловый поток
	call	fclose@PLT
	mov	eax, 0
.L25:
	leave
	ret
	.size	noteRandomInput, .-noteRandomInput
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.align 16
.LC1:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.align 8
.LC2:
	.long	-1698910392
	.long	1048238066
	.align 8
.LC5:
	.long	0
	.long	-1074790400
	.align 8
.LC10:
	.long	-4194304
	.long	1105199103
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
