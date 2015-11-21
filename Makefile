name := kaos
arch ?= x86_64
kernel := build/kernel-$(arch).bin
iso := build/$(name)-$(arch).iso
platform_dir := /usr/lib/grub/i386-pc/
linker_script := src/arch/$(arch)/linker.ld
grub_cfg := src/arch/$(arch)/grub.cfg
assembly_source_files := $(wildcard src/arch/$(arch)/*.asm)
assembly_object_files := $(patsubst src/arch/$(arch)/%.asm, \
	build/arch/$(arch)/%.o, $(assembly_source_files))

.PHONY: all clean run iso

all: $(kernel)

clean:
	@rm -r build

run: $(iso)
	@qemu-system-x86_64 -hda $(iso)

iso: $(iso)

$(iso): $(kernel)
	@mkdir -p build/isofiles/boot/grub
	@cp $(kernel) build/isofiles/boot/
	@cp $(grub_cfg) build/isofiles/boot/grub
	@grub-mkrescue -d $(platform_dir) -o $(iso) build/isofiles 2>/dev/null
	@rm -r build/isofiles

$(kernel): $(assembly_object_files) $(linker_script)
	@ld -n -T $(linker_script) -o $(kernel) $(assembly_object_files)

# compile assembly files
build/arch/$(arch)/%.o: src/arch/$(arch)/%.asm
	@mkdir -p $(shell dirname $@)
	@nasm -f elf64 $< -o $@
