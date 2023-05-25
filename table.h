enum Type {
    type_int,
    type_const_int,
    type_char
};

struct Elem {
    char * label;
    int profondeur;
    int address;
    enum Type type;
    struct Elem * suiv;
};

typedef struct Elem* Pile;

struct ElemPile{
    Pile pile;
    Pile suiv;
};

typedef struct ElemPile* GlobalPile;

void push(char * label, enum Type type);

void pop();

int getAddress(enum Type type);

int getNewAddress(enum Type type);

int getAddressByLabel(char * label);

void pushPile(Pile tmpPile);

void popPile();

Pile pile;

GlobalPile globalPile;

int profondeur = 0;

int address = 0;

int nbTmp = 0;

// gestion if else
char * instruction[100];
int indexInst = 0;
int baseInst = 0;

int tabAddrIf[100];
int indexIf = 0;

struct Function {
    char * name;
    int line;
    struct Function * suiv;
};

typedef struct Function * PileFunction;

PileFunction pileFunction;


