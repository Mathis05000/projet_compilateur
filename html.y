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


%token tMAIN tCONST tIF tELSE tWHILE tPRINTF tRETURN tINT tVOID tID tNB tOP tLOPERATOR tASSIGN tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA

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
        printf("COP %s %s", $<stringValue>1, )
    }
    ;

InitialisationInt :
    tID   {
        push($<stringValue>1, type_int);
    }
    | tID tASSIGN Val   {
        push($<stringValue>1, type_int);
        printf("AFC %s %d\n", $<stringValue>1, $<intValue>3);
    }
    | InitialisationInt tCOMMA InitialisationInt
    ;

InitialisationConst :
    | tID tASSIGN Val   {
        push($<stringValue>1, type_const_int);
        printf("AFC %s %d ", $<stringValue>1, $<intValue>3);
    }
    | InitialisationConst tCOMMA InitialisationConst
    ;

Val : 
    tID {
        char * tmp = strcat("tmp", $<stringValue>1);
        push(tmp, type_int);
        printf("COP %d %d", getAddressByLabel(tmp), getAddressByLabel($<stringValue>1));
        $$ = tmp;
        }
    | tNB {
        //char * tmp = strcat("tmp", $<stringValue>1);
        push("tmp2", type_int);
        printf("AFC %d %d", getAddressByLabel("tmp2"), $<intValue>1)
        $$ = "tmp2";
        }
    | Val tOP Val {
        // +
        if ($<intValue>2 == 1) {
            printf("ADD %d %d %d", getAddressByLabel($<stringValue>1), getAddressByLabel($<stringValue>1), getAddressByLabel($<stringValue>1))
        }
        // *
        if ($<intValue>2 == 2) {
            
        }
        // -
        if ($<intValue>2 == 3) {
            
        }
        // /
        if ($<intValue>2 == 4) {
            
        }
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
  push("r1", type_int);
  push("r2", type_int);
  push("r3", type_int);
}

