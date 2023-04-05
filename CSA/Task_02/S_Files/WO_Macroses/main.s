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
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 1136
	mov	DWORD PTR -1124[rbp], edi
	mov	QWORD PTR -1136[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	cmp	DWORD PTR -1124[rbp], 2
	je	.L2
	cmp	DWORD PTR -1124[rbp], 4
	jle	.L3
.L2:
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 1
	jmp	.L12
.L3:
	call	clock@PLT
	mov	QWORD PTR -1104[rbp], rax
	cmp	DWORD PTR -1124[rbp], 1
	jne	.L5
	lea	rax, -1024[rbp]
	mov	rdi, rax
	call	console_input@PLT
	mov	DWORD PTR -1116[rbp], eax
	jmp	.L6
.L5:
	cmp	DWORD PTR -1124[rbp], 3
	jne	.L7
	mov	rdx, QWORD PTR -1136[rbp]
	lea	rax, -1024[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	file_input@PLT
	mov	DWORD PTR -1116[rbp], eax
	jmp	.L6
.L7:
	mov	rdx, QWORD PTR -1136[rbp]
	lea	rax, -1024[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	random_input@PLT
	mov	DWORD PTR -1116[rbp], eax
.L6:
	cmp	DWORD PTR -1116[rbp], 1
	jne	.L8
	lea	rax, .LC1[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 1
	jmp	.L12
.L8:
	cmp	DWORD PTR -1116[rbp], 2
	jne	.L9
	lea	rax, .LC2[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 2
	jmp	.L12
.L9:
	call	clock@PLT
	sub	rax, QWORD PTR -1104[rbp]
	mov	QWORD PTR -1096[rbp], rax
	call	clock@PLT
	mov	QWORD PTR -1088[rbp], rax
	lea	rax, -1024[rbp]
	mov	rdi, rax
	call	count_vowels@PLT
	mov	DWORD PTR -1112[rbp], eax
	lea	rax, -1024[rbp]
	mov	rdi, rax
	call	count_consonants@PLT
	mov	DWORD PTR -1108[rbp], eax
	call	clock@PLT
	sub	rax, QWORD PTR -1088[rbp]
	mov	QWORD PTR -1080[rbp], rax
	call	clock@PLT
	mov	QWORD PTR -1072[rbp], rax
	cmp	DWORD PTR -1124[rbp], 1
	jne	.L10
	mov	edx, DWORD PTR -1108[rbp]
	mov	eax, DWORD PTR -1112[rbp]
	mov	esi, edx
	mov	edi, eax
	call	console_output@PLT
	jmp	.L11
.L10:
	mov	rdx, QWORD PTR -1136[rbp]
	mov	ecx, DWORD PTR -1108[rbp]
	mov	eax, DWORD PTR -1112[rbp]
	mov	esi, ecx
	mov	edi, eax
	call	file_output@PLT
	test	eax, eax
	je	.L11
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	puts@PLT
.L11:
	call	clock@PLT
	sub	rax, QWORD PTR -1072[rbp]
	mov	QWORD PTR -1064[rbp], rax
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -1096[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -1056[rbp], xmm0
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -1080[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -1048[rbp], xmm0
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, QWORD PTR -1064[rbp]
	movsd	xmm1, QWORD PTR .LC4[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -1040[rbp], xmm0
	movsd	xmm0, QWORD PTR -1056[rbp]
	addsd	xmm0, QWORD PTR -1048[rbp]
	movsd	xmm1, QWORD PTR -1040[rbp]
	addsd	xmm0, xmm1
	movsd	QWORD PTR -1032[rbp], xmm0
	mov	rax, QWORD PTR -1056[rbp]
	movq	xmm0, rax
	lea	rax, .LC5[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	mov	rax, QWORD PTR -1048[rbp]
	movq	xmm0, rax
	lea	rax, .LC6[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	mov	rax, QWORD PTR -1040[rbp]
	movq	xmm0, rax
	lea	rax, .LC7[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	mov	rax, QWORD PTR -1032[rbp]
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
