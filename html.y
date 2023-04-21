%{
#include <stdio.h>
#include <stdlib.h>
#include "table.c"


int yylex (void);
void yyerror (const char *);

%}

%union
{
    int intValue;
    char * stringValue;
}


%token tMAIN tCONST tIF tELSE tWHILE tPRINTF tRETURN tINT tVOID tID tNB tADD tSUB tMUL tDIV tLOPERATOR tASSIGN tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA

%left tADD tSUB
%left tMUL tDIV
%left tASSIGN

%start Input

%%

Input :
    /* eps */ 
    | Input Function 
    ;

Function : 
    tVOID Declaration tLBRACE Content tRBRACE
    | tINT Declaration tLBRACE Content Return tSEMI tRBRACE
    ;

Declaration : 
    tID tLPAR Arg tRPAR 

Arg :
    /* eps */
    | tVOID
    | tINT tID 
    | tINT tID tCOMMA Arg
    ;

Content :
    | ContentDeclaration ContentInstruction

ContentDeclaration :
    /* eps */
    | tCONST tINT InitialisationConst tSEMI Content 
    | tINT InitialisationInt tSEMI Content 
    ;  

ContentInstruction :
    /* eps */
    | Affect tSEMI ContentInstruction           
    | tPRINTF tLPAR Val tRPAR tSEMI ContentInstruction 
    | tWHILE tLPAR LVal tRPAR tLBRACE Content tRBRACE ContentInstruction
    | tIF tLPAR LVal tRPAR tLBRACE Content tRBRACE ContentInstruction
    | tIF tLPAR LVal tRPAR tLBRACE Content tRBRACE tELSE tLBRACE Content tRBRACE ContentInstruction
    ;

Affect :
    tID tASSIGN Val {
        printf("COP %d %d\n", getAddressByLabel($<stringValue>1), popTmp());
        printPile();
    }
    ;

InitialisationInt :
    tID   {
        push($<stringValue>1, type_int);
    }
    | tID tASSIGN Val   {
        int tmp = popTmp();
        push($<stringValue>1, type_int);
        printf("COP %d %d\n", getAddressByLabel($<stringValue>1), tmp);
    }
    | InitialisationInt tCOMMA InitialisationInt
    ;

InitialisationConst :
    | tID tASSIGN Val   {
        int tmp = popTmp();
        push($<stringValue>1, type_const_int);
        printf("COP %d %d ", getAddressByLabel($<stringValue>1), tmp);
    }
    | InitialisationConst tCOMMA InitialisationConst
    ;

Val : 
    tID {
        printf("%s\n", $<stringValue>1);
        pushTmp();
        printf("COP %d %d\n", getAddressTopPile(), getAddressByLabel($<stringValue>1));
        }
    | tNB {
        printf("%d\n", $<intValue>1);
        pushTmp();
        printf("AFC %d %d\n", getAddressTopPile(), $<intValue>1);
        }
    | Val tADD Val {
        // +
            printf("%d + %d\n", $<intValue>1, $<intValue>3);
            printf("ADD %d %d %d\n", getAddressByLabel("tmp1"), getAddressByLabel("tmp1"), getAddressByLabel("tmp2"));
            popTmp();
        }
    | Val tMUL Val {
        // *
            printf("%d * %d\n", $<intValue>1, $<intValue>3);
            printf("MUL %d %d %d\n", getAddressByLabel("tmp1"), getAddressByLabel("tmp1"), getAddressByLabel("tmp2"));
            popTmp();
        }
    | Val tSUB Val {
        // -
            printf("%d - %d\n", $<intValue>1, $<intValue>3);
            printf("SUB %d %d %d\n", getAddressByLabel("tmp1"), getAddressByLabel("tmp1"), getAddressByLabel("tmp2"));
            popTmp();
        }
    | Val tDIV Val {
        // /
            printf("%d / %d\n", $<intValue>1, $<intValue>3);
            printf("DIV %d %d %d\n", getAddressByLabel("tmp1"), getAddressByLabel("tmp1"), getAddressByLabel("tmp2"));
            popTmp();
        }
    | tID tLPAR Parametre tRPAR 
    | tID tLPAR tRPAR 
    ;

LVal :
    Val 
    | Val tLOPERATOR Val 
    | LVal tLOPERATOR LVal 
    ;

Parametre :
    Val 
    | Val tCOMMA Parametre 
    ;

Return :
    tRETURN tLPAR Val tRPAR  
    | tRETURN Val 
    ;
%%

void yyerror(const char *msg) {
  fprintf(stderr, "error: %s\n", msg);
  exit(1);
}

int main(void) {
  yyparse();
}

