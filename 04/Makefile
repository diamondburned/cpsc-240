PWD := $(shell pwd)
DIR := $(shell basename $(PWD))

all: main.out

clean:
	rm -f *.out *.o
	rm -f atod.asm
	rm -f dtoa.asm

define ctoasm
	gcc -Wall -Os -fno-stack-protector -s -c -o $(1).o $(1)
	objconv -v0 -fnasm $(1).o $(1).asm
	dos2unix -q $(1).asm
	sed -i \
		-e 's/;.*$$//' \
		-e 's/?_\([0-9]*\)/.\1/g' \
		-e 's/^default rel//g' \
		-e 's/^SECTION \(\.\w*\).*$$/section \1/g' \
		-e 's/^global \(\w*\):.*$$/global \1/g' \
		-e 's/^section \.\(note\|eh_frame\)//g' \
		-e 's/ \+\(db\|dd\) .*//g' \
		-e 's/^\([^ ]*\):\(.*\)$$/\1:\n\2/g' \
		$(1).asm
	command -v nasmfmt &> /dev/null && nasmfmt $(1).asm
	cat $(1) \
		| sed -n '/\(^\/\/\|^$$\)/p' \
		| sed -e 's/\/\//;/' -e 's/^;$$/; /g' \
		> $(1).asm.cmt
	# Merge the comments into the assembly.
	cat $(1).asm.cmt $(1).asm > $(2)
	command -v nasmfmt &> /dev/null && nasmfmt $(2)
	rm $(1).asm.cmt $(1).asm $(1).o
endef

atod.asm: _atod.c
	$(call ctoasm,_atod.c,atod.asm)

dtoa.asm: _dtoa.c
	$(call ctoasm,_dtoa.c,dtoa.asm)

main.out: atod.asm dtoa.asm main.asm
	if [ -f build.sh ]; then ./build.sh; else build; fi
	mv ${DIR}.out main.out
