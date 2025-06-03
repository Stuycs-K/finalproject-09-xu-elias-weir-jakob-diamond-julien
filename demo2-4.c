// gcc demo2-4.c -o demo2-4 -zexecstck -fno-stack-protector -no-pie -g
// weird ~~skibidi~~gdb x/16xw $rsp
#include <stdio.h>
#include <stdlib.h>

int specialFunction() {
  puts("i'm special");
  exit(0);
}

int getInput() {
  char buffer[8];
  gets(buffer);
  puts(buffer);
}

int main() {
  getInput();
  return 0;
}
