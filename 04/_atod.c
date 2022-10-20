// This code is taken from StackOverflow. Code taken from StackOverflow are
// licensed under CC BY-SA 3.0. See
// https://creativecommons.org/licenses/by-sa/3.0/ for more information.
//
// Source Link: https://stackoverflow.com/a/4392789/5041327

// atod converts a string to a double.
double atod(const char *s, int len) {
  const char *ends = s + len;
  double rez = 0, fact = 1;
  if (*s == '-') {
    s++;
    fact = -1;
  };
  for (int point_seen = 0; s < ends; s++) {
    if (*s == '.') {
      point_seen = 1;
      continue;
    };
    int d = *s - '0';
    if (d >= 0 && d <= 9) {
      if (point_seen)
        fact /= 10.0f;
      rez = rez * 10.0f + (double)d;
    };
  };
  return rez * fact;
};
