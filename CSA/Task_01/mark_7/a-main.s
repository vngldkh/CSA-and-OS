	.file	"main.c"
	.text
	.section	.rodata
.LC0:
	.string	"Wrong number of arguments!"
.LC1:
	.string	"Wrong size!"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$200, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movl	%edi, -132(%rbp)
	movq	%rsi, -144(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	cmpl	$1, -132(%rbp)
	je	.L2
	cmpl	$3, -132(%rbp)
	je	.L2
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %eax
	jmp	.L3
.L2:
	cmpl	$1, -132(%rbp)
	jne	.L4
	movq	%rsp, %rax
	movq	%rax, %rbx
	movl	$0, %eax
	call	getLength@PLT
	movl	%eax, -128(%rbp)
	movl	-128(%rbp), %edx
	movslq	%edx, %rax
	subq	$1, %rax
	movq	%rax, -120(%rbp)
	movslq	%edx, %rax
	movq	%rax, %r12
	movl	$0, %r13d
	movslq	%edx, %rax
	movq	%rax, %r14
	movl	$0, %r15d
	movslq	%edx, %rax
	leaq	0(,%rax,8), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %esi
	movl	$0, %edx
	divq	%rsi
	imulq	$16, %rax, %rdx
	movq	%rdx, %rax
	andq	$-4096, %rax
	movq	%rsp, %rcx
	subq	%rax, %rcx
.L5:
	cmpq	%rcx, %rsp
	je	.L6
	subq	$4096, %rsp
	orq	$0, 4088(%rsp)
	jmp	.L5
.L6:
	movq	%rdx, %rax
	andl	$4095, %eax
	subq	%rax, %rsp
	movq	%rdx, %rax
	andl	$4095, %eax
	testq	%rax, %rax
	je	.L7
	movq	%rdx, %rax
	andl	$4095, %eax
	subq	$8, %rax
	addq	%rsp, %rax
	orq	$0, (%rax)
.L7:
	movq	%rsp, %rax
	addq	$7, %rax
	shrq	$3, %rax
	salq	$3, %rax
	movq	%rax, -112(%rbp)
	movl	-128(%rbp), %edx
	movslq	%edx, %rax
	subq	$1, %rax
	movq	%rax, -104(%rbp)
	movslq	%edx, %rax
	movq	%rax, -160(%rbp)
	movq	$0, -152(%rbp)
	movslq	%edx, %rax
	movq	%rax, -176(%rbp)
	movq	$0, -168(%rbp)
	movslq	%edx, %rax
	leaq	0(,%rax,8), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %edi
	movl	$0, %edx
	divq	%rdi
	imulq	$16, %rax, %rax
	movq	%rax, %rcx
	andq	$-4096, %rcx
	movq	%rsp, %rdx
	subq	%rcx, %rdx
.L8:
	cmpq	%rdx, %rsp
	je	.L9
	subq	$4096, %rsp
	orq	$0, 4088(%rsp)
	jmp	.L8
.L9:
	movq	%rax, %rdx
	andl	$4095, %edx
	subq	%rdx, %rsp
	movq	%rax, %rdx
	andl	$4095, %edx
	testq	%rdx, %rdx
	je	.L10
	andl	$4095, %eax
	subq	$8, %rax
	addq	%rsp, %rax
	orq	$0, (%rax)
.L10:
	movq	%rsp, %rax
	addq	$7, %rax
	shrq	$3, %rax
	salq	$3, %rax
	movq	%rax, -96(%rbp)
	movl	-128(%rbp), %edx
	movq	-112(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	inputA@PLT
	movl	-128(%rbp), %edx
	movq	-96(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	makeB@PLT
	movl	-128(%rbp), %edx
	movq	-96(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	print@PLT
	movq	%rbx, %rsp
.L4:
	cmpl	$3, -132(%rbp)
	jne	.L11
	movq	%rsp, %rax
	movq	%rax, %rbx
	movq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	fileGetSize@PLT
	movl	%eax, -124(%rbp)
	cmpl	$0, -124(%rbp)
	jg	.L12
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %eax
	movq	%rbx, %rsp
	jmp	.L3
.L12:
	movl	-124(%rbp), %eax
	movslq	%eax, %rdx
	subq	$1, %rdx
	movq	%rdx, -88(%rbp)
	movslq	%eax, %rdx
	movq	%rdx, -192(%rbp)
	movq	$0, -184(%rbp)
	movslq	%eax, %rdx
	movq	%rdx, -208(%rbp)
	movq	$0, -200(%rbp)
	cltq
	leaq	0(,%rax,8), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %esi
	movl	$0, %edx
	divq	%rsi
	imulq	$16, %rax, %rax
	movq	%rax, %rcx
	andq	$-4096, %rcx
	movq	%rsp, %rdx
	subq	%rcx, %rdx
.L13:
	cmpq	%rdx, %rsp
	je	.L14
	subq	$4096, %rsp
	orq	$0, 4088(%rsp)
	jmp	.L13
.L14:
	movq	%rax, %rdx
	andl	$4095, %edx
	subq	%rdx, %rsp
	movq	%rax, %rdx
	andl	$4095, %edx
	testq	%rdx, %rdx
	je	.L15
	andl	$4095, %eax
	subq	$8, %rax
	addq	%rsp, %rax
	orq	$0, (%rax)
.L15:
	movq	%rsp, %rax
	addq	$7, %rax
	shrq	$3, %rax
	salq	$3, %rax
	movq	%rax, -80(%rbp)
	movl	-124(%rbp), %eax
	movslq	%eax, %rdx
	subq	$1, %rdx
	movq	%rdx, -72(%rbp)
	movslq	%eax, %rdx
	movq	%rdx, -224(%rbp)
	movq	$0, -216(%rbp)
	movslq	%eax, %rdx
	movq	%rdx, -240(%rbp)
	movq	$0, -232(%rbp)
	cltq
	leaq	0(,%rax,8), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %edi
	movl	$0, %edx
	divq	%rdi
	imulq	$16, %rax, %rax
	movq	%rax, %rcx
	andq	$-4096, %rcx
	movq	%rsp, %rdx
	subq	%rcx, %rdx
.L16:
	cmpq	%rdx, %rsp
	je	.L17
	subq	$4096, %rsp
	orq	$0, 4088(%rsp)
	jmp	.L16
.L17:
	movq	%rax, %rdx
	andl	$4095, %edx
	subq	%rdx, %rsp
	movq	%rax, %rdx
	andl	$4095, %edx
	testq	%rdx, %rdx
	je	.L18
	andl	$4095, %eax
	subq	$8, %rax
	addq	%rsp, %rax
	orq	$0, (%rax)
.L18:
	movq	%rsp, %rax
	addq	$7, %rax
	shrq	$3, %rax
	salq	$3, %rax
	movq	%rax, -64(%rbp)
	movl	-124(%rbp), %edx
	movq	-80(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fileInputA@PLT
	movl	-124(%rbp), %edx
	movq	-64(%rbp), %rcx
	movq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	makeB@PLT
	movl	-124(%rbp), %ecx
	movq	-64(%rbp), %rdx
	movq	-80(%rbp), %rsi
	movq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	fileOutput@PLT
	movq	%rbx, %rsp
.L11:
	movl	$0, %eax
.L3:
	movq	-56(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L19
	call	__stack_chk_fail@PLT
.L19:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
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
