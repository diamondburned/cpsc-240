// Copyright 2022 Diamond Dinh (diamondburned), licensed under the MIT license.

extern long int itoa(long int n, char *buf, long int len);

long int ftoa(double n, char *buf, long int buflen) {
  if (buflen == 0) {
    return 0;
  }

  // NaN test. All correct fp implementations should have this behavior, since
  // the specs define that NaN != NaN.
  if (n != n) {
    if (buflen < 4) {
      return 0;
    }
    buf[0] = 'N';
    buf[1] = 'a';
    buf[2] = 'N';
    buf[3] = '\0';
    return 3;
  }

  long int written = 0;

  // Explicitly check if our number is negative.
  // If we have a negative number, then we need to write a negative sign.
  if (n < 0) {
    if (buflen < 2) {
      buf[0] = '\0';
      return 0;
    }

    buf[written] = '-';
    written++;

    // Invert the number since it's positive now.
    n = -n;
  }

  // Floor the number.
  long int whole = (long int)n;

  // Convert the integer part to a string.
  long int nlen = itoa(whole, buf + written, buflen);
  if (nlen == 0) {
    buf[0] = '\0';
    return 0;
  }

  written += nlen;

  // Get the decimal part.
  double f = n - whole;
  if (f > 0) {
    if (buflen < written + 2) {
      buf[0] = '\0';
      return 0;
    }

    // Add a decimal point.
    buf[written] = '.';
    written++;

    // Allocate a temporary 6 bytes buffer for the decimal part. This will be
    // our precision.
    const int dbuflen = 7;
    char dbuf[dbuflen];

    // Multiply the decimal part by this to get the first few numbers and
    // truncate the rest. This has rounding errors, but whatever.
    long int d = (long int)(f * 1000000);

    // Convert the decimal part to a string.
    long int dlen = itoa(d, dbuf, dbuflen);
    if (dlen == 0) {
      buf[0] = '\0';
      return 0;
    }

    // We'll need to write the zeros that are after the decimal point, since
    // itoa will not write them.
    if (d > 0) {
      // We keep going if d is less than 100_000. We'll keep track of how many
      // times it takes for us to get to 100_000.
      long int zeros = 0;
      for (long int d1 = d; d1 < 100000; d1 *= 10) {
        zeros++;
      }

      // Then, we'll shift the string rightwards that many times. We'll have to
      // do this backwards, since we want to move the last one to the right
      // first before the left ones.
      for (long int i = dlen - 1; i >= 0; i--) {
        dbuf[i + zeros] = dbuf[i];
      }

      // Write the zeros.
      for (long int i = 0; i < zeros; i++) {
        dbuf[i] = '0';
      }

      // The length is now 6 because we added zeros (6 decimal points total).
      dlen = dbuflen - 1;
    }

    // Trim trailing zeros.
    while (dlen > 1 && dbuf[dlen - 1] == '0') {
      dlen--;
    }

    // Copy dbuf to buf.
    for (int i = 0; i < dlen; i++) {
      buf[written] = dbuf[i];
      written++;
    }

    // Write the null terminator.
    buf[written] = '\0';
  }

  return written;
}
