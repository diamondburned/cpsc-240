#include <cstdio> // printf, scanf
#include <cstdlib>
#include <iostream>

extern "C" double floating_point_io();

int main(int argc, char **argv) {
  std::cout << "Welcome to Floating Points Numbers programmed by Diamond Dinh.\n\n";
  auto min = floating_point_io();
  std::cout
      << "The driver module received this float number " << min
      << " and will keep it.\n"
      << "The driver module will return integer 0 to the operating system.\n"
      << "Have a nice day.  Good-bye.\n";
  return 0;
}
