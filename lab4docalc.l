/*                 Small LEX routine which returns two formal tokens (INTEGER and VARIABLE)
*                  along with single string elements like '+'.
*
*                   This LEX definition is the companion to the docalc.y YACC routine which
*                  is a simple calculator

                    Shaun Cooper
                    January 2015
*/
%{
/* 
    Edited by Ian Johnson -- 2-15-2018
    Added token for reserved work "int", added token for semi-colon,
    added lineno count for printing and debug printing 
*/

int mydebug = 1;
int lineno = 1;
#include "y.tab.h"
#include <stdio.h>
#include <string.h>

%}


%%

"int"                   { if (mydebug) fprintf(stderr, "Lex: Reserved word 'int' found, line [%d] \n", lineno);
                            return(INT);}

[a-zA-Z][a-zA-Z|0-9]*   { if (mydebug) fprintf(stderr,"Lex: Variable name found [%s], line [%d] \n", yytext, lineno);
                            yylval.string = strdup(yytext); 
                            return(VARIABLE);}


[0-9][0-9]*             { if (mydebug) fprintf(stderr,"Lex: Digit found, line [%d]\n", lineno); 
                            yylval.value = atoi((const char *)yytext);
                            return(INTEGER);}


[ \t]                   { if (mydebug) fprintf(stderr,"Lex: Whitespace found\n"); }


[=\-+*/%&|()]           { if (mydebug) fprintf(stderr,"Lex: Returning token: '%c', line [%d]\n",*yytext, lineno); 
                            return (*yytext);}

[;]                     { if (mydebug) fprintf(stderr,"Lex: Semi-colon found\n");
                            return (*yytext);}


\n                      { if (mydebug) fprintf(stderr,"Lex: Carriage return reached %c\n",*yytext);
                            ++lineno;
                            return (*yytext);}

%%

int yywrap(void)
{ return 1; }


