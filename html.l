%option noyywrap
%option noinput
%option nounput

%{
#include "html.tab.h"
%}


IDENTIFIERS  [a-zA-Z]([a-zA-Z0-9]|_)*
INTEGERS      0x[0-9a-f]*|[0-9]+|[0-9]+e[0-9]+
COMMENT      "//".*\n|"/*"(.|\n)*"*/"
ENDLINE      [ ]*\n



%%

" "

{ENDLINE}

{COMMENT}


"if"          {
                return(tIF);
              }

"else"        {
                return(tELSE);
              }

"while"       {
                return(tWHILE);
              }

"printf"      {
                return(tPRINTF);
              }

"return"      {
                return(tRETURN);
              }

"int"         {
                return(tINT);
              }

"void"        {
                return(tVOID);
              }

"main"        {
                return(tMAIN);
              }

"const"       {
                return(tCONST);
              }

{IDENTIFIERS} {
                yylval.stringValue = strdup(yytext);
                return(tID);
              }

{INTEGERS}    {
                yylval.intValue = atoi(yytext);
                return(tNB);
              }

"+"           {
                return(tOP);
              }

"-"           {
                return(tOP);
              }

"*"           {
                return(tOP);
              }

"/"           {
                return(tOP);
              }

"<"           {
                return(tLOPERATOR);
              }

">"           {
                return(tLOPERATOR);
              }

"!="          {
                return(tLOPERATOR);
              }

"=="          {
                return(tLOPERATOR);
              }

">="          {
                return(tLOPERATOR);
              }

"<="          {
                return(tLOPERATOR);
              }

"="           {
                return(tASSIGN);
              }

"&&"          {
                return(tLOPERATOR);
              }

"||"          {
                return(tLOPERATOR);
              }

"{"           {
                return(tLBRACE);
              }

"}"           {
                return(tRBRACE);
              }

"("           {
                return(tLPAR);
              }

")"           {
                return(tRPAR);
              }

";"           {
                return(tSEMI);
              }

","           {
                return(tCOMMA);
              }

.	      {
		printf( "tERROR\n");
	      }

%%