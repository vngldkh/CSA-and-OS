	.file	"consonants.c"
	.intel_syntax noprefix
	.text
	.globl	is_consonant
	.type	is_consonant, @function
is_consonant:
.LFB0:
	# Подготовительные действия
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 96
	# В di хранится первый аргумент - char letter
	mov	eax, edi
	# Сохраняем letter на стеке
	mov	BYTE PTR -84[rbp], al
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	# char consonants[] = "QWRTPSDFGHJKLZXCVBNMqwrtpsdfghjklzxcvbnm";
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

	# Инициализируем i
	mov	DWORD PTR -68[rbp], 0
	# Переходим к сравнению в цикле
	jmp	.L2
.L5:
	# Записываем i в ax
	mov	eax, DWORD PTR -68[rbp]
	cdqe
	# Записываем в ax consonats[i]
	movzx	eax, BYTE PTR -64[rbp+rax]
	# Сравниваем letter с consonats[i]
	cmp	BYTE PTR -84[rbp], al
	# Если !=, переходим к следующей итерации цикла
	jne	.L3
	# Иначе - возвращаем true (1)
	mov	eax, 1
	# Переходим к выходу из функции
	jmp	.L6
.L3:
	# ++i
	add	DWORD PTR -68[rbp], 1
.L2:
	# Сравниваем i с 39
	cmp	DWORD PTR -68[rbp], 39
	# Если <= 39, переходим в тело
	jle	.L5

	# Если выходим из цикла, возвращаем false (0)
	mov	eax, 0
.L6:
	# Проверяем, что было освобождено столько же памяти, сколько и выделено
	mov	rdx, QWORD PTR -8[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L7
	call	__stack_chk_fail@PLT
.L7:
	# Выходим из функции
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
	# Подготовительные действия
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	# Сохраняем str[], первый аргумент, на стеке
	mov	QWORD PTR -24[rbp], rdi
	# Инициализируем count
	mov	DWORD PTR -8[rbp], 0
	# Инициализируем i
	mov	DWORD PTR -4[rbp], 0
	# Переходим к сравнению в цикле
	jmp	.L9
.L11:
	# Записываем i в dx
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	# Получаем указатель на начало str[]
	mov	rax, QWORD PTR -24[rbp]
	# Сдвигаем
	add	rax, rdx
	# Записываем str[i] в eax
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	# Записываем str[i] в di - первый аргумент
	mov	edi, eax
	# Вызываем is_consonat
	call	is_consonant
	# Возвращенное значение лежит в ax
	# Сравниваем его с 0
	test	al, al
	# Если == 0, сразу переходим к следующей итерации
	je	.L10
	# Иначе - увеличиваем счётчик count прежде
	add	DWORD PTR -8[rbp], 1
.L10:
	# ++i
	add	DWORD PTR -4[rbp], 1
.L9:
	# Записываем i в dx
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	# Получаем указатель на начало str[]
	mov	rax, QWORD PTR -24[rbp]
	# Сдвигаем
	add	rax, rdx
	# Записываем str[i] в eax
	movzx	eax, BYTE PTR [rax]
	# Сравниваем с EOF
	cmp	al, -1
	# Если !=, переходим в тело цикла
	jne	.L11

	# Иначе - записываем возвращаемое значение (count) в ax
	mov	eax, DWORD PTR -8[rbp]
	# Выходим из функции
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
