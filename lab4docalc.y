%{

/*
 *			**** CALC ****
 *
 * This routine will function like a desk calculator
 * There are 26 integer registers, named 'a' thru 'z'
 *
 */

/* This calculator depends on a LEX description which outputs either VARIABLE or INTEGER.
   The return type via yylval is integer 

   When we need to make yylval more complicated, we need to define a pointer type for yylval 
   and to instruct YACC to use a new type so that we can pass back better values
 
   The registers are based on 0, so we substract 'a' from each single letter we get.

   based on context, we have YACC do the correct memmory look up or the storage depending
   on position

   Shaun Cooper
   January 2015

   problems  fix unary minus, fix parenthesis, add multiplication
   problems  make it so that verbose is on and off with an input argument instead of compiled in
*/


/* begin specs */
#include <stdio.h>
#include <ctype.h>
#include "lex.yy.c"
#include "symtable.c"
#define MAXSTACK 3

int STACKP = 0;
int regs[MAXSTACK];
int base, debugsw;

void yyerror (s)  /* Called by yyparse on error */
     char *s;
{
  printf ("%s, line[%d]\n", s, lineno);
}


%}
/*  defines the start symbol, what values come back from LEX and how the operators are associated  */

/*%start P*/
%start P

%union
{
	int value;
	char * string;
}

%token INT
%token <value> INTEGER
%token <string> VARIABLE
%type <value> expr stat

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS


%%	/* end specs, begin rules */

P       : decls list
		;

decls   : /* empty */
		| dec decls
		;


dec     : INT VARIABLE
			{
				if( Search($2) == 1)
				{
					fprintf(stderr, "Yacc: Error on line [%d]: Symbol [%s] already defined\n", lineno, $2);
				}
				else
				{
					if( STACKP >= MAXSTACK )
					{
						fprintf(stderr,"Yacc: Error on line [%d]: no more register space\n", lineno);
					}
					else
					{
						Insert($2, STACKP);
						fprintf(stderr, "Yacc: Symbol [%s] added to symbol table at addr [%d]\n", $2, FetchAddr($2) );
						STACKP++;
					}/* end inside if else block */

				}/* end outside if else block */

			}
		';' '\n'
		;


list	:	/* empty */
		|	list stat '\n'
		|	list error '\n'
			{ yyerrok; }
		;

stat	:	expr
			{ 
				fprintf(stderr,"The answer is %d\n\n", $1); 
			}

		|	VARIABLE '=' expr
			{ 
				if( Search($1) ){
					/* found symbol, */
					regs[FetchAddr($1)] = $3;
				}
				else
				{
					fprintf(stderr, "Yacc: Error: Variable [%s] not defined\n", $1);
				}
			}
		;


expr	:	'(' expr ')'
			{ $$ = $2; }
		|	expr '-' expr
			{ $$ = $1 - $3; }
		|	expr '+' expr
			{ $$ = $1 + $3; }
		|	expr '/' expr
			{ $$ = $1 / $3; }
    	|   expr '*' expr
            { $$ = $1 * $3; }
		|	expr '%' expr
			{ $$ = $1 % $3; }
		|	expr '&' expr
			{ $$ = $1 & $3; }
		|	expr '|' expr
			{ $$ = $1 | $3; }
		|	'-' expr	%prec UMINUS
			{ $$ = -$2; }
		|	VARIABLE
			{   
				if(Search($1))
				{
					$$ = regs[FetchAddr($1)]; 
					fprintf(stderr,"Yacc: Found a variable [%s]\n",$1); 
			    }
			    else
			    {
					fprintf(stderr, "Yacc: Error: Variable [%s] not defined, line [%d]\n", $1, lineno);
			    }
			}
		|	INTEGER {$$=$1; fprintf(stderr,"Yacc: Found an integer, value = %d\n", $1);}
		;


%%	/* end of rules, start of program */

main()
{ yyparse();
}
