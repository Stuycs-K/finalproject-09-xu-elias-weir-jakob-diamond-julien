# Buffer Overflows

## What are buffer overflows

### The Basics

![Buffer Overflow Introductory](figures/BufferOverflowIntroductory.png)
([image source](https://en.wikipedia.org/wiki/Buffer_overflow))

- Overwrites of memory through overfilling evaluated memory space

### Why can buffer overflows be bad

- Can lead to exploits where overwrites of variables and function pointers, along with the functions themselves, can cause unintended behavior.

### Methods

- Heap based exploits
- Stack Based Exploits 
https://stackoverflow.com/questions/4700998/explain-stack-overflow-and-heap-overflow-in-programming-with-example 

### Famous exploit

- Morris worm
    - Cornell Grad Student 
- Hella other worms -> very popular exploit before best practices mitigated them


### Always use protection people

- ASLR
- SEHOP
- Data exploitation protection

## Demos

- Working demo
- Basic Variable Overwriting
- Changing the function pointer
    - using payloads to change pointers
- Adding shellcode to binary
- Whatever Julien was doing

### Self built "broken" binaries

### Pwfeedback

### Loony Tunables


![Loony Tunes](figures/LooneyTunes.png)
([image source](https://www.imdb.com/title/tt8543208/))

#### Tryhackme Shell Exploit + Explanation

- Hard for a cyber student of our level to understand
- We are given code that takes an input and puts it into a char array, but can overflow
- This overflow can be manipulated to output Assembly commands
- The program has the SUID bit, so it can be run as the user
- Through use of Assembly, you can switch users to the owner of the file
