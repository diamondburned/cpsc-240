#include <stdio.h>

extern double entrypoint();

int main(int argc, char **argv) {
  printf("Welcome to the Right Triangles program maintained by Diamond Dinh."
         "\n\n"
         "If errors are discovered please report them to Diamond Dinh at "
         "diamondburned@csu.fullerton.edu for a quick fix.\n\n");
  const double res = entrypoint();
  printf("The main function received this number %.lf and plans to keep it."
         "\n\n"
         "An integer zero will be returned to the operating system. "
         "Bye.\n",
         res);
  return 0;
}
