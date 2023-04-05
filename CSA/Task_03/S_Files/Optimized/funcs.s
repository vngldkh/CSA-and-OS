	.file	"funcs.c"
	.intel_syntax noprefix
	.text
	.globl	func
	.type	func, @function
func:
	endbr64
	# x сохраняем в xmm4, а не на стеке
	movapd	xmm4, xmm0
	# В xmm0 кладём 1
	movsd	xmm0, QWORD PTR .LC0[rip]
	# eax - счётчик, в будущем значение iterations
	mov	eax, 0
	movq	xmm6, QWORD PTR .LC1[rip]
	# В xmm5 храним 0.005
	movsd	xmm5, QWORD PTR .LC2[rip]
	# В xmm2 будем хранить summand
	movapd	xmm2, xmm4
	# К xmm0 прибавляем x, будем хранить здесь new
	addsd	xmm0, xmm4
.L2:
	mulsd	xmm2, xmm4
	# В xmm3 будем хранить prev
	movapd	xmm3, xmm0
	add	eax, 1
	mov	edx, eax
	addsd	xmm0, xmm2
	movapd	xmm1, xmm0
	subsd	xmm1, xmm3
	andpd	xmm1, xmm6
	comisd	xmm1, xmm5
	ja	.L2
	mov	DWORD PTR [rdi], edx
	ret
	.size	func, .-func
	.section	.rodata.str1.1,"aMS",@progbits,1

.LC3:
	.string	"x? "
.LC4:
	.string	"%lf"
	.text
	.globl	consoleInput
	.type	consoleInput, @function
consoleInput:
	endbr64
	push	rbx

	# В rbx записываем первый параметр (указатель на x), не сохраняем его не стеке
	mov	rbx, rdi

	lea	rdi, .LC3[rip]
	xor	eax, eax
	call	printf@PLT
	xor	eax, eax
	mov	rsi, rbx
	lea	rdi, .LC4[rip]
	call	__isoc99_scanf@PLT

	movsd	xmm0, QWORD PTR [rbx]
	mov	eax, 1
	movsd	xmm1, QWORD PTR .LC5[rip]
	comisd	xmm1, xmm0
	jnb	.L5
	xor	eax, eax
	comisd	xmm0, QWORD PTR .LC0[rip]
	setnb	al
.L5:
	pop	rbx
	ret
	.size	consoleInput, .-consoleInput
	.section	.rodata.str1.1

.LC6:
	.string	"1/(1-x) = %lf\n"
.LC7:
	.string	"iterations: %d"
	.text
	.globl	consoleOutput
	.type	consoleOutput, @function
consoleOutput:
	endbr64
	push	r12
	# xmm0 - первый аргумент с плавающей точкой, оставим его там
	# Сохраняем count (первый целочисленный аргумент) в r12d, не на стек
	mov	r12d, edi

	lea	rdi, .LC6[rip]
	# Значение x - первый аргумент с плавающей точкой, уже лежит в xmm0
	# Кол-во аргументов с плавающей точкой - 1
	mov eax, 1
	call	printf@PLT
	mov	edx, r12d
	mov	edi, 1
	xor	eax, eax
	lea	rsi, .LC7[rip]
	pop	r12
	jmp	__printf_chk@PLT
	.size	consoleOutput, .-consoleOutput
	.section	.rodata.str1.1

.LC8:
	.string	"r"
	.text
	.p2align 4
	.globl	fileInput
	.type	fileInput, @function
fileInput:
	endbr64
	push	rbp
	push	rbx
	# Первый аргумент (хранится в di) - указатель на x, сохраняем в rbx, а не на стеке
	mov	rbx, rdi
	# Получаем argv[1], сохраняем в rdi
	sub	rsp, 8
	mov	rdi, QWORD PTR 8[rsi]
	lea	rsi, .LC8[rip]
	call	fopen@PLT

	# Проверяем полученный адрес на NULL (возвращаемое значение хранится в ax)
	test	rax, rax
	je	.L14

	# Сохраняем адрес на открытый файловый поток в rdi и rbp, не на стек
	mov	rdi, rax
	mov	rbp, rax
	mov	rdx, rbx
	xor	eax, eax
	lea	rsi, .LC4[rip]
	# Первый аргумент - файловый поток, хранится в rdi
	# Второй аргумент - адрес на строку, хранится в si
	# Третий аргумент - адрес на x, хранится в rdx
	call	__isoc99_fscanf@PLT
	movsd	xmm0, QWORD PTR [rbx]
	mov	eax, 1
	movsd	xmm1, QWORD PTR .LC5[rip]
	comisd	xmm1, xmm0
	jnb	.L12
	comisd	xmm0, QWORD PTR .LC0[rip]
	jb	.L18
