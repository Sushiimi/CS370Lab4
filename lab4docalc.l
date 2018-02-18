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

    Edited by Ian Johnson -- 1-27-2018
    Added  parenthesis() to 4th rule to correctly handle opening and closing
    parenthesis in input expressions (made them a token)

*/

int mydebug = 1;
int lineno = 1;
#include "y.tab.h"
#include <stdio.h>
#include <string.h>

%}


%%

"int"                   { if (mydebug) fprintf(stderr, "Reserved Word found\n");
                            return(INT);}

[a-zA-Z][a-zA-Z|0-9]*   { if (mydebug) fprintf(stderr,"Variable Name found\n");
                            yylval.string = strdup(yytext); 
                            return(VARIABLE);}


[0-9][0-9]*             { if (mydebug) fprintf(stderr,"Digit found\n"); 
                            yylval.value = atoi((const char *)yytext);
                            return(INTEGER);}


[ \t]                   { if (mydebug) fprintf(stderr,"Whitespace found\n"); }


[=\-+*/%&|()]           { if (mydebug) fprintf(stderr,"return a token %c\n",*yytext); 
                            return (*yytext);}

[;]                     { if (mydebug) fprintf(stderr,"semi-colon found");
                            return (*yytext);}


\n                      { if (mydebug) fprintf(stderr,"cariage return %c\n",*yytext);
                            ++lineno;
                            printf("\n"); 
                            return (*yytext);}

%%

int yywrap(void)
{ return 1; }


