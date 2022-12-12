// Diamond Dinh
// CPSC 240-01
// Final Program Test
// diamondburned@csu.fullerton.edu

#include <stdio.h>

extern double supervisor();

int main() {
  printf("Welcome to Harmonic Mean by Diamond Dinh.\n\n"
         "This program will compute the harmonic mean of your numbers.\n\n");
  double hmean = supervisor();
  printf("The main function received this number %lf and will keep it for a "
         "while.\n\n"
         "Enjoy your winter break.\n",
         hmean);
  return 0;
}
