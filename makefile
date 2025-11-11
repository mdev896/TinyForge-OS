all:
	nasm -f bin main.asm -o main.bin
	nasm -f bin boot.asm -o boot.bin
	cat boot.bin main.bin > boot.img
	rm boot.bin main.bin
	qemu-system-x86_64 -drive file=boot.img,format=raw