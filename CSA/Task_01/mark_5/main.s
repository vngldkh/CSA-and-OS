	.file	"main.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"length? "
.LC1:
	.string	"%d"
	.text
	.globl	getLength
	.type	getLength, @function
getLength:
	# Подготовительные действия в соответствии с calling convention
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	# Обнуляем eax - выходной параметр
	xor	eax, eax
	# Зануляем size
	mov	DWORD PTR -12[rbp], 0
# Метка input
.L2:
	# Выводим строку "length? "
	lea	rax, .LC0[rip]
	# Строка - первый параметр, поэтому кладём в rdi
	mov	rdi, rax
	# 0 параметров с плавающей точкой, поэтому eax = 0
	mov	eax, 0
	# Вызываем функцию printf
	call	printf@PLT

	# Адрес на size - второй параметр, поэтому кладём его в rsi
	lea	rax, -12[rbp]
	mov	rsi, rax
	# Строка "%d" - первый параметр, поэтому кладём её адрес в rdi
	lea	rax, .LC1[rip]
	mov	rdi, rax
	# 0 параметров с плавающей точкой, поэтому eax = 0
	mov	eax, 0
	# Вызываем функцию printf
	call	__isoc99_scanf@PLT

	# Сравниваем size с нулём
	mov	eax, DWORD PTR -12[rbp]
	test	eax, eax
	# Если size > 0 переходим к .L3
	jg	.L3
	# Иначе возвращаемся к .L2 (заново вводим size)
	jmp	.L2
