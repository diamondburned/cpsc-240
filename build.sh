#!/bin/sh
set -e
rm -f -- *.o *.lis *.out

glob() {
	# https://stackoverflow.com/a/15515152/5041327
	[ -e "$1" ] || return

	for f in "$@"; do
		# Exclude all _* files.
		case "$f" in
		_*) ;;
		*)  echo "$f";;
		esac
	done
}

CFLAGS="-g -m64 -Wall -Wextra -Wpedantic -fsanitize=address -fstack-protector -fno-pie -no-pie"
CXXFLAGS="$CFLAGS -std=c++17"

hasC=
out="$(basename "$PWD").out"

for f in $(glob *.asm); do
	nasm -f elf64 -o "$f.o" "$f"
done

for f in $(glob *.cpp); do
	hasC=1
	g++ -c $CXXFLAGS -o "$f.o" "$f"
done

for f in $(glob *.c); do
	hasC=1
	gcc -c $CFLAGS -o "$f.o" "$f"	
done

[ -n "$hasC" ] \
	&& gcc $CXXFLAGS -o $out *.o \
	|| ld -o $out *.o

rm -f -- *.o *.lis
