# GDB Notes

```
―❤―▶ gdb ./02.out 
GNU gdb (GDB) 11.2
Copyright (C) 2022 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-unknown-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./02.out...
```

```
(gdb) b main 
Breakpoint 1 at 0x4010e0: file /nix/store/hd3j5xfvffs4vaa74l1har94q10fpnm5-glibc-2.34-210-dev/include/bits/stdio2.h, line 112.
```

```
(gdb) b triangle 
Breakpoint 2 at 0x401234
```

```
(gdb) r
Starting program: /home/diamond/Scripts/cpsc-240/02/02.out 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/nix/store/bvy2z17rzlvkx2sj7fy99ajm853yv898-glibc-2.34-210/lib/libthread_db.so.1".

Breakpoint 1, main (argc=1, argv=0x7fffffff5688) at pythagoras.c:5
5	int main(int argc, char **argv) {
```

```
(gdb) info locals
res = <optimized out>
```

```
(gdb) disassemble
Dump of assembler code for function main:
=> 0x00000000004011b6 <+0>:	sub    $0x8,%rsp
   0x00000000004011ba <+4>:	mov    $0x402020,%edi
   0x00000000004011bf <+9>:	call   0x401070 <puts@plt>
   0x00000000004011c4 <+14>:	mov    $0x0,%eax
   0x00000000004011c9 <+19>:	call   0x401230 <triangle>
   0x00000000004011ce <+24>:	mov    $0x402100,%esi
   0x00000000004011d3 <+29>:	mov    $0x1,%edi
   0x00000000004011d8 <+34>:	mov    $0x1,%eax
   0x00000000004011dd <+39>:	call   0x401030 <__printf_chk@plt>
   0x00000000004011e2 <+44>:	mov    $0x0,%eax
   0x00000000004011e7 <+49>:	add    $0x8,%rsp
   0x00000000004011eb <+53>:	ret    
End of assembler dump.
```

```
(gdb) list
5	int main(int argc, char **argv) {
6	  printf("Welcome to the Right Triangles program maintained by Diamond Dinh."
7	         "\n\n"
8	         "If errors are discovered please report them to Diamond Dinh at "
9	         "diamondburned@csu.fullerton.edu for a quick fix.\n\n");
10	  const double res = triangle();
11	  printf("The main function received this number %.lf and plans to keep it."
12	         "\n\n"
13	         "An integer zero will be returned to the operating system. "
14	         "Bye.\n",
```

```
(gdb) p $esi
$7 = -43384
```

```
(gdb) p/x $esi
$8 = 0xffff5688
```

```
(gdb) p $rsi
$9 = 140737488311944
```

```
(gdb) p/x $rsi
$10 = 0x7fffffff5688
```

```
(gdb) x $rsi
0x7fffffff5688:	0xffff5ea6
```

```
(gdb) info proc map
process 1560469
Mapped address spaces:

          Start Addr           End Addr       Size     Offset objfile
            0x400000           0x401000     0x1000        0x0 /home/diamond/Scripts/cpsc-240/02/02.out
            0x401000           0x402000     0x1000     0x1000 /home/diamond/Scripts/cpsc-240/02/02.out
            0x402000           0x403000     0x1000     0x2000 /home/diamond/Scripts/cpsc-240/02/02.out
            0x403000           0x404000     0x1000     0x2000 /home/diamond/Scripts/cpsc-240/02/02.out
            0x404000           0x405000     0x1000     0x3000 /home/diamond/Scripts/cpsc-240/02/02.out

<lines omitted>
```

```
(gdb) find /b 0x400000, 0x405000-1, 'W', 'e', 'l', 'c', 'o', 'm', 'e'
0x402020
warning: Unable to access 12256 bytes of target memory at 0x402021, halting search.
1 pattern found.
```

```
(gdb) p (char*)0x402020
$18 = 0x402020 "Welcome to the Right Triangles program maintained by Diamond Dinh.\n\nIf errors are discovered please report them to Diamond Dinh at diamondburned@csu.fullerton.edu for a quick fix.\n"
```

```
(gdb) x $rdx
0x7fffffff5698:	0xffff5ecf
```

```
(gdb) x/2g $rsp
0x7fffffff5578:	0x00007ffff7106237	0x00007ffff72cdd08
```

```
(gdb) n
6	  printf("Welcome to the Right Triangles program maintained by Diamond Dinh."
```

```
(gdb) n
Welcome to the Right Triangles program maintained by Diamond Dinh.

If errors are discovered please report them to Diamond Dinh at diamondburned@csu.fullerton.edu for a quick fix.

10	  const double res = triangle();
```

```
(gdb) s

Breakpoint 2, 0x0000000000401234 in triangle ()
```

```
(gdb) bt
#0  0x0000000000401234 in triangle ()
#1  0x00000000004011ce in main (argc=<optimized out>, argv=<optimized out>) at pythagoras.c:10
```

