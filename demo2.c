#include <stdio.h>
#include <signal.h>
#include "demo2.h"

specialFunction() {
  signal(SIGSEGV, sighandler);
  puts("i'm special");
  exit(0);
}

GetInput() {
  char buffer[8];
  gets(buffer);
  puts(buffer);
}

main() {
  GetInput();
  return 0;
}

static void sighandler(int signo) { }
