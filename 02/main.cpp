#include <cmath>
#include <cstdio>
#include <ios>
#include <iostream>

extern "C" double entrypoint();

int main(int argc, char **argv) {
  std::cout << "Welcome to the Right Triangles program maintained by Diamond "
               "Dinh."
            << "\n\n"
            << "If errors are discovered please report them to Diamond Dinh at "
               "diamondburned@csu.fullerton.edu for a quick fix."
            << "\n\n";
  const auto res = entrypoint();
  std::cout << "The main function received this number " << std::fixed << res
            << " and plans to keep it."
            << "\n\n"
            << "An integer zero will be returned to the operating system. "
               "Bye."
            << "\n";
  return 0;
}
