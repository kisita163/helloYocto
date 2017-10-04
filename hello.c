// Standard C and pthread includes 

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>


void say_hello(void) {

  printf("Hello world !\n");
  return;

}

int main(int argc, char * argv[]) {

  say_hello();
  return 0;

}

