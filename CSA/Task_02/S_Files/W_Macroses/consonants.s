	.file	"consonants.c"
	.intel_syntax noprefix
	.text
	.globl	is_consonant
	.type	is_consonant, @function
is_consonant:
.LFB0:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 96
	mov	eax, edi
	mov	BYTE PTR -84[rbp], al
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	movabs	rax, 5063263485548451665
	movabs	rdx, 4852727882218883143
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	movabs	rax, 8390900384256639574
	movabs	rdx, 7740113702898398064
	mov	QWORD PTR -48[rbp], rax
	mov	QWORD PTR -40[rbp], rdx
	movabs	rax, 7885348258186820204
	mov	QWORD PTR -32[rbp], rax
	mov	BYTE PTR -24[rbp], 0
	mov	DWORD PTR -68[rbp], 0
	jmp	.L2
.L5:
	mov	eax, DWORD PTR -68[rbp]
	cdqe
	movzx	eax, BYTE PTR -64[rbp+rax]
	cmp	BYTE PTR -84[rbp], al
	jne	.L3
	mov	eax, 1
	jmp	.L6
.L3:
	add	DWORD PTR -68[rbp], 1
.L2:
	cmp	DWORD PTR -68[rbp], 39
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
	.size	is_consonant, .-is_consonant
	.globl	count_consonants
	.type	count_consonants, @function
count_consonants:
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
	call	is_consonant
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
	.size	count_consonants, .-count_consonants
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
