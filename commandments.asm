; gets di and si as strings, returns al 0x01 for true 0x00 for false

compare_strings:
	push es
	push bx
	mov es, si
	mov bx, di
	compare_loop:
		mov al, [si]
		cmp al, 24
		je are_equal
		cmp al, [di]
		jne not_equal
		inc si
		inc di
		jmp compare_loop
	not_equal:
		cmp byte [di], 0
		je compare_end
		mov al, 0
		jmp compare_end
	are_equal:
		mov al, 1
		cmp byte[di-1], '$'
		je compare_end 
		cmp byte [di], " "
		jne not_equal
		jmp compare_end
	compare_end:
		mov si, es
		mov di, bx
		pop bx
		pop es
		ret

; takes bx as argument to where the string of numbers start. returns ax as a number
str_to_int:
	push dx
	xor ax, ax
	count_loop:
		movzx dx, byte[bx]
		cmp dl, 0
		je count_finished
		sub dl, '0'
		imul ax, 10
		add ax, dx
		inc bx
		jmp count_loop
	count_finished:
	pop dx
	ret

; gets bx as to where the variable string starts, makes ax value of the variable
; then it leaves bx as where the current variable resides
get_variable:
	xor ax, ax
	mov al, byte[bx]
	sub al, '0'
	mov bx, variables
	add bx, ax
	dec bx
	mov al, byte[bx]
	ret