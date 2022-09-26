// Name: Diamond Dinh
// Language(s): C, x86 Assembly
// Dates: 1 September, 2022 - 18 September, 2022
// File(s): triangle.asm, pythagoras.c, build.sh, gdb.md
// Status: Done
// References:
//   <see triangle.asm>
// Module Info:
//   File name: pythagoras.c
//   Language: C
//   How to compile:
//     build.sh

#include <stdio.h>

extern double triangle();

int main(int argc, char **argv) {
  printf("Welcome to the Right Triangles program maintained by Diamond Dinh."
         "\n\n"
         "If errors are discovered please report them to Diamond Dinh at "
         "diamondburned@csu.fullerton.edu for a quick fix.\n\n");
  const double res = triangle();
  printf("The main function received this number %.lf and plans to keep it."
         "\n\n"
         "An integer zero will be returned to the operating system. "
         "Bye.\n",
         res);
  return 0;
}
