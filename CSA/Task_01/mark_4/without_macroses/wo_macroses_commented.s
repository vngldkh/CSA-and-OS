	.file	"main.c"
	.intel_syntax noprefix
	.text
	.section	.rodata
.LC0:
	.string	"length? "
.LC1:
	.string	"%d"
.LC2:
	.string	"A[%d]? "
.LC3:
	.string	"%lf"
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
	sub	rsp, 104
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -56[rbp], rax
	xor	eax, eax

        # Инициализируем переменную size
	mov	DWORD PTR -100[rbp], 0
.L2:
        # Выводим строку "length? "
        # rdi - первый параметр функции, передаём строку
	lea	rax, .LC0[rip]
	mov	rdi, rax
        # 0 аргументов с плавающей точкой => ax = 0
	mov	eax, 0
        # Вызываем функцию printf
	call	printf@PLT

        # Считываем размер массива в size
        # Второй аргумент - адрес на size, кладём в rsi
	lea	rax, -100[rbp]
	mov	rsi, rax
        # Первый аргумент - строка "%d", кладем её адрес в rdi
	lea	rax, .LC1[rip]
	mov	rdi, rax
        # 0 аргументов с плавающей точкой => ax = 0
	mov	eax, 0
        # Вызываем функцию scanf
	call	__isoc99_scanf@PLT

        # Сравниваем size с нулём
	mov	eax, DWORD PTR -100[rbp]
	test	eax, eax
        # Если size > 0 переходим к .L3
	jg	.L3
        # Иначе возвращаемся к .L2 (заново вводим size)
	jmp	.L2
.L3:
        # Создаём массивы A и B, выравниваем память
        # Создаём массив A
	mov	eax, DWORD PTR -100[rbp]
	mov	rdx, rsp
	mov	rbx, rdx
	movsx	rdx, eax
	sub	rdx, 1
	mov	QWORD PTR -88[rbp], rdx
	movsx	rdx, eax
	mov	QWORD PTR -128[rbp], rdx
	mov	QWORD PTR -120[rbp], 0
	movsx	rdx, eax
	mov	QWORD PTR -144[rbp], rdx
	mov	QWORD PTR -136[rbp], 0
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
.L4:
	cmp	rsp, rdx
	je	.L5
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L4
.L5:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L6
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L6:
	mov	rax, rsp
	add	rax, 7
	shr	rax, 3
	sal	rax, 3
        # Сохраняем сдвиг до A
	mov	QWORD PTR -80[rbp], rax
        # Создаём массив B
	mov	eax, DWORD PTR -100[rbp]
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
.L7:
	cmp	rsp, rdx
	je	.L8
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L7
.L8:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L9
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L9:
	mov	rax, rsp
	add	rax, 7
	shr	rax, 3
	sal	rax, 3
        # Сохраняем сдвиг до B
	mov	QWORD PTR -64[rbp], rax

        # Инициализируем i
	mov	DWORD PTR -96[rbp], 0
        # Переходим к проверке условия в цикле
	jmp	.L10