```
(gdb) disassemble
Dump of assembler code for function triangle:
   0x0000000000401230 <+0>:	push   %rbp
   0x0000000000401231 <+1>:	mov    %rsp,%rbp
=> 0x0000000000401234 <+4>:	push   %rax
   0x0000000000401235 <+5>:	push   %rdx
   0x0000000000401236 <+6>:	push   %rsi
   0x0000000000401237 <+7>:	push   %rdi
   0x0000000000401238 <+8>:	mov    $0x0,%eax
   0x000000000040123d <+13>:	movabs $0x4040b2,%rdi
   0x0000000000401247 <+23>:	movabs $0x4040b9,%rsi
   0x0000000000401251 <+33>:	call   0x401040 <printf@plt>
   0x0000000000401256 <+38>:	mov    $0x0,%eax
   0x000000000040125b <+43>:	movabs $0x4041dc,%rdi
   0x0000000000401265 <+53>:	mov    $0x100,%esi
   0x000000000040126a <+58>:	mov    0x4041d0,%rdx
   0x0000000000401272 <+66>:	call   0x4010a0 <fgets@plt>

<lines omitted>
```

I'll break at the printf call.

```
(gdb) b *0x0000000000401251
Breakpoint 2 at 0x401251
```

```
(gdb) c
Continuing.

Breakpoint 2, 0x0000000000401251 in triangle ()
```

I can find out the string just by checking the printf arguments:

```
(gdb) p (char*) $rdi
$8 = 0x4040b2 "%s"
(gdb) p (char*) $rsi
$9 = 0x4040b9 "Please enter your last name: "
```

From looking at the address, I think that the strings are on the stack.

I'll make a breakpoint at the scanf call.

```
(gdb) b *0x000000000040132f
Breakpoint 3 at 0x40132f
```

```
(gdb) c
Continuing.
Please enter your last name: Last
Please enter your title (Mr, Ms, Nurse, Engineer, etc.): Title

Breakpoint 3, 0x000000000040132f in triangle ()
```

```
(gdb) disassemble
Dump of assembler code for function triangle:
<lines omitted>
   0x0000000000401311 <+225>:	movabs $0x40414b,%rdi
   0x000000000040131b <+235>:	movabs $0x4043dc,%rsi
   0x0000000000401325 <+245>:	movabs $0x4043e4,%rdx
--Type <RET> for more, q to quit, c to continue without paging--
=> 0x000000000040132f <+255>:	call   0x401060 <scanf@plt>
   0x0000000000401334 <+260>:	cmp    $0x0,%rax
<lines omitted>
```

This is before inserting the numbers.

```
(gdb) x $rdi
0x40414b:	0x20666c25
(gdb) x $rsi
0x4043dc:	0x00000000
(gdb) x $rdx
0x4043e4:	0x00000000
```

Note the two addresses, `0x4043dc` and `0x4043e4`, since I used `.bss`.

```
(gdb) ni
Please enter the sides of your triangle separated by ws: 4 5
0x0000000000401334 in triangle ()
```

We check them again.

```
(gdb) p/x 0x4043dc
$3 = 0x4043dc
(gdb) p/x 0x4043e4
$4 = 0x4043e4
```

We can cast them to `double*` and dereference them to get the values:

```
(gdb) p *(double*)0x4043dc
$10 = 4
(gdb) p *(double*)0x4043e4
$11 = 5
```

We'll step through the program until we see a return.

```
(gdb) ni
0x0000000000401338 in triangle ()
(gdb) ni
0x000000000040133e in triangle ()
(gdb) ni
0x0000000000401347 in triangle ()
(gdb) ni
0x0000000000401350 in triangle ()
<lines omitted>
(gdb) 
The length of the hypotenuse is 6.403124 units.
0x00000000004013bd in triangle ()
(gdb) 
0x00000000004013c2 in triangle ()
(gdb) 
0x00000000004013cc in triangle ()
(gdb) 
0x00000000004013d6 in triangle ()
(gdb) 
0x00000000004013e0 in triangle ()
(gdb) 
Please enjoy your triangles Title Last.
0x00000000004013e5 in triangle ()
(gdb) ni
0x00000000004013ee in return ()
```

Start inspecting xmm0.

```
(gdb) p $xmm0
$12 = {v8_bfloat16 = {-1.701e+38, -1.644e-23, -1.35e-21, 2.391, 0, 0, 0, 0}, v4_float = {-1.65432084e-23, 2.40019512, 0, 0}, v2_double = {6.4031242374328485, 0}, v16_int8 = {0, -1, -97, 
    -103, -52, -100, 25, 64, 0, 0, 0, 0, 0, 0, 0, 0}, v8_int16 = {-256, -26209, -25396, 16409, 0, 0, 0, 0}, v4_int32 = {-1717567744, 1075420364, 0, 0}, v2_int64 = {4618895295409815296, 0}, 
  uint128 = 4618895295409815296}
```

We know that we're handling doubles, and we see that `v2_double` has something interesting.

Let's check that.

```
(gdb) p $xmm0.v2_double[0]
$15 = 6.4031242374328485
```

This checks out with the number that we see in the printed line.

We continue the program as usual, and everything worked fine.

```
(gdb) c
Continuing.
The main function received this number 6 and plans to keep it.

An integer zero will be returned to the operating system. Bye.
```

It actually did not.

```
==1658445==LeakSanitizer has encountered a fatal error.
==1658445==HINT: For debugging, try setting environment variable LSAN_OPTIONS=verbosity=1:log_threads=1
==1658445==HINT: LeakSanitizer does not work under ptrace (strace, gdb, etc)
[Inferior 1 (process 1658445) exited with code 01]
```

LeakSanitizer might've just been confused by us using gdb, though. The program
runs fine outside gdb.
