#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table.h"

typedef struct Elem* Pile;

void printPile() {
    printf("####### Pile #######\n");
    struct Elem * tmp = pile;
    while(tmp != NULL) {
        printf("%s : %d\n", tmp->label, tmp->address);
        tmp = tmp->suiv;
    } 

    printf("#######     #######\n");
}
void push(char * label, enum Type type) {
    struct Elem * elem;
    elem = malloc(sizeof(struct Elem));
    elem->label = label;
    elem->address = getNewAddress(type);
    elem->profondeur = profondeur;
    elem->type = type;

    if (pile != NULL) {
        elem->suiv = pile;
    }
    pile = elem;

    printPile();
}

void pop(int profondeur) {
    int run = 1;
    while(pile != NULL && pile->profondeur >= profondeur) {
        printf("loop\n");
        pile = pile->suiv;
    }
}

int popTmp() {
    int tmp = pile->address;
    if (nbTmp > 0) {
        pile = pile->suiv;
        nbTmp--;
    }
    return tmp;
}



// take address and increment 

int getNewAddress(enum Type type) {
    int addr = address;

    if (type == type_const_int || type == type_int) {
        address += 4;
    }

    return addr;
}

int getAddressByLabel(char * label) {
    struct Elem * tmp = pile;
    while(tmp != NULL) {
        if (!strcmp(tmp->label, label)) {
            return tmp->address;
        }
        tmp = tmp->suiv;
    }

    return -1;
}

int getAddressTopPile() {
    return pile->address;
}

void pushTmp() {
    push("tmp", type_int);
    nbTmp++;    
}

// test pile

/*int main() {
    push("toto", type_int);
    profondeur++;
    push("tata", type_int);
    push("titi", type_int);
    pop(0);

    //printf("pile : %s", pile->label);
}*/