.L11:
        # Записываем значение i в регистр ax
	mov	eax, DWORD PTR -96[rbp]

        # Выводим строку "A[%d]? ", подставляя значение i
        # i - второй аргумент, записываем в si
	mov	esi, eax
        # Сама строка - первый аргумент, записываем её дрес в di
	lea	rax, .LC2[rip]
	mov	rdi, rax
        # 0 аргументов с плавающей точкой => ax = 0
	mov	eax, 0
        # Вызываем функцию printf
	call	printf@PLT

        # Считываем элемент A[i]
        # Записываем значение i в регистр ax
	mov	eax, DWORD PTR -96[rbp]
	cdqe
        # Получаем адрес A[i]: сдвиг до А + i * 8
	lea	rdx, 0[0+rax*8] # Сдвиг относительно начала А
	mov	rax, QWORD PTR -80[rbp] # Сдвиг до А
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

        # Считаем значение для B[i]
        # Получаем адрес A[i]: сдвиг до А + i * 8
	mov	rax, QWORD PTR -80[rbp] # Сдвиг до А
	mov	edx, DWORD PTR -96[rbp] # i
	movsx	rdx, edx
	movsd	xmm1, QWORD PTR [rax+rdx*8] # Записываем значение А[i] в xmm1
	movsd	xmm0, QWORD PTR .LC4[rip] # 9.8
        # xmm1 = 9.8 * A[i]
	mulsd	xmm1, xmm0 
	mov	rax, QWORD PTR -80[rbp] # Сдвиг до А
	mov	edx, DWORD PTR -96[rbp] # i
	movsx	rdx, edx
	movsd	xmm0, QWORD PTR [rax+rdx*8] # Записываем значение А[i] в xmm0
        # xmm0 = xmm1 * A[i] = 9.8 * A[i] * A[i]
	mulsd	xmm0, xmm1
	movsd	xmm1, QWORD PTR .LC5[rip] # 2
        # xmm0 = xmm0 / 2 = 9.8 * A[i] * A[i] / 2
	divsd	xmm0, xmm1

	mov	rax, QWORD PTR -64[rbp] # Сдвиг до B
	mov	edx, DWORD PTR -96[rbp] # i
	movsx	rdx, edx
        # Записываем значение B[i]
	movsd	QWORD PTR [rax+rdx*8], xmm0

        # ++i
	add	DWORD PTR -96[rbp], 1
.L10:
        # Проверка условия цикла
        # Сравниваем i с size (в eax кладём size, DWORD PTR -96[rbp] - i)
	mov	eax, DWORD PTR -100[rbp]
	cmp	DWORD PTR -96[rbp], eax
        # Если i < size, переходим в тело цикла (.L11)
	jl	.L11

        # Иначе переходим к следующему циклу
        # Инициализируем i
	mov	DWORD PTR -92[rbp], 0
        # Переходим к проверке условия цикла
	jmp	.L12
.L13:
        # Выводим "A[%d] = %lfs; B[%d] = %lfm\n", подставляя соответствующие элементы
        # A[i] - первый аргумент типа double, сохраняем в xmm0
        # B[i] - второй аргумент типа double, сохраняем в xmm1
        # i - второй и третий целочисленный аргумент, сохраняем в si и dx
	mov	rax, QWORD PTR -64[rbp] # Сдвиг до B
	mov	edx, DWORD PTR -92[rbp] # i
	movsx	rdx, edx
        # Записываем значение B[i]
	movsd	xmm0, QWORD PTR [rax+rdx*8] 

	mov	rax, QWORD PTR -80[rbp] # Сдвиг до А
	mov	edx, DWORD PTR -92[rbp] # i
	movsx	rdx, edx
        # Записываем значение A[i]
	mov	rcx, QWORD PTR [rax+rdx*8]
	mov	edx, DWORD PTR -92[rbp]
	mov	eax, DWORD PTR -92[rbp]

	movapd	xmm1, xmm0 # xmm1 - B[i], xmm0 - A[i]
	movq	xmm0, rcx
	mov	esi, eax
        # Строка "A[%d] = %lfs; B[%d] = %lfm\n" - первый аргумент, кладём её адрес в di
	lea	rax, .LC6[rip]
	mov	rdi, rax
        # Два параметра с плавающей точкой => eax = 2
	mov	eax, 2
        # Вызываем функцию printf
	call	printf@PLT

        # ++i
	add	DWORD PTR -92[rbp], 1
.L12:
        # Проверка условия цикла
	mov	eax, DWORD PTR -100[rbp] # i
        # Сравниваем i с size
	cmp	DWORD PTR -92[rbp], eax 
        # Если i < size, переходим в тело цикла (.L13)
	jl	.L13
	mov	eax, 0
	mov	rsp, rbx
	mov	rdx, QWORD PTR -56[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L15
	call	__stack_chk_fail@PLT
.L15:
        # Возвращаем stack pointer в изначальную позицию 
	lea	rsp, -40[rbp]

        # Достаём предварительно сохранённые значения регистров
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp

        # Выходим из функции
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
