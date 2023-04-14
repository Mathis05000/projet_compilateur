enum Type {
    type_int,
    type_const_int
    type_char
};

struct Elem {
    char * label;
    int profondeur;
    int * address;
    enum Type type;
    struct Elem * suiv;
};

typedef struct Elem* Pile;

void push(Pile * pile, struct Elem * elem);

void pop(Pile * pile);