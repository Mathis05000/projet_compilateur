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


%token tMAIN tCONST tIF tELSE tWHILE tPRINTF tRETURN tINT tVOID tID tNB tADD tSUB tMUL tDIV tSUP tINF tEQU tNEQU tSUPEQU tINFEQU tLOPERATOR tASSIGN tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA
%left tCOMMA
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

Content : ContentDeclaration ContentInstruction

ContentDeclaration :
    /* eps */
    | tCONST tINT InitialisationConst tSEMI ContentDeclaration
    | tINT InitialisationInt tSEMI ContentDeclaration
    ;  

ContentInstruction :
    /* eps */
    | Affect tSEMI ContentInstruction           
    | tPRINTF tLPAR Val tRPAR tSEMI ContentInstruction 
    | tWHILE tLPAR LVal tRPAR tLBRACE Content tRBRACE ContentInstruction
    | tIF tLPAR LVal tRPAR aPJMP tLBRACE Content tRBRACE aMJMP ContentInstruction
    | tIF tLPAR LVal tRPAR aPJMP tLBRACE Content tRBRACE tELSE aJMPE tLBRACE Content tRBRACE aMJMP ContentInstruction
    ;
aPJMP:
    {
        char instruction[100];
        sprintf(instruction, "JMF %d ?\n", popTmp());
        pushIf(indexInst);
        pushInstruction(instruction);
        
    } 

aMJMP:
    {
        modifInstruction();
    }

aJMPE:
    {
        modifInstructionElse();
        char instruction[100];
        sprintf(instruction, "JMP ?\n");
        pushIf(indexInst);
        pushInstruction(instruction);
    }

Affect :
    tID tASSIGN Val {
        char instruction[100];
        sprintf(instruction, "COP %d %d\n", getAddressByLabel($<stringValue>1), popTmp());
        pushInstruction(instruction);
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
        char instruction[100];
        sprintf(instruction, "COP %d %d\n", getAddressByLabel($<stringValue>1), tmp);
        pushInstruction(instruction);
    }
    | InitialisationInt tCOMMA InitialisationInt
    ;

InitialisationConst : 
    tID tASSIGN Val   {
        int tmp = popTmp();
        push($<stringValue>1, type_const_int);
        char instruction[100];
        sprintf(instruction, "COP %d %d ", getAddressByLabel($<stringValue>1), tmp);
        pushInstruction(instruction);
    }
    | InitialisationConst tCOMMA InitialisationConst
    ;

Val : 
    tID {
        printf("%s\n", $<stringValue>1);
        pushTmp();
        char instruction[100];
        sprintf(instruction, "COP %d %d\n", getAddressTopPile(), getAddressByLabel($<stringValue>1));
        pushInstruction(instruction);
        }
    | tNB {
        printf("%d\n", $<intValue>1);
        pushTmp();
        char instruction[100];
        sprintf(instruction, "AFC %d %d\n", getAddressTopPile(), $<intValue>1);
        pushInstruction(instruction);
        }
    | Val tADD Val {
        // +
            int tmp = popTmp();
            printf("%d + %d\n", $<intValue>1, $<intValue>3);
            char instruction[100];
            sprintf(instruction, "ADD %d %d %d\n", getAddressTopPile(), getAddressTopPile(), tmp);
            pushInstruction(instruction);
        }
    | Val tMUL Val {
        // *
            int tmp = popTmp();
            printf("%d * %d\n", $<intValue>1, $<intValue>3);
            char instruction[100];
            sprintf(instruction, "MUL %d %d %d\n", getAddressTopPile(), getAddressTopPile(), tmp);
            pushInstruction(instruction);
        }
    | Val tSUB Val {
        // -
            int tmp = popTmp();
            printf("%d - %d\n", $<intValue>1, $<intValue>3);
            char instruction[100];
            sprintf(instruction, "SUB %d %d %d\n", getAddressTopPile(), getAddressTopPile(), tmp);
            pushInstruction(instruction);
        }
    | Val tDIV Val {
        // /
            int tmp = popTmp();
            printf("%d / %d\n", $<intValue>1, $<intValue>3);
            char instruction[100];
            sprintf(instruction, "DIV %d %d %d\n", getAddressTopPile(), getAddressTopPile(), tmp);
            pushInstruction(instruction);
        }
    | tID tLPAR Parametre tRPAR 
    | tID tLPAR tRPAR 
    ;

LVal :
    | Val tEQU Val {
        printf("%d == %d\n", $<intValue>1, $<intValue>3);
        int tpm1 = popTmp();
        int tmp2 = popTmp();
        pushTmp();
        char instruction[100];
        sprintf(instruction, "EQU %d %d %d\n", getAddressTopPile(), tpm1, tmp2);
        pushInstruction(instruction);
    }
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

