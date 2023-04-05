	.file	"vowels.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	is_vowel
	.type	is_vowel, @function
is_vowel:
	endbr64
	sub	rsp, 40
	mov	edx, 69
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 24[rsp], rax
	movabs	rax, 8747469660025608517
	lea	rcx, 23[rsp]
	mov	DWORD PTR 19[rsp], 1634691445
	mov	BYTE PTR 23[rsp], 0
	mov	QWORD PTR 11[rsp], rax
	lea	rax, 12[rsp]
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L9:
	# В edx мы храним vowels[i]
	# i хранится не на стеке (DWORD PTR -28[rbp]), а в регистре ax
	# letter не сохраняется на стеке (BYTE PTR -36[rbp]), а продолжает храниться в регистре di
	movzx	edx, BYTE PTR [rax]
	add	rax, 1
.L3:
	cmp	dil, dl
	je	.L5
	cmp	rax, rcx
	jne	.L9
	xor	eax, eax
.L1:
	mov	rdx, QWORD PTR 24[rsp]
	sub	rdx, QWORD PTR fs:40
	jne	.L10
	add	rsp, 40
	ret
	.p2align 4,,10
	.p2align 3
.L5:
	mov	eax, 1
	jmp	.L1
.L10:
	call	__stack_chk_fail@PLT
	.size	is_vowel, .-is_vowel
	.p2align 4
	.globl	count_vowels
	.type	count_vowels, @function
count_vowels:
	endbr64
	sub	rsp, 40
	# Текущий символ лежит в cx
	movzx	ecx, BYTE PTR [rdi]
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 24[rsp], rax
	xor	eax, eax
	cmp	cl, -1
	je	.L18
	add	rdi, 1
	xor	r8d, r8d
	lea	r10, 12[rsp]
	movabs	r9, 8747469660025608517
	lea	rsi, 23[rsp]
	.p2align 4,,10
	.p2align 3
.L16:
	mov	QWORD PTR 11[rsp], r9
	mov	rax, r10
	mov	edx, 69
	mov	DWORD PTR 19[rsp], 1634691445
	mov	BYTE PTR 23[rsp], 0
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L21:
	# i хранится не на стеке (WORD PTR -28[rbp]), а в ax
	movzx	edx, BYTE PTR [rax]
	add	rax, 1
.L15:
	# 
	cmp	cl, dl
	je	.L13
	cmp	rax, rsi
	jne	.L21
	movzx	ecx, BYTE PTR [rdi]
	add	rdi, 1
	cmp	cl, -1
	jne	.L16
.L11:
	mov	rax, QWORD PTR 24[rsp]
	sub	rax, QWORD PTR fs:40
	jne	.L22
	mov	eax, r8d
	add	rsp, 40
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	movzx	ecx, BYTE PTR [rdi]
	add	rdi, 1
	add	r8d, 1
	cmp	cl, -1
	jne	.L16
	jmp	.L11
.L18:
	xor	r8d, r8d
	jmp	.L11
.L22:
	call	__stack_chk_fail@PLT
	.size	count_vowels, .-count_vowels
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