.L12:
	add	rsp, 8
	pop	rbx
	pop	rbp
	ret
.L18:
	mov	rdi, rbp
	call	fclose@PLT
	add	rsp, 8
	xor	eax, eax
	pop	rbx
	pop	rbp
	ret
.L14:
	mov	eax, 2
	jmp	.L12
	.size	fileInput, .-fileInput
	.section	.rodata.str1.1

.LC9:
	.string	"w"
	.text
	.p2align 4
	.globl	fileOutput
	.type	fileOutput, @function
fileOutput:
	endbr64
	push	r12
	push	rbp
	sub	rsp, 24
	# Первый аргумент с плавающей точкой хранится в xmm0, там он и останется
	# Первый целочисленный аргумент - count, сохраняем в r12d, а не на стек
	mov	r12d, edi
	# Записываем argv[2] в rdi
	mov	rdi, QWORD PTR 16[rsi]
	lea	rsi, .LC9[rip]
	movsd	QWORD PTR 8[rsp], xmm0
	call	fopen@PLT
	test	rax, rax
	je	.L21
	movsd	xmm0, QWORD PTR 8[rsp]
	mov	rdi, rax
	mov	rbp, rax
	lea	rsi, .LC6[rip]
	mov	eax, 1
	call	fprintf@PLT
	mov	ecx, r12d
	mov	rdi, rbp
	lea	rsi, .LC7[rip]
	xor	eax, eax
	call	fprintf@PLT
	xor	eax, eax
.L19:
	add	rsp, 24
	pop	rbp
	pop	r12
	ret
.L21:
	mov	eax, 1
	jmp	.L19
	.size	fileOutput, .-fileOutput
	.globl	random_arg
	.type	random_arg, @function
random_arg:
	endbr64
	sub	rsp, 24
	call	rand@PLT
	# Результат хранится в ax, записываем в xmm0, а не на стек
	pxor	xmm0, xmm0

	# Считаем min + (max - min) / RAND_MAX * rand() в xmm0
	# Промежуточные значения на стек не сохраняем
	lea	rsi, .LC4[rip]
	cvtsi2sd	xmm0, eax
	mulsd	xmm0, QWORD PTR .LC10[rip]
	mov	eax, 1
	subsd	xmm0, QWORD PTR .LC0[rip]
	movsd	QWORD PTR 8[rsp], xmm0
	# Выводим x
	call	__printf_chk@PLT
	movsd	xmm0, QWORD PTR 8[rsp]
	add	rsp, 24
	ret
	.size	random_arg, .-random_arg
	.globl	noteRandomInput
	.type	noteRandomInput, @function
noteRandomInput:
	endbr64
	push	rbp
	lea	rsi, .LC9[rip]
	sub	rsp, 16
	# x лежал в xmm0, там и продолжит храниться
	# Получаем argv[2], записываем в rdi, а не на стек
	mov	rdi, QWORD PTR 8[rdi]
	movsd	QWORD PTR 8[rsp], xmm0
	call	fopen@PLT
	# Файловый поток лежит в ax
	test	rax, rax
	je	.L27
	movsd	xmm0, QWORD PTR 8[rsp]
	# Сохраняем адрес на поток в di и bp
	mov	rdi, rax
	mov	rbp, rax
	lea	rsi, .LC4[rip]
	mov	eax, 1
	call	fprintf@PLT
	mov	rdi, rbp
	call	fclose@PLT
	xor	eax, eax
.L25:
	add	rsp, 16
	pop	rbp
	ret
.L27:
	mov	eax, 2
	jmp	.L25
	.size	noteRandomInput, .-noteRandomInput
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC1:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.section	.rodata.cst8
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
	.long	2097152
	.long	1041235968
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
