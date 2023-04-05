	.file	"consonants.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	is_consonant
	.type	is_consonant, @function
is_consonant:
	endbr64
	sub	rsp, 72
	movdqa	xmm0, XMMWORD PTR .LC0[rip]
	mov	edx, 81
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 56[rsp], rax
	xor	eax, eax
	lea	rcx, 40[rsp]
	mov	BYTE PTR 40[rsp], 0
	movabs	rax, 7885348258186820204
	movaps	XMMWORD PTR [rsp], xmm0
	movdqa	xmm0, XMMWORD PTR .LC1[rip]
	mov	QWORD PTR 32[rsp], rax
	lea	rax, 1[rsp]
	movaps	XMMWORD PTR 16[rsp], xmm0
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L9:
	cmp	rax, rcx
	je	.L6
	movzx	edx, BYTE PTR [rax]
	add	rax, 1
.L3:
	cmp	dil, dl
	jne	.L9
	mov	eax, 1
.L1:
	mov	rdx, QWORD PTR 56[rsp]
	sub	rdx, QWORD PTR fs:40
	jne	.L10
	add	rsp, 72
	ret
	.p2align 4,,10
	.p2align 3
.L6:
	xor	eax, eax
	jmp	.L1
.L10:
	call	__stack_chk_fail@PLT
	.size	is_consonant, .-is_consonant
	.p2align 4
	.globl	count_consonants
	.type	count_consonants, @function
count_consonants:
	endbr64
	push	r12
	push	rbp
	push	rbx
	sub	rsp, 64
	movzx	ecx, BYTE PTR [rdi]
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 56[rsp], rax
	xor	eax, eax
	cmp	cl, -1
	je	.L18
	add	rdi, 1
	xor	r12d, r12d
	lea	rbp, 1[rsp]
	movabs	r10, 5063263485548451665
	movabs	r11, 4852727882218883143
	lea	rsi, 40[rsp]
	movabs	r8, 8390900384256639574
	movabs	r9, 7740113702898398064
	movabs	rbx, 7885348258186820204
	.p2align 4,,10
	.p2align 3
.L16:
	mov	QWORD PTR [rsp], r10
	mov	rax, rbp
	mov	edx, 81
	mov	QWORD PTR 8[rsp], r11
	mov	QWORD PTR 16[rsp], r8
	mov	QWORD PTR 24[rsp], r9
	mov	QWORD PTR 32[rsp], rbx
	mov	BYTE PTR 40[rsp], 0
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L21:
	cmp	rsi, rax
	je	.L14
	movzx	edx, BYTE PTR [rax]
	add	rax, 1
.L15:
	cmp	dl, cl
	jne	.L21
	add	r12d, 1
.L14:
	movzx	ecx, BYTE PTR [rdi]
	add	rdi, 1
	cmp	cl, -1
	jne	.L16
.L11:
	mov	rax, QWORD PTR 56[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L22
	add	rsp, 64
	mov	eax, r12d
	pop	rbx
	pop	rbp
	pop	r12
	ret
.L18:
	xor	r12d, r12d
	jmp	.L11
.L22:
	call	__stack_chk_fail@PLT
	.size	count_consonants, .-count_consonants
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.quad	5063263485548451665
	.quad	4852727882218883143
	.align 16
.LC1:
	.quad	8390900384256639574
	.quad	7740113702898398064
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
