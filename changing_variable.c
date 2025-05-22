#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
// source : https://stackoverflow.com/questions/26245447/which-versions-of-gcc-or-flags-should-i-use-when-studying-buffer-overflows
// $ gcc change_of_variable.c -o cccchanges -zexecstack -fno-stack-protector
// $ ./cccchanges
// msksmadsmfnadsf

int main(int argc, char *argv[]) {
  volatile int variable = 0;
  char buffer[14];

  gets(buffer);

  if (variable != 0) {
    printf("you have changed the value of the volatile variable to %d\n",
           variable);
  } else {
    printf("try again");
  }
}