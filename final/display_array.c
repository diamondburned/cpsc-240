// Diamond Dinh
// CPSC 240-01
// Final Program Test
// diamondburned@csu.fullerton.edu

#include <stddef.h>
#include <stdio.h>

void display_array(double *array, size_t start, size_t len) {
  for (size_t i = start; i < start + len; i++) {
    printf("%lf\n", array[i]);
  }
}
