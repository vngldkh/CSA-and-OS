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
.LFB6:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	add	rsp, -128
	mov	DWORD PTR -116[rbp], edi
	mov	QWORD PTR -128[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	mov	edi, 0
	call	time@PLT
	mov	edi, eax
	call	srand@PLT
	cmp	DWORD PTR -116[rbp], 2
	je	.L2
	cmp	DWORD PTR -116[rbp], 4
	jle	.L3
.L2:
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 1
	jmp	.L12
.L3:
	call	clock@PLT
	mov	QWORD PTR -96[rbp], rax
	cmp	DWORD PTR -116[rbp], 1
	jne	.L5
	lea	rax, -104[rbp]
	mov	rdi, rax
	call	consoleInput@PLT
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
	cmp	DWORD PTR -108[rbp], 1
	jne	.L8
	lea	rax, .LC1[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 1
	jmp	.L12
.L8:
	cmp	DWORD PTR -108[rbp], 2
	jne	.L9
	lea	rax, .LC2[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 2
	jmp	.L12
.L9:
	call	clock@PLT
	sub	rax, QWORD PTR -96[rbp]
	mov	QWORD PTR -88[rbp], rax
	call	clock@PLT
	mov	QWORD PTR -80[rbp], rax
	mov	DWORD PTR -112[rbp], 0
	mov	rax, QWORD PTR -104[rbp]
	lea	rdx, -112[rbp]
	mov	rdi, rdx
	movq	xmm0, rax
	call	func@PLT
	movq	rax, xmm0
	mov	QWORD PTR -72[rbp], rax
	call	clock@PLT
	sub	rax, QWORD PTR -80[rbp]
	mov	QWORD PTR -64[rbp], rax
	call	clock@PLT
	mov	QWORD PTR -56[rbp], rax
	cmp	DWORD PTR -116[rbp], 1
	jne	.L10
	mov	edx, DWORD PTR -112[rbp]
	mov	rax, QWORD PTR -72[rbp]
	mov	edi, edx
	movq	xmm0, rax
	call	consoleOutput@PLT
	jmp	.L11
.L10:
	mov	edx, DWORD PTR -112[rbp]
	mov	rcx, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR -72[rbp]
	mov	rsi, rcx
	mov	edi, edx
	movq	xmm0, rax
	call	fileOutput@PLT
	test	eax, eax
	je	.L11
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	puts@PLT
.L11:
	call	clock@PLT
	sub	rax, QWORD PTR -56[rbp]
	mov	QWORD PTR -48[rbp], rax
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -88[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -40[rbp], xmm0
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -64[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -32[rbp], xmm0
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -48[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -24[rbp], xmm0
	movsd	xmm0, QWORD PTR -40[rbp]
	addsd	xmm0, QWORD PTR -32[rbp]
	movsd	xmm1, QWORD PTR -24[rbp]
	addsd	xmm0, xmm1
	movsd	QWORD PTR -16[rbp], xmm0
	mov	rax, QWORD PTR -40[rbp]
	movq	xmm0, rax
	lea	rax, .LC5[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	mov	rax, QWORD PTR -32[rbp]
	movq	xmm0, rax
	lea	rax, .LC6[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	mov	rax, QWORD PTR -24[rbp]
	movq	xmm0, rax
	lea	rax, .LC7[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
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
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
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
