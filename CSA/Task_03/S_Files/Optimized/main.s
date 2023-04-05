	.file	"main.c"
	.intel_syntax noprefix
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Wrong number of arguments!"
.LC1:
	.string	"Wrong input!"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC2:
	.string	"The file doesn't exist or couldn't be read!"
	.section	.rodata.str1.1
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
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
	endbr64
	push	r14
	push	r13
	push	r12
	push	rbp
	# Записываем второй аргумент (argv) в rbp, не на стек
	mov	rbp, rsi
	push	rbx
	# Записываем первый аргумент (argc) в ebx, не на стек
	mov	ebx, edi
	xor	edi, edi
	sub	rsp, 64
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 56[rsp], rax

	xor	eax, eax
	call	time@PLT
	mov	edi, eax
	call	srand@PLT
	cmp	ebx, 2
	je	.L14
	cmp	ebx, 4
	jg	.L14
	call	clock@PLT
	# Сохраняем start_read в r13, а не на стеке
	mov	r13, rax
	cmp	ebx, 1
	je	.L20
	cmp	ebx, 3
	je	.L21
	xor	eax, eax
	call	random_arg@PLT
	# Полученное значение хранится в xmm0, сохраняем его на стек
	mov	rdi, rbp
	movsd	QWORD PTR 48[rsp], xmm0
	call	noteRandomInput@PLT
	# Результат записываем в r12d, а не на стек
	mov	r12d, eax
.L6:
	cmp	r12d, 1
	je	.L22
	cmp	r12d, 2
	je	.L23
	call	clock@PLT
	sub	rax, r13
	# end_read записываем в r14, а не на стек
	mov	r14, rax
	call	clock@PLT
	movsd	xmm0, QWORD PTR 48[rsp]
	lea	rdi, 44[rsp]
	mov	DWORD PTR 44[rsp], 0
	# start_calc записываем в r12, а не на стек
	mov	r12, rax
	call	func@PLT
	# Записываем результат на стек
	movsd	QWORD PTR 8[rsp], xmm0
	call	clock@PLT
	# Результат записан в ax
	# Вычитаем start_calc
	sub	rax, r12
	# Записываем результат в r13, а не на стек (end_calc)
	mov	r13, rax
	call	clock@PLT
	sub	ebx, 1
	movsd	xmm0, QWORD PTR 8[rsp]
	# Записываем start_write в r12, а не на стек
	mov	r12, rax
	je	.L24
	mov	edi, DWORD PTR 44[rsp]
	mov	rsi, rbp
	call	fileOutput@PLT
	test	eax, eax
	jne	.L25
.L11:
	call	clock@PLT
	# Не сохраняем end_write на стеке
	pxor	xmm2, xmm2
	pxor	xmm1, xmm1
	movsd	xmm0, QWORD PTR .LC4[rip]
	cvtsi2sd	xmm2, r13
	# В rax записан end_write
	sub	rax, r12
	xor	r12d, r12d
	mov	edi, 1
	cvtsi2sd	xmm1, r14
	lea	rsi, .LC5[rip]
	divsd	xmm2, xmm0
	divsd	xmm1, xmm0
	# Записываем time_calcна стек
	movsd	QWORD PTR 8[rsp], xmm2
	pxor	xmm2, xmm2
	cvtsi2sd	xmm2, rax
	mov	eax, 1
	divsd	xmm2, xmm0
	movapd	xmm0, xmm1
	# Записываем time_read
	movsd	QWORD PTR 24[rsp], xmm1
	# Записываем time_write
	movsd	QWORD PTR 16[rsp], xmm2
	call	__printf_chk@PLT
	movsd	xmm0, QWORD PTR 8[rsp]
	mov	edi, 1
	lea	rsi, .LC6[rip]
	mov	eax, 1
	call	__printf_chk@PLT
	movsd	xmm0, QWORD PTR 16[rsp]
	mov	edi, 1
	lea	rsi, .LC7[rip]
	mov	eax, 1
	call	__printf_chk@PLT
	movsd	xmm1, QWORD PTR 24[rsp]
	addsd	xmm1, QWORD PTR 8[rsp]
	lea	rsi, .LC8[rip]
	movsd	xmm0, QWORD PTR 16[rsp]
	mov	edi, 1
	mov	eax, 1
	addsd	xmm0, xmm1
	call	__printf_chk@PLT
.L1:
	mov	rax, QWORD PTR 56[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L26
	add	rsp, 64
	mov	eax, r12d
	pop	rbx
	pop	rbp
	pop	r12
	pop	r13
	pop	r14
	ret
.L14:
	lea	rdi, .LC0[rip]
	mov	r12d, 1
	call	puts@PLT
	jmp	.L1
.L21:
	lea	rdi, 48[rsp]
	mov	rsi, rbp
	call	fileInput@PLT
	mov	r12d, eax
	jmp	.L6
.L24:
	mov	edi, DWORD PTR 44[rsp]
	call	consoleOutput@PLT
	jmp	.L11
.L20:
	lea	rdi, 48[rsp]
	call	consoleInput@PLT
	mov	r12d, eax
	jmp	.L6
.L23:
	lea	rdi, .LC2[rip]
	call	puts@PLT
	jmp	.L1
.L25:
	lea	rdi, .LC3[rip]
	call	puts@PLT
	jmp	.L11
.L22:
	lea	rdi, .LC1[rip]
	call	puts@PLT
	jmp	.L1
.L26:
	call	__stack_chk_fail@PLT
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
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
