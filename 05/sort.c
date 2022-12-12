#include <stdlib.h>

int _qsort_double(const void *aptr, const void *bptr) {
  double a = *(double *)aptr;
  double b = *(double *)bptr;
  if (a < b)
    return -1;
  if (a > b)
    return 1;
  return 0;
}

void fsort(double *farray, size_t arraylen) {
  // Why implement your own sort when the C stdlib does it better?
  qsort(farray, arraylen, sizeof(double), _qsort_double);
}
