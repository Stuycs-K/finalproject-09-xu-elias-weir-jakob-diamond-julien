# Buffer Overflows

## What are buffer overflows

### The Basics (Jakob)

![Buffer Overflow Introductory](figures/BufferOverflowIntroductory.png)
([image source](https://en.wikipedia.org/wiki/Buffer_overflow))

- Overwrites of memory through overfilling evaluated memory space

### Why can buffer overflows be bad

- Can lead to exploits where overwrites of variables and function pointers, along with the functions themselves, can cause unintended behavior.

### Methods

- Heap based exploits
- Stack Based Exploits 
https://stackoverflow.com/questions/4700998/explain-stack-overflow-and-heap-overflow-in-programming-with-example 

## Demos

- Working demo
- Basic Variable Overwriting
- Changing the function pointer
    - using payloads to change pointers
- Adding shellcode to binary

### Demo 4 (Julien)
#### Stack Background ####
- **Stack Frame** is one procedure on the call stack
  - parameters
  - **return address** is where execution should return when stack frame is completed (can be exploited!)
  - old **frame pointer** (pointer from which other elements in the frame can be accessed)
  - local variables
<img width="480" alt="Screenshot 2025-06-03 at 12 58 58 AM" src="https://github.com/user-attachments/assets/26003099-52c0-4365-a1f6-ca16e9dd5d81" />

### Protection Methods (Julien)

- **Address space layout randomization (ASLR)** randomizes the memory addresses of certain data points involved in a process each time it is run
- **Stack canaries** are known values placed around a buffer such that they would be corrupted in the event of a buffer overflow

### Morris Worm (Julien)

- famous exploit released November 2nd, 1988
    - used buffer overflows (among other exploitation methods)
    - used known source code of fingerd to overwrite return address in stack frame (same as demo 4)
    - executes code segment that creates a new shell (as root)

### Self built "broken" binaries

### Pwfeedback

### Loony Tunables

<img src="figures/LooneyTunes.png" alt="drawing" width="200"/>

([image source](https://www.imdb.com/title/tt8543208/))

Loony Tunables is a bug within the 

#### Tryhackme Shell Exploit + Explanation

- Hard for a cyber student of our level to understand
- We are given code that takes an input and puts it into a char array, but can overflow
- This overflow can be manipulated to output Assembly commands
- The program has the SUID bit, so it can be run as the user
- Through use of Assembly, you can switch users to the owner of the file
