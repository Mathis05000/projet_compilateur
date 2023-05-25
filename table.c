#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table.h"

void printInstruction();

void printPile()
{
    printf("####### Pile #######\n");
    struct Elem *tmp = pile;
    while (tmp != NULL)
    {
        printf("%s : %d\n", tmp->label, tmp->address);
        tmp = tmp->suiv;
    }

    printf("#######     #######\n");
}
void push(char *label, enum Type type)
{
    struct Elem *elem;
    elem = malloc(sizeof(struct Elem));
    elem->label = label;
    elem->address = getNewAddress(type);
    elem->profondeur = profondeur;
    elem->type = type;

    if (pile != NULL)
    {
        elem->suiv = pile;
    }
    pile = elem;

    printPile();
}

void pop()
{
    int run = 1;
    while (pile != NULL && pile->profondeur >= profondeur)
    {
        printf("loop\n");
        pile = pile->suiv;
    }
    profondeur--;
}

int popTmp()
{
    int tmp = pile->address;
    if (nbTmp > 0)
    {
        pile = pile->suiv;
        nbTmp--;
    }
    return tmp;
}

// take address and increment

int getNewAddress(enum Type type)
{
    int addr = address;

    if (type == type_const_int || type == type_int)
    {
        address += 4;
    }

    return addr;
}

int getAddressByLabel(char *label)
{
    struct Elem *tmp = pile;
    while (tmp != NULL)
    {
        if (!strcmp(tmp->label, label))
        {
            return tmp->address;
        }
        tmp = tmp->suiv;
    }

    printf("error instruction assembleur ligne : %d\n", indexInst);
    perror("variable inconnu");
    exit(1);
}

int getAddressTopPile()
{
    return pile->address;
}

void pushTmp()
{
    push("tmp", type_int);
    nbTmp++;
}

void pushInstruction(char *i)
{
    instruction[indexInst] = malloc(sizeof(char) * 50);
    strcpy(instruction[indexInst++], i);
    printf("%s\n", i);
}

void pushIf(int addr)
{
    tabAddrIf[indexIf++] = addr;
}

void modifInstruction()
{
    char *tmp = instruction[tabAddrIf[--indexIf]];
    for (int i = 0; i < strlen(tmp); i++)
    {
        if (tmp[i] == '?')
        {
            char buf[4];
            sprintf(buf, "%d", indexInst);
            for (int j = 0; j < strlen(buf); j++)
            {
                tmp[i + j] = buf[j];
                tmp[i + j + 1] = '\n';
            }
        }
    }
    printInstruction();
}

void modifInstructionElse()
{
    char *tmp = instruction[tabAddrIf[--indexIf]];
    for (int i = 0; i < strlen(tmp); i++)
    {
        if (tmp[i] == '?')
        {
            char buf[4];
            sprintf(buf, "%d", indexInst + 1);
            for (int j = 0; j < strlen(buf); j++)
            {
                tmp[i + j] = buf[j];
                tmp[i + j + 1] = '\n';
            }
        }
    }
}

void printInstruction()
{
    printf("##### instruction #####\n");
    for (int i = 0; i < indexInst; i++)
    {
        printf("%d %s\n", i, instruction[i]);
    }
    printf("#####  #####\n");
}

void pushFunction(char * name) {
    struct Function * function;
    function = malloc(sizeof(struct Function));
    function->line = indexInst;
    function->name = name;
    if (pileFunction != NULL) {
        function->suiv = pileFunction;
    }
    pileFunction = function;   
}

int findFunction(char * name) {
    struct Function *tmp = pileFunction;
    while (tmp != NULL)
    {
        if (!strcmp(tmp->name, name))
        {
            return tmp->line;
        }
        tmp = tmp->suiv;
    }

    printf("error instruction assembleur ligne : %d\n", indexInst);
    perror("variable inconnu");
    exit(1);
}


/*// gestion des fonction

void pushPile(Pile tmpPile)
{
    if (globalPile == NULL)
    {
        struct ElemPile *elemPile;
        elemPile = malloc(sizeof(struct ElemPile));
        elemPile->pile = pile;
        elemPile->suiv = NULL;
        globalPile = elemPile;
    }
    struct ElemPile *elemPile;
    elemPile = malloc(sizeof(struct ElemPile));
    elemPile->pile = tmpPile;
    elemPile->suiv = globalPile;

    globalPile = elemPile;
    pile = tmpPile;
}

void popPile()
{
    globalPile = globalPile->suiv;
    pile = globalPile->pile;
}*/

