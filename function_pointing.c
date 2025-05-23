// gcc function_pointing.c -o functions -zexecstack -fno-stack-protector
// gdb -> isolate the function pointer and then overflow to add the other buffer


#include <stdio.h>
#include <string.h>

void special()
{
    printf("this is the special function\n");
    printf("you did this, friend!\n");
}

void normal()
{
    printf("this is the normal function\n");
}

void other()
{
    printf("why is this here?");
}

int main(int argc, char **argv)
{
    volatile int (*new_ptr) () = normal;
    char buffer[14];
    gets(buffer);
    new_ptr();
}