#include <cstdio>
#include <iostream>

// manager returns the full name inputted from the user.
extern "C" char *manager();

int main() {
  std::cout << "Welcome to Maximum authored by Diamond Dinh." << std::endl;
  const auto full_name = manager();
  std::cout << "\n"
            << "Thank you for using this software, " << full_name << "\n"
            << "Bye.\n"
            << "A zero was returned to the operating system." << std::endl;
  return 0;
}
