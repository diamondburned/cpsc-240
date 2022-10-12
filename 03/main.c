// Name: Diamond Dinh
// Language(s): C, x86 Assembly
// Dates: 1 October, 2022 - 9 October, 2022
// File(s): display_array.cpp, input_array.asm, main.c, manager.asm, sum.asm
// Status: Done
// References:
//   https://nasm.us/doc/nasmdoc4.html
//   https://cs.lmu.edu/~ray/notes/nasmtutorial/
//   https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html
//   https://stackoverflow.com/questions/7607550/scanf-skip-variable
//   https://www.felixcloutier.com/x86
// Module Info:
//   File name: main.c
//   Language: C
// How to run:
//   build.sh
//   03.out (or whatever the folder name was + ".out")

#include <stdio.h>

extern char *manager(void);

int main() {
  printf("Welcome to Arrays of Integers\n"
         "Bought to you by Diamond Dinh.\n"
         "\n");
  char *fullName = manager();
  printf("\n"
         "I hope you liked your arrays %s.\n"
         "Main will return 0 to the operating system. Bye.\n",
         fullName);
}
