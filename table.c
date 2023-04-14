#include <stdio.h>
#include <stdlib.h>
#include "table.h"

typedef struct Elem* Pile;

void push(Pile * pile, struct Elem * elem) {
    elem->suiv = *pile;
    *pile = elem;
}

void pop(Pile * pile) {
    *pile = (*pile)->suiv;
}

// test pile

int main() {
    struct Elem * elem1;

    elem1 = malloc(sizeof(struct Elem));
    elem1->label = "toto";
    elem1->profondeur = 1;

    Pile * pile = &elem1;

    printf("pile : %s\n", (*pile)->label);

    struct Elem * elem2;

    elem2 = malloc(sizeof(struct Elem));
    elem2->label = "tata";
    elem2->profondeur = 2;

    push(pile, elem2);

    printf("pile : %s\n", (*pile)->label);

    pop(pile);

    printf("pile : %s\n", (*pile)->label);
}