// This code is taken from StackOverflow. Code taken from StackOverflow are
// licensed under CC BY-SA 3.0. See
// https://creativecommons.org/licenses/by-sa/3.0/ for more information.
//
// Source Link: https://stackoverflow.com/a/4392789/5041327

#include <math.h>

// atof converts a string to a double.
double atof(const char *s, long int len) {
  // NaN is Not a Number. Since we don't have a libc, we can't use math.h's
  // NaN.
  // NOTE: gcc will NOT emit a NaN on its own without -ffast-math. This is
  // rather weird, since it will emit a divss instead, which doesn't emit a
  // proper NaN.
  const double NaN = 0.0 / 0.0;
  if (len == 0) {
    return NaN;
  }

  const char *ends = s + len;
  double rez = 0, fact = 1;
  if (*s == '-') {
    s++;
    fact = -1;
  };

  for (int point_seen = 0; s < ends; s++) {
    if (*s == '.') {
      if (point_seen) {
        // If we encounter a duplicate period, then there's a syntax error.
        return NaN;
      }
      point_seen = 1;
      continue;
    };

    int d = *s - '0';
    if (d >= 0 && d <= 9) {
      if (point_seen) {
        fact /= 10.0f;
      }
      rez = rez * 10.0f + (double)d;
    } else {
      return NaN;
    }
  };

  return rez * fact;
};
