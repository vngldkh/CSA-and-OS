	.file	"console_in_out.c"
	.intel_syntax noprefix
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"Write your string (it must not be longer than 1000 symbols).\nTo stop writing press CTRL+D twice!"
	.text
	.p2align 4
	.globl	console_input
	.type	console_input, @function
console_input:
	endbr64
	push	rbp
	# str[] - первый входной парматер, хранится в rdi
	# Сохраняем его не на стек, а в rbp
	mov	rbp, rdi
	lea	rdi, .LC0[rip]
	push	rbx
	mov	ebx, 1
	sub	rsp, 8
	call	puts@PLT
	.p2align 4,,10
	.p2align 3
.L2:
	mov	rdi, QWORD PTR stdin[rip]
	call	getc@PLT
	mov	ecx, ebx
	cmp	al, -1
	# i храним в rbx, а не на стеке DWORD PTR -4[rbp]
	mov	BYTE PTR -1[rbp+rbx], al
	setne	dl
	cmp	ebx, 999
	setle	al
	add	rbx, 1
	test	dl, al
	jne	.L2
	cmp	ecx, 1000
	jne	.L3
	mov	BYTE PTR 1000[rbp], 0
.L3:
	add	rsp, 8
	xor	eax, eax
	pop	rbx
	pop	rbp
	ret
	.size	console_input, .-console_input
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"\nCount of vowels - %d\n"
.LC2:
	.string	"Count of consonants - %d\n"
	.text
	.p2align 4
	.globl	console_output
	.type	console_output, @function
console_output:
	# Не сохраняем параметры на стеке
	endbr64
	push	r12
	# Сохраняем vowels в dx - третий аргумент
	mov	edx, edi
	# Consonants сохраняем в регистре r12d
	mov	r12d, esi
	mov	edi, 1
	lea	rsi, .LC1[rip]
	xor	eax, eax
	call	__printf_chk@PLT
	# vowels больше не нужно, dx освобождается, записываем туда consonants
	mov	edx, r12d
	mov	edi, 1
	xor	eax, eax
	lea	rsi, .LC2[rip]
	pop	r12
	jmp	__printf_chk@PLT
	.size	console_output, .-console_output
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
