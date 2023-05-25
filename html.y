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
    | Input Function {
        FILE *fichier = fopen("assembleur.txt", "w");
        if (fichier == NULL) {
            printf("Erreur lors de l'ouverture du fichier\n");
            return 1;
        }
        for (int i = 0; i < indexInst; i++) {
            fprintf(fichier, "%s", instruction[i]);
        }
        

        fclose(fichier);
    }
    ;

Function : 
    AddProfondeur tVOID Declaration tLBRACE Content tRBRACE Pop End
    | AddProfondeur tINT Declaration tLBRACE Content Return tSEMI tRBRACE Pop End
    ;

End:
    {
        char instruction[100];
        sprintf(instruction, "E\n");
        pushInstruction(instruction);
    }

Declaration : 
    tID {
        pushFunction($<stringValue>1);
    } tLPAR Arg tRPAR 

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
    | CallFunction tSEMI ContentInstruction 
    | Affect tSEMI ContentInstruction           
    | tPRINTF tLPAR Val tRPAR tSEMI ContentInstruction {
        char instruction[100];
        sprintf(instruction, "C %d\n", popTmp());
        pushInstruction(instruction);
    }
    | tWHILE tLPAR LVal tRPAR AddProfondeur tLBRACE Content tRBRACE Pop ContentInstruction
    | tIF tLPAR LVal tRPAR aPJMP AddProfondeur tLBRACE Content tRBRACE Pop aMJMP ContentInstruction
    | tIF tLPAR LVal tRPAR aPJMP AddProfondeur tLBRACE Content tRBRACE Pop tELSE aJMPE AddProfondeur tLBRACE Content tRBRACE Pop aMJMP ContentInstruction
    ;

CallFunction:
    tID tLPAR tRPAR {
        char instruction[100];
        sprintf(instruction, "D %d\n", indexInst + 1);
        pushInstruction(instruction);
        sprintf(instruction, "7 %d\n", findFunction($<stringValue>1));
        pushInstruction(instruction);
    }
    ;
AddProfondeur:
    {
        profondeur++;
    }

Pop:
    {
        pop();
    }
aPJMP:
    {
        char instruction[100];
        sprintf(instruction, "8 %d ?\n", popTmp());
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
        sprintf(instruction, "7 ?\n");
        pushIf(indexInst);
        pushInstruction(instruction);
    }

Affect :
    tID tASSIGN Val {
        char instruction[100];
        sprintf(instruction, "5 %d %d\n", getAddressByLabel($<stringValue>1), popTmp());
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
        sprintf(instruction, "5 %d %d\n", getAddressByLabel($<stringValue>1), tmp);
        pushInstruction(instruction);
    }
    | InitialisationInt tCOMMA InitialisationInt
    ;

InitialisationConst : 
    tID tASSIGN Val   {
        int tmp = popTmp();
        push($<stringValue>1, type_const_int);
        char instruction[100];
        sprintf(instruction, "5 %d %d ", getAddressByLabel($<stringValue>1), tmp);
        pushInstruction(instruction);
    }
    | InitialisationConst tCOMMA InitialisationConst
    ;

Val : 
    tID {
        printf("%s\n", $<stringValue>1);
        pushTmp();
        char instruction[100];
        sprintf(instruction, "5 %d %d\n", getAddressTopPile(), getAddressByLabel($<stringValue>1));
        pushInstruction(instruction);
        }
    | tNB {
        printf("%d\n", $<intValue>1);
        pushTmp();
        char instruction[100];
        sprintf(instruction, "6 %d %d\n", getAddressTopPile(), $<intValue>1);
        pushInstruction(instruction);
        }
    | Val tADD Val {
        // +
            int tmp = popTmp();
            printf("%d + %d\n", $<intValue>1, $<intValue>3);
            char instruction[100];
            sprintf(instruction, "1 %d %d %d\n", getAddressTopPile(), getAddressTopPile(), tmp);
            pushInstruction(instruction);
        }
    | Val tMUL Val {
        // *
            int tmp = popTmp();
            printf("%d * %d\n", $<intValue>1, $<intValue>3);
            char instruction[100];
            sprintf(instruction, "2 %d %d %d\n", getAddressTopPile(), getAddressTopPile(), tmp);
            pushInstruction(instruction);
        }
    | Val tSUB Val {
        // -
            int tmp = popTmp();
            printf("%d - %d\n", $<intValue>1, $<intValue>3);
            char instruction[100];
            sprintf(instruction, "3 %d %d %d\n", getAddressTopPile(), getAddressTopPile(), tmp);
            pushInstruction(instruction);
        }
    | Val tDIV Val {
        // /
            int tmp = popTmp();
            printf("%d / %d\n", $<intValue>1, $<intValue>3);
            char instruction[100];
            sprintf(instruction, "4 %d %d %d\n", getAddressTopPile(), getAddressTopPile(), tmp);
            pushInstruction(instruction);
        }
    | tID tLPAR Parametre tRPAR 
    | tID tLPAR tRPAR 
    ;

LVal :
    | Val tEQU Val {
        int tpm1 = popTmp();
        int tmp2 = popTmp();
        pushTmp();
        char instruction[100];
        sprintf(instruction, "B %d %d %d\n", getAddressTopPile(), tpm1, tmp2);
        pushInstruction(instruction);
    }
    | Val tSUP Val {
        int tpm1 = popTmp();
        int tmp2 = popTmp();
        pushTmp();
        char instruction[100];
        sprintf(instruction, "A %d %d %d\n", getAddressTopPile(), tpm1, tmp2);
        pushInstruction(instruction);
    }
    | Val tINF Val {
        int tpm1 = popTmp();
        int tmp2 = popTmp();
        pushTmp();
        char instruction[100];
        sprintf(instruction, "9 %d %d %d\n", getAddressTopPile(), tpm1, tmp2);
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

