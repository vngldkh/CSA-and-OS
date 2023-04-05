	.file	"main.c"
	.intel_syntax noprefix
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"length? "
.LC1:
	.string	"%d"
	.text
	.p2align 4
	.globl	getLength
	.type	getLength, @function
getLength:
	# Подготовительные действия в соответствии с calling convention
	endbr64
	push	r12
	push	rbp
	push	rbx
	sub	rsp, 16
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 8[rsp], rax

	# Кладём в r12 адрес "length? "
	lea	r12, .LC0[rip]
	# Кладём в rbx адрес "%d"
	lea	rbx, .LC1[rip]
	xor	eax, eax
	# Зануляем size
	mov	DWORD PTR 4[rsp], 0
	# Сохраняем адрес на size в rbp, чтобы обращаться к нему быстрее
	lea	rbp, 4[rsp]
# Метка input
.L2:
	# У printf_chk строка - второй параметр, поэтому записываем её адрес в si
	mov	rsi, r12
	# Первый параметр - флаг
	mov	edi, 1
	xor	eax, eax
	# Вызываем printf_chk
	call	__printf_chk@PLT

	# В rbp хранится адрес на size
	# Сохраняем его в si, потому что это второй параметр функции
	mov	rsi, rbp
	# В rbx хранится адрес "%d"
	# Сохраняем его в di, потому что это первый параметр функции
	mov	rdi, rbx
	xor	eax, eax
	# Вызываем функцию scanf
	call	__isoc99_scanf@PLT

	# Сраниваем size с 0
	mov	eax, DWORD PTR [rbp]
	test	eax, eax
	# Если size <= 0 переходим к .L2 (заново вводим size)
	jle	.L2
	# Проверяем, что мы освободили столько же памяти на стеке, сколько и занимали
	mov	rdx, QWORD PTR 8[rsp]
	sub	rdx, QWORD PTR fs:40
	jne	.L7
	add	rsp, 16
	pop	rbx
	pop	rbp
	pop	r12
	ret
.L7:
	call	__stack_chk_fail@PLT
	.size	getLength, .-getLength
	.section	.rodata.str1.1
.LC2:
	.string	"A[%d]? "
.LC3:
	.string	"%lf"
	.text
	.globl	inputA
	.type	inputA, @function
inputA:
	endbr64
	# Если размер <= 0, ничего не делаем, сразу возвращаемся
	test	esi, esi
	jle	.L13

	# Сохраняем значения регистров в соответствии с calling convention
	push	r14
	# Сохраняем адрес на строку "A[%d]? " в r14
	lea	r14, .LC2[rip]
	push	r13
	# Сохраняем адрес на строку "%lf" в r13
	lea	r13, .LC3[rip]
	push	r12
	# Записываем размер массива (size) в регистр r12d, а не на стек
	# mov	DWORD PTR -28[rbp], esi - аналог в предыдущей программе
	mov	r12d, esi
	push	rbp
	# Записываем адрес первого элемента массива в регистр rbp, а не на стек
	# mov	QWORD PTR -24[rbp], rdi  - аналог в предыдущей программе
	mov	rbp, rdi
	push	rbx
	# Очищаем ebx и используем его как i, не сохраняя i на стеке
	# mov	DWORD PTR -4[rbp], 0 - аналог в предыдущей програме
	xor	ebx, ebx
.L10:
	# Выводим "A[%d]? ", подставляя i
	# Строка - второй аргумент, записываем ее адрес в si
	# Флаг - первый аргумент, записываем 1 в di
	# i - третий аргумент, записываем его в dx
	mov	edx, ebx
	mov	rsi, r14
	mov	edi, 1
	xor	eax, eax
	# Вызываем функцию printf_chk
	call	__printf_chk@PLT

	# Считываем значение A[i]
	# ++i
	add	ebx, 1
	# Ссылка на A[i] - второй аргумент, поэтому по соглашению записываем в si
	mov	rsi, rbp
	# Строка - первый аргумент, поэтому записываем её адрес в di
	mov	rdi, r13
	# Очищаем eax, то есть приравниваем к 0, 
	# потому что у нас нет аргументов с плавающей точкой
	xor	eax, eax
	# На первой итерации rbp указывает на 1 элемент массива.
	# На каждой итерации сдвигаем этот указатель на 8 байт, 
	# чтобы он указывал на следующий элемент
	add	rbp, 8
	# Вызываем scanf
	call	__isoc99_scanf@PLT

	# Проверяем условие цикла
	cmp	r12d, ebx
	# Если i != size, идём в тело цикла
	jne	.L10

	# Достаём ранее сохранённые значения из стека
	pop	rbx
	pop	rbp
	pop	r12
	pop	r13
	pop	r14
	# Возвращаемся из функции
	ret
.L13:
	ret
	.size	inputA, .-inputA
	.globl	makeB
	.type	makeB, @function
makeB:
	endbr64
	# Если размер = 0, сразу выходит из функции
	test	edx, edx
	jle	.L16

	movsd	xmm3, QWORD PTR .LC4[rip] # 9.8
	movsd	xmm2, QWORD PTR .LC5[rip] # 0.5

	# Записываем в rdx значение size
	movsx	rdx, edx

	# Очищаем ax, чтобы использовать его как i
	# В прошлой программе для этого выделялось место на стеке
	# mov	DWORD PTR -4[rbp], 0
	xor	eax, eax
