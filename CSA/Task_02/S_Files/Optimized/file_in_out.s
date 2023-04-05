	.file	"file_in_out.c"
	.intel_syntax noprefix
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"w"
	.text
	.p2align 4
	.globl	note_random_input
	.type	note_random_input, @function
note_random_input:
	endbr64
	push	rbp
	push	rbx
	mov	rbx, rdi
	sub	rsp, 8
	mov	rdi, QWORD PTR 8[rsi]
	lea	rsi, .LC0[rip]
	call	fopen@PLT
	test	rax, rax
	je	.L5
	movsx	edi, BYTE PTR [rbx]
	mov	rbp, rax
	cmp	dil, -1
	je	.L3
	add	rbx, 1
	.p2align 4,,10
	.p2align 3
.L4:
	mov	rsi, rbp
	add	rbx, 1
	call	fputc@PLT
	movsx	edi, BYTE PTR -1[rbx]
	cmp	dil, -1
	jne	.L4
.L3:
	mov	rdi, rbp
	call	fclose@PLT
	xor	eax, eax
.L1:
	add	rsp, 8
	pop	rbx
	pop	rbp
	ret
.L5:
	mov	eax, 2
	jmp	.L1
	.size	note_random_input, .-note_random_input
	.p2align 4
	.globl	random_input
	.type	random_input, @function
random_input:
	endbr64
	mov	rax, QWORD PTR 24[rsi]
	movzx	eax, BYTE PTR [rax]
	sub	eax, 48
	cmp	al, 1
	jbe	.L24
	mov	eax, 1
	ret
	.p2align 4,,10
	.p2align 3
.L24:
	push	r13
	push	r12
	mov	r12, rdi
	push	rbp
	mov	rbp, rsi
	push	rbx
	sub	rsp, 8
	call	rand@PLT
	movsx	rdx, eax
	mov	ecx, eax
	imul	rdx, rdx, 1098413215
	sar	ecx, 31
	sar	rdx, 40
	sub	edx, ecx
	imul	ecx, edx, 1001
	sub	eax, ecx
	mov	edx, eax
	cdqe
	mov	BYTE PTR [r12+rax], -1
	mov	rax, QWORD PTR 24[rbp]
	cmp	BYTE PTR [rax], 48
	je	.L14
	test	edx, edx
	jle	.L16
	lea	eax, -1[rdx]
	mov	r13, r12
	lea	rbx, 1[r12+rax]
	.p2align 4,,10
	.p2align 3
.L18:
	call	rand@PLT
	add	r13, 1
	movsx	rdx, eax
	mov	ecx, eax
	imul	rdx, rdx, -2130574327
	sar	ecx, 31
	shr	rdx, 32
	add	edx, eax
	sar	edx, 6
	sub	edx, ecx
	mov	ecx, edx
	sal	ecx, 7
	sub	ecx, edx
	sub	eax, ecx
	add	eax, 48
	mov	BYTE PTR -1[r13], al
	cmp	r13, rbx
	jne	.L18
.L16:
	add	rsp, 8
	mov	rsi, rbp
	mov	rdi, r12
	pop	rbx
	pop	rbp
	pop	r12
	pop	r13
	jmp	note_random_input
	.p2align 4,,10
	.p2align 3
.L14:
	test	edx, edx
	jle	.L16
	lea	eax, -1[rdx]
	mov	r13, r12
	lea	rbx, 1[r12+rax]
	.p2align 4,,10
	.p2align 3
.L17:
	call	rand@PLT
	add	r13, 1
	movsx	rdx, eax
	mov	ecx, eax
	imul	rdx, rdx, 1321528399
	sar	ecx, 31
	sar	rdx, 35
	sub	edx, ecx
	imul	edx, edx, 26
	sub	eax, edx
	add	eax, 65
	mov	BYTE PTR -1[r13], al
	cmp	r13, rbx
	jne	.L17
	jmp	.L16
	.size	random_input, .-random_input
	.section	.rodata.str1.1
.LC1:
	.string	"r"
	.text
	.p2align 4
	.globl	file_input
	.type	file_input, @function
file_input:
	endbr64
	push	r12
	push	rbp
	mov	rbp, rdi
	push	rbx
	mov	rdi, QWORD PTR 8[rsi]
	lea	rsi, .LC1[rip]
	call	fopen@PLT
	test	rax, rax
	je	.L29
	mov	r12, rax
	mov	ebx, 1
	.p2align 4,,10
	.p2align 3
.L27:
	mov	rdi, r12
	call	fgetc@PLT
	mov	ecx, ebx
	cmp	al, -1
	mov	BYTE PTR -1[rbp+rbx], al
	setne	dl
	cmp	ebx, 999
	setle	al
	add	rbx, 1
	test	dl, al
	jne	.L27
	cmp	ecx, 1000
	jne	.L28
	mov	BYTE PTR 1000[rbp], -1
.L28:
	mov	rdi, r12
	call	fclose@PLT
	xor	eax, eax
.L25:
	pop	rbx
	pop	rbp
	pop	r12
	ret
.L29:
	mov	eax, 2
	jmp	.L25
	.size	file_input, .-file_input
	.section	.rodata.str1.1
.LC2:
	.string	"Count of vowels - %d\n"
.LC3:
	.string	"Count of consonants - %d\n"
	.text
	.p2align 4
	.globl	file_output
	.type	file_output, @function
file_output:
	endbr64
	push	r13
	mov	r13d, edi
	push	r12
	mov	r12d, esi
	lea	rsi, .LC0[rip]
	push	rbp
	mov	rdi, QWORD PTR 16[rdx]
	call	fopen@PLT
	test	rax, rax
	je	.L34
	mov	rdi, rax
	mov	rbp, rax
	mov	ecx, r13d
	mov	esi, 1
	lea	rdx, .LC2[rip]
	xor	eax, eax
	call	__fprintf_chk@PLT
	mov	ecx, r12d
	mov	esi, 1
	mov	rdi, rbp
	lea	rdx, .LC3[rip]
	xor	eax, eax
	call	__fprintf_chk@PLT
	xor	eax, eax
.L32:
	pop	rbp
	pop	r12
	pop	r13
	ret
.L34:
	mov	eax, 1
	jmp	.L32
	.size	file_output, .-file_output
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
