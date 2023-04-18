#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table.h"

typedef struct Elem* Pile;

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
}

void pop(int profondeur) {
    int run = 1;
    while(pile != NULL && pile->profondeur >= profondeur) {
        pile = pile->suiv;
    }
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
        if (strcmp(tmp->label, label)) {
            return tmp->address;
        }
    }

    return -1;
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