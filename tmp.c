#include <stdio.h>
#include <stdlib.h>

int main() {
    char instruction[100];
    sprintf(instruction, "JMF %d ?\n", popTmp());
    char * tab[10];
    tab[0] = instruction;
    
}