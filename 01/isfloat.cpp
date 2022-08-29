//****************************************************************************************************************************
// Program name: "isfloat".  This is a single function distributed without
// accompanying software.  This function scans a      * char array seeking to
// confirm that all characters in the array are in the range of ascii characters
// '0' .. '9'.  Further-  * more, this function confirms that there is exactly
// one decimal point in the string.  IF both conditions are true then a    *
// boolean true is returned, otherwise a boolean false is returned.  Copyright
// (C) 2020 Floyd Holliday                        *
//                                                                                                                           *
// This is a library function distributed without accompanying software. * This
// program is free software: you can redistribute it and/or modify it under the
// terms of the GNU Lesser General Public   * License version 3 as published by
// the Free Software Foundation.  This program is distributed in the hope that
// it will be   * useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.* See the GNU
// Lesser General Public License for more details.  A copy of the GNU Lesser
// General Public License 3.0 should    * have been distributed with this
// function.  If the LGPL does not accompany this software then it is available
// here:         * <https:;www.gnu.org/licenses/>. *
//****************************************************************************************************************************
// Notice how the legal block shows two halves.  The first half reserves right
// of ownership to the author or group of authors. The second half confers
// certain open source freedoms to the users of the software.  The four freedoms
// of open source make this kind of software completely different from
// proprietary software.  Proprietary software carries one EULA which confers
// many right to the copyright holder and none to the user.

// To students in CPSC240:  This is my opinion.  I have studied the the
// available licenses for software especially the GPL, the LGPL, and the Affero
// GPL.  This is what I have learned about the LGPL used with this function
// "isinteger".
//    The section above the blank line is called the "copyright notice".
//    The section below the blank line is called the "license notice".
//    LGPL is for use on software typically found in software libraries.
//    This LGPL license applies only to the specific function named in the
//    license. This library may be used within another application covered by
//    other licenses (or EULAs). This license requires that source code of this
//    function be distributed with the application (even if other parts of the
//        application are not required to be distributed with source code).
//    This LGPL allows you to re-distribute the function (provided the original
//    LGPL remains). This LGPL allows you to modify the function (provided the
//    original LGPL remains). This LGPL allows you to distribute (or sell) your
//    modified versions to anyone (provided the original LGPL remains). When you
//    distribute this software to other people a copy of the LGPL is suppose to
//    accompany the source code in a
//        separate file.  If that separate file becomes lost (by human error)
//        the license still has legal standing.
//
// References:
//    How to correctly place a software license in a source file:
//    https://www.gnu.org/licenses/gpl-howto.html Complete text of LGPL in html
//    format: https://www.gnu.org/licenses/lgpl-3.0.html Complete text of GPL in
//    html format: https://www.gnu.org/licenses/gpl-3.0.html
//
//
// A example: Microsoft programmers are developing a new version of Minecraft.
// One of the programmers on that project discovers a useful function stored
// online that can be used in the new version of Minecraft.  If that online
// function is licensed by GPL and Microsoft uses it, then Microsoft must make
// all of Minecraft open source and licensed by GPL.  However, if that online
// function is licensed by LGPL then Microsoft may legally incorporate the
// function into Minecraft, and Minecraft remains proprietary and wholly secret.
// Do you see a major difference between the two kinds of licenses?

// This opinion is included here for educational purposes in the course CPSC240.
// You must remove this opinion statement when you use this library function in
// other application programs such as homework.
//
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
// Author information
//   Author name: Floyd Holliday
//   Author email: holliday@fullerton.edu
//
// This file
//   Program name: isfloat
//   File name: isfloat.cpp
//   Date development began: 2020-Dec-12
//   Date of last update:  2022-Aug-22
//   Comments reorganized: 2020-Dec-14
//   This is a library function.  It does not belong to any one specific
//   application.  The function is available for inclusion in other
//   applications.  If it is included in another application and there are no
//   modifications made to the executing statements in this file then do not
//   modify the license and do not modify any part of this file; use it as is.
//   Language: C++
//   Max page width: 132 columns
//   Optimal print specification: monospace, 132 columns, 8½x11 paper
//   Testing: This function was tested successfully on a Linux platform derived
//   from Ubuntu. Compile: g++ -c -m64 -Wall -fno-pie -no-pie -o isfloat.o
//   isfloat.cpp -std=c++17 Classification: Library
//
// Purpose
//   Scan a contiguous segment of memory from the starting byte to the null
//   character and determine if the string of chars is properly formatted for
//   conversion to a valid float number.  This function, isfloat, does not
//   perform the conversion itself.  That task is is done by a library function
//   such as atof.
//
// Future project
//   Re-write this function in X86 assembly.
//   Added 2022-Aug-22: This function was re-writen from scratch, that is,
//   without reference to this file.  Feel free to download isfloat.asm
//
// How to call isfloat from an X86 function
//   == Declare isfloat to exist in another file: extern isfloat
//   == Obtain an address pointing to starting byte in memory.  Such an address
//   can be a register like rsp.  Also, the address may
//      be provide by the name of an array.   For example, "mystuff resq 300"
//      declares an array of 300 bytes,  The name "mystuff" may be used as the
//      start of block of memory.
//   == Do the setup block for isfloat:
//      == mov rax,0
//      == mov rdi, <a memory location>    such as mov rdi, rsp, or mystuff
//      == call isfloat
//      == The boolean result is returned in rax.  If rax holds exactly 0 then
//      'false' was returned, otherwise 'true' was returned.

// How to call isfloat from a C function
//   ==Place the prototype near the top of the calling function:  bool
//   isinteger(char []);
//   ==Declare a bool variable:  bool outcome;
//   ==Create an array:  char wonder[200];
//   ==Fill the array with a null-terminate sequence of chars.  Usually this
//   sequence comes from an input device like stdin (keyboard).
//   ==Call the function: outcome = isfloat(wonder)
//   ==Test outcome for true = "It is a float number" or false = "It is not a
//   float number".

// How to call isfloat from a C++ function
//   ==Place the prototype near the top of the calling function:  extern "C"
//   bool isinteger(char []);
//   ==Declare a bool variable:  bool outcome;
//   ==Create an array:  char wonder[200];
//   ==Fill the array with a null-terminate sequence of chars.  Usually this
//   sequence comes from an input device like stdin (keyboard).
//   ==Call the function: outcome = isfloat(wonder)
//   ==Test outcome for true = "It is a float number" or false = "It is not a
//   float number".

#include <iostream>

extern "C" bool isfloat(char[]);

bool isfloat(char w[]) {
  bool result = true;
  bool onepoint = false;
  int start = 0;
  if (w[0] == '-' || w[0] == '+')
    start = 1;
  unsigned long int k = start;
  while (!(w[k] == '\0') && result) {
    if (w[k] == '.' && !onepoint)
      onepoint = true;
    else
      result = result && isdigit(w[k]);
    k++;
  }
  return result && onepoint;
}
