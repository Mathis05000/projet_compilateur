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
    tVOID {printf("Arg\n")}
    | tINT tID {printf("Arg\n")}
    | tINT tID tCOMMA Arg {printf("Arg\n")}
    ;

Content :
    | ContentDeclaration ContentInstruction

ContentDeclaration :
    /* eps */
    | tCONST tINT InitialisationConst tSEMI Content {printf("Content INIT\n")}
    | tINT InitialisationInt tSEMI Content {printf("Content INIT\n")}
    ;  

ContentInstruction :
    /* eps */
    | Affect tSEMI ContentInstruction             {printf("Content AFFECT\n")}
    | tPRINTF tLPAR Val tRPAR tSEMI ContentInstruction {printf("%d\n", $<intValue>3)}
    | tWHILE tLPAR LVal tRPAR tLBRACE Content tRBRACE ContentInstruction{printf("Content While\n")}
    | tIF tLPAR LVal tRPAR tLBRACE Content tRBRACE ContentInstruction{printf("Content IF\n")}
    | tIF tLPAR LVal tRPAR tLBRACE Content tRBRACE tELSE tLBRACE Content tRBRACE ContentInstruction{printf("Content IF ELSE\n")}
    ;

Affect :
    tID tASSIGN Val  {printf("tID tASSIGN \n")}
    ;

InitialisationInt :
    tID   {
        push($<stringValue>1, type_int);
    }
    | tID tASSIGN Val   {
        push($<stringValue>1, type_int);
        printf("AFC %s %d ", $<stringValue>1, $<intValue>3);
    }
    | InitialisationInt tCOMMA InitialisationInt {printf("Initialisation\n")}
    ;

InitialisationConst :
    | tID tASSIGN Val   {printf("tID tASSIGN Val\n")}
    | InitialisationConst tCOMMA InitialisationConst {printf("Initialisation\n")}
    ;

Val : 
    tID {printf("Val 1  \n")}
    | tNB {printf("Val 2 \n")}
    | Val tOP Val { printf("$1\n")}
    | tID tLPAR Parametre tRPAR {printf("Val 4\n")}
    | tID tLPAR tRPAR {printf("Val 4\n")}
    ;

LVal :
    Val {printf("LVal\n")}
    | Val tLOPERATOR Val {printf("LVal\n")}
    | LVal tLOPERATOR LVal {printf("LVal\n")}
    ;

Parametre :
    Val  {printf("Parametre Val\n")} 
    | Val tCOMMA Parametre {printf("Parametre\n")} 
    ;

Return :
    tRETURN tLPAR Val tRPAR  {printf("Return\n")}
    | tRETURN Val {printf("Return\n")}
    ;
%%

void yyerror(const char *msg) {
  fprintf(stderr, "error: %s\n", msg);
  exit(1);
}

int main(void) {
  yyparse();
}

