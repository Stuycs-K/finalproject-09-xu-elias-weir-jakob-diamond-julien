#include <stdio.h>

specialFunction() {
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
