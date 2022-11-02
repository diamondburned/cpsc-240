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

CFLAGS="-g -m64 -Wall -Wextra -Wpedantic -fstack-protector -fno-pie -no-pie"
CXXFLAGS="$CFLAGS -std=c++17 -lstdc++"

LD="ld"
out="$(basename "$PWD").out"

for f in $(glob *.asm); do
	nasm -f elf64 -F dwarf -g -O0 -o "$f.o" "$f"
done

for f in $(glob *.c); do
	LD="gcc"
	hasC=1
	gcc -c $CFLAGS -o "$f.o" "$f"	
done

for f in $(glob *.cpp); do
	LD="g++"
	g++ -c $CXXFLAGS -o "$f.o" "$f"
done

case "$LD" in
	ld)  ld -o $out *.o;;
	gcc) gcc $CFLAGS -o $out *.o;;
	g++) g++ $CXXFLAGS -o $out *.o;;
esac

rm -f -- *.o *.lis
