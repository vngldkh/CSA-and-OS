	.file	"vowels.c"
	.intel_syntax noprefix
	.text
	.globl	is_vowel
	.type	is_vowel, @function
is_vowel:
.LFB0:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 48
	mov	eax, edi
	mov	BYTE PTR -36[rbp], al
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	movabs	rax, 8747469660025608517
	mov	QWORD PTR -21[rbp], rax
	mov	DWORD PTR -13[rbp], 1634691445
	mov	BYTE PTR -9[rbp], 0
	mov	DWORD PTR -28[rbp], 0
	jmp	.L2
.L5:
	mov	eax, DWORD PTR -28[rbp]
	cdqe
	movzx	eax, BYTE PTR -21[rbp+rax]
	cmp	BYTE PTR -36[rbp], al
	jne	.L3
	mov	eax, 1
	jmp	.L6
.L3:
	add	DWORD PTR -28[rbp], 1
.L2:
	cmp	DWORD PTR -28[rbp], 11
	jle	.L5
	mov	eax, 0
.L6:
	mov	rdx, QWORD PTR -8[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L7
	call	__stack_chk_fail@PLT
.L7:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	is_vowel, .-is_vowel
	.globl	count_vowels
	.type	count_vowels, @function
count_vowels:
.LFB1:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR -24[rbp], rdi
	mov	DWORD PTR -8[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	jmp	.L9
.L11:
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	mov	edi, eax
	call	is_vowel
	test	al, al
	je	.L10
	add	DWORD PTR -8[rbp], 1
.L10:
	add	DWORD PTR -4[rbp], 1
.L9:
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	cmp	al, -1
	jne	.L11
	mov	eax, DWORD PTR -8[rbp]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
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
