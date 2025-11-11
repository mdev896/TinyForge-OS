[org 0x7c00 + 512]
[bits 16]
call clear_screen
mov bx, prompt
call print

main:
	mov di, command
	main_loop:
		call get_char                   ; get char from user
		cmp al, 0x08                    ; check if backspace
		jne not_backspace
		cmp di, command
		je bs_not_allowed
		mov byte [di], 0                ; erase last command char
		dec di
		mov al, 0x20                    ; print space to clear that character on screen
		call print_char
		mov al, 0x08                    ; print backspace to move back to align position
		call print_char
		jmp main_loop
		bs_not_allowed:
		mov al, 0x20
		int 0x10
		jmp main_loop
		not_backspace:
		cmp al, 0x0d                    ; check if enter is pressed
		je new_line
		mov byte [di], al               ; if not, add char to command
		inc di
		jmp main_loop

%include "print.asm"
%include "input.asm"
%include "commandments.asm"

prompt db "!# ",0
loop_prompt db "> ",0
command:
	times 255 db 0
	db 24
variables:
	times 10 db 0
not_found db "  Command not found!",0
clear db "clear",24
user_print db "print",24
user_loop db "times",24
exit db "exit",24
cow db "cow",24
inc_text db "inc $",24
dec_text db "dec $",24
set_text db "set $",24
help db "help",24
help_text:
	db 0x0a,0x0d," clear print times exit cow help inc dec set",0x0a,0x0d,0x0a,0x0d
	db " you can access variables via typing $[1-9] ex: print $2",0x0a,0x0d
	db " variables can not exceed 256, they will just loop over",0x0a,0x0d,0 

reset_command:                               ; redefine 255 0s
	mov di, command
	reset_loop:
		mov byte [di], 0
		inc di
		cmp byte [di], 24
		jne reset_loop
	mov di, command
	ret

new_line:                                    ; checks for commands then enters new line
	cmp dh, 1
	jne no_loop_setup
	cmp dl, 0
	jne no_loop_setup
	jmp user_loop_do
	no_loop_setup:
	call print_nl
	call commands
	continue:
	cmp dh, 1
	jne no_user_loop
	cmp dl, 1
	je user_loop_process
	no_user_loop:
	mov bx, loop_prompt
	cmp dh, 1
	je skip_prompt
	mov bx, prompt
	skip_prompt:
	call print
	call reset_command
	jmp main_loop

commands:
	mov di, command
	mov si, clear              ; check "clear"
	call compare_strings
	cmp al, 1 
	je call_clear
	mov si, exit               ; check "exit"
	call compare_strings
	cmp al, 1 
	je call_exit
	mov si, cow                ; check "cow"
	call compare_strings
	cmp al, 1 
	je call_cow
	mov si, user_print         ; check if user wants to print soemthing
	call compare_strings
	cmp al, 1
	je call_user_print
	mov si, user_loop          ; times command
	call compare_strings
	cmp al, 1
	je call_user_loop
	mov si, help               ; print help text
	call compare_strings
	cmp al, 1
	je call_help
	mov si, inc_text           ; increment a variable
	call compare_strings
	cmp al, 1
	je call_inc
	mov si, dec_text           ; decrement a variable
	call compare_strings
	cmp al, 1
	je call_dec
	mov si, set_text           ; set a variable
	call compare_strings
	cmp al, 1
	je call_set
	mov bx, not_found          ; command not found
	call print
	call print_nl
	jmp continue

call_clear:
	call clear_screen
	jmp continue
call_exit:
	hlt
	jmp call_exit
call_cow:
	call print_cow
	jmp continue
call_user_print:
	mov bx, command+6
	cmp byte[bx], '$'
	je var_print
	call print
	call print_nl
	jmp continue
	var_print:
	push ax
	inc bx
	call get_variable
	call print_char
	call print_nl
	pop ax
	jmp continue
call_user_loop:
	push ax
	mov bx, command+6
	cmp byte[bx], '$'
	je var_loop
	call str_to_int
	mov cx, ax
	jmp user_loop_continue
	var_loop:
	inc bx
	call get_variable
	mov cx, ax
	user_loop_continue:
	mov dh, 1
	mov dl, 0
	pop ax
	jmp continue
call_help:
	push bx
	mov bx, help_text
	call print
	call print_nl
	pop bx
	jmp continue
call_inc:
	push ax
	mov bx, command+5
	call get_variable
	inc al
	mov byte[bx], al
	pop ax
	jmp continue
call_dec:
	push ax
	mov bx, command+5
	call get_variable
	dec al
	mov byte[bx], al
	pop ax
	jmp continue
call_set:
	push dx
	mov bx, command+5
	call get_variable
	mov dx, bx
	mov bx, command+7
	cmp byte[bx], '$'
	je set_second_var
	call str_to_int
	jmp set_continue
	set_second_var:
	inc bx
	call get_variable
	set_continue:
	mov bx, dx
	mov [bx], ax
	pop dx
	jmp continue

user_loop_do:
	mov dl, 1
	call print_nl
	user_loop_process:
		cmp cx, 0
		je user_loop_end
		dec cx
		jmp commands
	user_loop_end:
	mov dx, 0
	jmp continue