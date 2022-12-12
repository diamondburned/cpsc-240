#include <stdio.h>
#include <time.h>

void show_wall_time() {
  time_t now_t;
  time(&now_t);
  const struct tm *now_tm = localtime(&now_t);

  char buf[256];
  strftime(buf, 256, "%b %d, %Y at %H:%M%p", now_tm);

  printf("%s", buf);
}