.L18:
	# rdi - первый аргумент, указывает на первый элемент А
	# rax - это i, 8*i - сдвиг относительно начала массива
	# Записываем значение A[i] в xmm1 и xmm0
	movsd	xmm1, QWORD PTR [rdi+rax*8]
	movapd	xmm0, xmm1 
	mulsd	xmm0, xmm3 # xmm0 = A[i] * 9.8 
	mulsd	xmm0, xmm1 # xmm0 = xmm0 * A[i] = A[i] * 9.8 * A[i]
	# Деление изменилось на умножение
	mulsd	xmm0, xmm2 # xmm0 = xmm0 * 0.5 = A[i] * 9.8 * A[i]
	# rsi - второй аргумент, указывает на первый элемент B
	# Присваиваем B[i] значение xmm0
	movsd	QWORD PTR [rsi+rax*8], xmm0

	# ++i
	add	rax, 1
	# Проверяем условие цикла
	# Если i != size, возвращаемся в тело цикла
	cmp	rdx, rax
	jne	.L18
.L16:
	ret
	.size	makeB, .-makeB
	.section	.rodata.str1.1
.LC6:
	.string	"A[%d] = %lfs; B[%d] = %lfm\n"
	.section	.text.startup,"ax",@progbits
	.globl	main
	.type	main, @function
main:
	# Подготовительные действия в соответствии с calling convention
	# Кладём в стек старые значения определённых регистров, чтобы запомнить и потом вернуть
	# Выделяем память на стеке под локальные переменные, сдвигая stack pointer
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 24
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -56[rbp], rax
	xor	eax, eax

	# Вызываем функцию getLength
	# Полученная длина хранится в eax
	# size не кладём в стек, в отличие от предыдущей программы
	call	getLength
	mov	rcx, rsp
	# Освобождаем ax, сохранив size в регистре r12
	movsx	r12, eax

	# Создаём массивы А и В, выравниваем память
	lea	rax, 15[0+r12*8]
	# Сохраняем size в rbx
	mov	rbx, r12
	mov	rsi, rax
	mov	rdx, rax
	and	rsi, -4096
	and	rdx, -16
	sub	rcx, rsi
	cmp	rsp, rcx
	je	.L22
.L38:
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	cmp	rsp, rcx
	jne	.L38
.L22:
	and	edx, 4095
	sub	rsp, rdx
	test	rdx, rdx
	jne	.L39
.L23:
	mov	rdx, rax
	mov	rcx, rsp
	and	rax, -4096
	# Записываем в r15 смещение до А
	mov	r15, rsp
	and	rdx, -16
	sub	rcx, rax
.L24:
	cmp	rsp, rcx
	je	.L25
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L24
.L39:
	or	QWORD PTR -8[rsp+rdx], 0
	jmp	.L23
.L25:
	and	edx, 4095
	sub	rsp, rdx
	test	rdx, rdx
	jne	.L40
.L26:
	# size - второй параметр, поэтому записываем его в si
	mov	esi, ebx
	# А - первый параметр, поэтому указатель на его первый элемент записываем в rdi
	mov	rdi, r15
	# Записываем в r14 смещение до B
	mov	r14, rsp
	# Вызываем функцию inputA
	call	inputA

	# size - третий параметр, поэтому записываем его в dx
	mov	edx, ebx
	# B - второй параметр, поэтому указатель на его первый элемент записываем в rsi
	mov	rsi, r14
	# А - первый параметр, поэтому указатель на его первый элемент записываем в rdi
	mov	rdi, r15
	# Вызываем функцию makeB
	call	makeB

	# Если size = 0, сразу выходим из функции
	test	ebx, ebx
	jle	.L27

	# Обнуляем ebx, чтобы использовать его как счётчик (i), не выделяя память на стеке
	# mov	DWORD PTR -96[rbp], 0 - в прошлой программе
	xor	ebx, ebx
	# В r13 записываем адрес строки "A[%d] = %lfs; B[%d] = %lfm\n"
	lea	r13, .LC6[rip]
.L28:
	# Тело цикла
	# В xmm0 записываем значение A[i] - первый аргумент с плавающей точкой
	movsd	xmm0, QWORD PTR [r15+rbx*8]
	# В xmm1 записываем значение B[i] - второй аргумент с плавающей точкой
	movsd	xmm1, QWORD PTR [r14+rbx*8]
	# Целочисленные аргументы:
	# 1й - флаг, устанавливаем значение 1, записываем в di
	# 2й - адресс строки, записываем в si
	# 3й - i, записываем в dx
	# 4й - i, записываем в cx
	mov	edx, ebx
	mov	ecx, ebx
	mov	rsi, r13
	mov	edi, 1
	# Аргументов с плавающей точкой 2 => eax = 2
	mov	eax, 2
	# ++i
	add	rbx, 1
	# Вызываем printf_chk
	call	__printf_chk@PLT

	# Проверяем условие цикла
	# Если i != size, возвращаемся в тело цикла
	cmp	rbx, r12
	jne	.L28
.L27:
	# Проверяем, что освободили памяти на стеке, столько же, сколько и занимали
	mov	rax, QWORD PTR -56[rbp]
	sub	rax, QWORD PTR fs:40
	jne	.L41
	lea	rsp, -40[rbp]
	xor	eax, eax
	# Восстанавливаем сохранённые значения регистров
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	# Возвращаемся из функции
	ret
.L40:
	or	QWORD PTR -8[rsp+rdx], 0
	jmp	.L26
.L41:
	call	__stack_chk_fail@PLT
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
.LC4:
	.long	-1717986918
	.long	1076074905
.LC5:
	.long	0
	.long	1071644672
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
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
4:
