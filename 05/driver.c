#include <stdio.h>

extern double manager();
extern void show_wall_time();

int main() {
  printf(
      "Welcome to Quicksort Benchmark by Diamond Dinh\n\n"
      "This program will measure the execution time of a sort function.\n\n");
  double runtime = manager();
  printf("The main program received %lf\n\n", runtime);
  printf("The time on the wall is now ");
  show_wall_time();
  printf(".\n\n"
         "Have a great rest of your day. Zero will be sent to the OS.\n"
         "See you next semester in 440. Bye\n");
  return 0;
}
