// Name: Diamond Dinh
// Language(s): C++, x86 Assembly
// Dates: 22 August, 2022 ~ 31 August, 2022
// File(s): main.asm, main.cpp, isfloat.cpp
// Status: Done
// References:
//   https://www.cs.uaf.edu/2003/fall/cs301/doc/nasmdoc0.html
//   https://www.nasm.us/xdoc/2.10.09/html/nasmdoc3.html
//   https://sites.google.com/a/fullerton.edu/activeprofessor/4-subjects/x86-programming/library-software/isfloat?authuser=0
//   https://sites.google.com/a/fullerton.edu/activeprofessor/4-subjects/x86-programming/x86-examples/floating-io?authuser=0
// Module Info:
//   File name: main.cpp
//   Language: C++
//   How to compile:
//     #!/usr/bin/env bash
//     set -e
//     rm -f -- *.o *.lis *.out
//
//     for f in *.asm; do
//         nasm -f elf64 -o "$f.o" "$f"
//     done
//     for f in *.cpp; do
//         g++ -g -c -m64 -Wall -std=c++17 -fno-pie -no-pie -o "$f.o" "$f"
//     done
//
//     g++ -g -m64 -std=c++14 -fno-pie -no-pie -o "$(basename "$PWD").out" *.o
//

#include <cstdio> // printf, scanf
#include <cstdlib>
#include <ios>
#include <iostream>

extern "C" double floating_point_io();

int main(int argc, char **argv) {
  std::cout
      << "Welcome to Floating Points Numbers programmed by Diamond Dinh.\n\n";
  auto min = floating_point_io();
  std::cout
      << "The driver module received this float number " << std::fixed << min
      << " and will keep it.\n"
      << "The driver module will return integer 0 to the operating system.\n"
      << "Have a nice day.  Good-bye.\n";
  return 0;
}
