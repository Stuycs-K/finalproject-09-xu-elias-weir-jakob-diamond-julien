# Dev Log:

This document must be updated daily every time you finish a work session.

## Julien Diamond

### 2025-05-16 - TryHackMe Room
Found [this](https://tryhackme.com/room/bof1) TryHackMe room and started going through it to understand buffer overflow

### 2025-05-19 (class) - Intro notes on buffer overflow

Created general note-taking doc to compile information, and started filling it out with basic info from [this](https://en.wikipedia.org/wiki/Buffer_overflow) Wikipdia page

### 2025-05-20 - More notes on buffer overflow

Continued taking notes into note doc

### 2025-05-20 (class) - Notes on exploitation + Morris Worm

Took notes on methods of stack-based and heap-based buffer overflow, as well as overview of impact of Morris Worm (historical example)

### 2025-05-20 - Stack-based exploitation

Continuted looking in to how stack-based exploitation is performed by overwriting return address in the call stack

### 2025-05-26 - Specific Example

Was able to trace through specific stack-based buffer overflow example with gdb to view memory addresses in the stack. I was unable to replicate it on my own computer, likely due to modern security mechanisms.

### 2025-05-27 (class) - Attempted implementation of example

Attempted to send address of special function as payload to overwrite return address for other function, but was met with segfaults

### 2025-05-27 - Continued attempted implementation of example

Through further gdb tracking, the program seems to successfully "find" the special function, but it segfaults upon receiving SIGSEGV. I will try to use signal handling for this tomorrow

### 2025-05-28 (class) - Continued attempted implementation of example

tried to use xxd to write memory into input file

### 2025-05-31 - demo2 has been conquered

Got it to work in gdb by swapping printf for puts and got it work in terminal too by compiling with -no-pie to get rid of memory randomization

### 2025-06-01 - demo2 updated

got rid of unnecessary signal handling and fixed some unneeded warnings during compilation

### 2025-06-02 - worked on presentation doc

added my demo + protection methods (canaries + alsr)

### 2025-06-03 - morris worm

added morris worm info to presentation doc