.L3:
	# Проверяем, что мы освободили столько же памяти на стеке, сколько и занимали
	nop
	# Возвращаемое значение должно лежать в ax, поэтому кладём туда size
	mov	eax, DWORD PTR -12[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L4
	call	__stack_chk_fail@PLT
.L4:
	leave
	ret
	.size	getLength, .-getLength
	.section	.rodata
.LC2:
	.string	"A[%d]? "
.LC3:
	.string	"%lf"
	.text
	.globl	inputA
	.type	inputA, @function
inputA:
	# Подготовительные действия в соответствии с calling convention
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	# Сохраняем входные параметры на стеке
	mov	QWORD PTR -24[rbp], rdi # Адрес на A
	mov	DWORD PTR -28[rbp], esi # Размер массива
	# Инициализируем i
	mov	DWORD PTR -4[rbp], 0
	# Переходим к проверке условия цикла
	jmp	.L6
.L7:
	# Выводим "A[%d]? ", подставляя i
	# i - второй параметр, поэтому кладём его в si
	mov	eax, DWORD PTR -4[rbp]
	mov	esi, eax
	# Строка - первый параметр, поэтому кладём ее адрес в rdi
	lea	rax, .LC2[rip]
	mov	rdi, rax
	# 0 аргументов с плавающей точкой => ax = 0
	mov	eax, 0
	# Вызываем функцию printf
	call	printf@PLT

	# Кладём i в ax
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	# Получаем адрес A[i]: сдвиг до А + i * 8
	lea	rdx, 0[0+rax*8] # Сдвиг относительно начала А
	mov	rax, QWORD PTR -24[rbp] # Сдвиг до А
	add	rax, rdx
	# Адрес на A[i] - второй аргумент, кладём в si
	mov	rsi, rax
	# Строка "A[%d]? " - первый аргумент, поэтому кладём её адрес в di
	lea	rax, .LC3[rip]
	mov	rdi, rax
	# 0 аргументов с плавающей точкой => ax = 0
	mov	eax, 0
	# Вызываем функцию scanf
	call	__isoc99_scanf@PLT

	# ++i
	add	DWORD PTR -4[rbp], 1
.L6:
	# Кладём в eax i и сравниваем его с size
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	# Если i < size, переходим в тело цикла (.L7)
	jl	.L7
	nop
	nop
	leave
	# Возвращаемся из функции
	ret
	.size	inputA, .-inputA
	.globl	makeB
	.type	makeB, @function
makeB:
	# Подготовительные действия в соответствии с calling convention
	endbr64
	push	rbp
	mov	rbp, rsp
	# Кладём полученные аргументы в стек
	mov	QWORD PTR -24[rbp], rdi # Адрес на начало A
	mov	QWORD PTR -32[rbp], rsi # Адрес на начало B
	mov	DWORD PTR -36[rbp], edx # size

	# Инициализируем i
	mov	DWORD PTR -4[rbp], 0
	# Переходим к проверке условия цикла
	jmp	.L9
.L10:
	# Сохраняем i в eax
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	# Получаем адрес A[i]: сдвиг до А + i * 8
	lea	rdx, 0[0+rax*8] # Сдвиг до элемента относительно начала A
	mov	rax, QWORD PTR -24[rbp] # Сдвиг до А
	add	rax, rdx # В rax хранится адрес на A[i]

	movsd	xmm1, QWORD PTR [rax] # Записываем значение А[i] в xmm1
	movsd	xmm0, QWORD PTR .LC4[rip] # 9.8
	mulsd	xmm1, xmm0 # xmm1 = 9.8 * A[i]
	mov	eax, DWORD PTR -4[rbp]
	cdqe

	# Получаем адрес A[i]: сдвиг до А + i * 8
	lea	rdx, 0[0+rax*8]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx

	movsd	xmm0, QWORD PTR [rax] # Записываем значение А[i] в xmm0
	mulsd	xmm0, xmm1 # xmm0 = xmm1 * A[i] = 9.8 * A[i] * A[i]

	# Сохраняем i в eax
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	# Получаем адрес B[i]: сдвиг до B + i * 8
	lea	rdx, 0[0+rax*8] # Сдвиг до элемента относительно начала B
	mov	rax, QWORD PTR -32[rbp] # Сдвиг до B
	add	rax, rdx # В rax хранится адрес на B[i]

	movsd	xmm1, QWORD PTR .LC5[rip] # 2
	divsd	xmm0, xmm1 # xmm0 = xmm0 / 2 = 9.8 * A[i] * A[i] / 2
	movsd	QWORD PTR [rax], xmm0 # Сохраняем значение xmm0 в B[i]
	add	DWORD PTR -4[rbp], 1
.L9:
	# Кладём i в eax, сравниваем его с size
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -36[rbp]
	# Если i < size, переходим в тело цикла (.L10)
	jl	.L10
	nop
	nop
	pop	rbp
	# Возвращаемся из функции
	ret
	.size	makeB, .-makeB
	.section	.rodata
.LC6:
	.string	"A[%d] = %lfs; B[%d] = %lfm\n"
	.text
	.globl	main
	.type	main, @function
main:
	# Подготовительные действия в соответствии с calling convention
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 88
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -56[rbp], rax
	xor	eax, eax
	mov	rax, rsp
	mov	rbx, rax
	# 0 аргументов с плавающей точкой => ax = 0
	mov	eax, 0
	call	getLength
	# В eax хранится полученный размер, кладём его на стек
	mov	DWORD PTR -92[rbp], eax

	# Создаём массив А
	mov	eax, DWORD PTR -92[rbp]
	movsx	rdx, eax
	sub	rdx, 1
	mov	QWORD PTR -88[rbp], rdx
	movsx	rdx, eax
	mov	QWORD PTR -112[rbp], rdx
	mov	QWORD PTR -104[rbp], 0
	movsx	rdx, eax
	mov	QWORD PTR -128[rbp], rdx
	mov	QWORD PTR -120[rbp], 0
	cdqe
	lea	rdx, 0[0+rax*8]
	mov	eax, 16
	sub	rax, 1
	add	rax, rdx
	mov	esi, 16
	mov	edx, 0
	div	rsi
	imul	rax, rax, 16
	mov	rcx, rax
	and	rcx, -4096
	mov	rdx, rsp
	sub	rdx, rcx
.L12:
	cmp	rsp, rdx
	je	.L13
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L12
.L13:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L14
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L14:
	mov	rax, rsp
	add	rax, 7
	shr	rax, 3
	sal	rax, 3
	# Сохраняем сдвиг до массива на стеке
	mov	QWORD PTR -80[rbp], rax

	# Создаём массив B
	mov	eax, DWORD PTR -92[rbp]
	movsx	rdx, eax
	sub	rdx, 1
	mov	QWORD PTR -72[rbp], rdx
	movsx	rdx, eax
	mov	r14, rdx
	mov	r15d, 0
	movsx	rdx, eax
	mov	r12, rdx
	mov	r13d, 0
	cdqe
	lea	rdx, 0[0+rax*8]
	mov	eax, 16
	sub	rax, 1
	add	rax, rdx
	mov	edi, 16
	mov	edx, 0
	div	rdi
	imul	rax, rax, 16
	mov	rcx, rax
	and	rcx, -4096
	mov	rdx, rsp
	sub	rdx, rcx
.L15:
	cmp	rsp, rdx
	je	.L16
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L15
.L16:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L17
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L17:
	mov	rax, rsp
	add	rax, 7
	shr	rax, 3
	sal	rax, 3
	# Сохраняем сдвиг до массива на стеке
	mov	QWORD PTR -64[rbp], rax

	# Адрес А - первый аргумент, поэтому сохраняем в регистре di
	# Размер - второй аргумент, сохраняем его в регистре si
	mov	edx, DWORD PTR -92[rbp]
	mov	rax, QWORD PTR -80[rbp]
	mov	esi, edx
	mov	rdi, rax
	# Вызываем функцию inputA
	call	inputA

	# Адрес А - первый аргумент, поэтому сохраняем в регистре di
	# Адрес B - второй аргумент, сохраняем его в регистре si
	# Размер - третий аргумент, сохраняем его в регистре dx
	mov	edx, DWORD PTR -92[rbp]
	mov	rcx, QWORD PTR -64[rbp]
	mov	rax, QWORD PTR -80[rbp]
	mov	rsi, rcx
	mov	rdi, rax
	# Вызываем функцию makeB
	call	makeB

	# Инициализируем i
	mov	DWORD PTR -96[rbp], 0
	# Переходим к проверке условия в цикле
	jmp	.L18
.L19:
	# Получаем адрес B[i]
	mov	rax, QWORD PTR -64[rbp] # Сдвиг до начала B
	mov	edx, DWORD PTR -96[rbp] # i
	movsx	rdx, edx
	# Адрес B[i] = сдвиг до начала B + i * 8
	movsd	xmm0, QWORD PTR [rax+rdx*8] 

	# Получаем адрес A[i]
	mov	rax, QWORD PTR -80[rbp] # Сдвиг до начала A
	mov	edx, DWORD PTR -96[rbp] # i
	movsx	rdx, edx
	# Адрес A[i] = сдвиг до начала A + i * 8
	mov	rcx, QWORD PTR [rax+rdx*8]
	mov	edx, DWORD PTR -96[rbp]
	mov	eax, DWORD PTR -96[rbp]
	# B[i] - второй аргумент с плавающей точкой, поэтому кладём его значение в xmm1
	movapd	xmm1, xmm0
	# A[i] - первый аргумент с плавающей точкой, поэтому кладём его значение в xmm0
	movq	xmm0, rcx
	# i - второй целочисленный аргумент, кладём его значение в si
	mov	esi, eax
	# Строка "A[%d] = %lfs; B[%d] = %lfm\n" - первый аргумент, поэтому кладём её адрес в di
	lea	rax, .LC6[rip]
	mov	rdi, rax
	# Два параметра с плавающей точкой => eax = 2
	mov	eax, 2
	# Вызываем функцию printf
	call	printf@PLT

	# ++i
	add	DWORD PTR -96[rbp], 1
.L18:
	# Проверка условия цикла
    # Сравниваем i с size (в eax кладём size, DWORD PTR -96[rbp] - i)
	mov	eax, DWORD PTR -96[rbp]
	cmp	eax, DWORD PTR -92[rbp]
	# Если i < size, переходим в тело цикла (.L19)
	jl	.L19

	mov	eax, 0
	# Возвращаем stack pointer в изначальную позицию 
	mov	rsp, rbx
	mov	rdx, QWORD PTR -56[rbp]
	# Проверяем, что было очищено столько же памяти, сколько выделено
	sub	rdx, QWORD PTR fs:40
	je	.L21
	call	__stack_chk_fail@PLT
.L21:
	# Достаём предварительно сохранённые значения регистров
	lea	rsp, -40[rbp]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC4:
	.long	-1717986918
	.long	1076074905
	.align 8
.LC5:
	.long	0
	.long	1073741824
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
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
