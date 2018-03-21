bootdisk=disk.img
blocksize=512
disksize=100

boot1=boot1

# preencha esses valores para rodar o segundo estágio do bootloader
boot2=boot2
boot2pos=1
boot2size=1


ASMFLAGS=-f bin
file = $(bootdisk)

all: clean mydisk boot1 write_boot1 boot2 write_boot2 hexdump launchqemu

mydisk: 
	dd if=/dev/zero of=$(bootdisk) bs=$(blocksize) count=$(disksize)

boot1: 
	nasm $(ASMFLAGS) $(boot1).asm -o $(boot1).bin 

boot2:
	nasm $(ASMFLAGS) $(boot2).asm -o $(boot2).bin

kernel:
	nasm $(ASMFLAGS) $(kernel).asm -o $(kernel).bin

write_boot1:
	dd if=$(boot1).bin of=$(bootdisk) bs=$(blocksize) count=1 conv=notrunc

write_boot2:
	dd if=$(boot2).bin of=$(bootdisk) bs=$(blocksize) seek=$(boot2pos) count=$(boot2size) conv=notrunc

hexdump:
	hexdump $(file)

disasm:
	ndisasm $(boot1).asm

launchqemu:
	qemu-system-i386 -fda $(bootdisk)
	
clean:
	rm -f *.bin $(bootdisk) *~