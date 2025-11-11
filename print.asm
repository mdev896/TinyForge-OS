; takes bx as argument string

print:
	pusha
	mov ah, 0x0e
	print_loop:
		mov al, [bx]
		cmp al, 0
		je _end
		int 0x10
		inc bx
		jmp print_loop
	_end:
		popa
		ret

print_nl:
	pusha
	mov ah, 0x0e
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	popa
	ret

print_char:
	pusha
	mov ah, 0x0e
	int 0x10
	popa
	ret

clear_screen:
	pusha
	mov ax, 0x03
	int 0x10
	popa
	ret

print_cow:
	mov bx, cow_part1
	mov bx, cow_part1
	call print
	call print_nl
	mov bx, cow_part2
	call print
	call print_nl
	mov bx, cow_part3
	call print
	call print_nl
	mov bx, cow_part4
	call print
	call print_nl
	mov bx, cow_part5
	call print
	call print_nl
	mov bx, cow_part6
	call print
	call print_nl
	mov bx, cow_part7
	call print
	call print_nl
	ret

cow_part1:
	db "           (    )",0
cow_part2:
	db "            (oo)",0
cow_part3:
	db "   )\.-----/(O O)",0
cow_part4:
	db "  # ;       / u",0
cow_part5:
	db "    (  .   |} )",0
cow_part6:
	db "     |/ `.;|/;",0
cow_part7:
	db '     "     " "',0