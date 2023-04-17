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

void push(char * label, enum Type type);

void pop(int profondeur);

int getAddress(enum Type type);

Pile pile;

int profondeur = 0;

int address = 0;