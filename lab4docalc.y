%{

/*
 *			        **** CALC ****
 *
 * This routine will function like a desk calculator
 *
 */

/* 
   This calculator depends on a LEX description which outputs either VARIABLE or INTEGER.
   The return type via yylval is integer 

   When we need to make yylval more complicated, we need to define a pointer type for yylval 
   and to instruct YACC to use a new type so that we can pass back better values
 
   The registers are based on 0, so we substract 'a' from each single letter we get.

   based on context, we have YACC do the correct memmory look up or the storage depending
   on position

   Shaun Cooper
   January 2015

   MODIFIED BY: Ian Johnson -- 2-15-2018
   Registers now handle any variable name through use with symtable.c program
   Additions to grammar now allows for variable declarations at beginning of input
   Utilizes symtable.c program for symbol table management and determining
   validity of variables in input

*/


/* begin specs */
#include <stdio.h>
#include <ctype.h>
#include "lex.yy.c"
#include "symtable.c"
#define MAXSTACK 26

int STACKP = 0;
int regs[MAXSTACK];
int base, debugsw;

void yyerror (s)  /* Called by yyparse on error, prints line number and error message */
     char *s;
{
  printf ("%s, line[%d]\n", s, lineno);
}


%}
/*  defines the start symbol, what values come back 
    from LEX, and how the operators are associated  
 */

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

/* 
	syntax requires that all declarations come at the beginning
	of the input (decls) in the form int <var>;
	cannot declare and assign value in the 
	same line (i.e. int <var> = <value>;)
	use of non-declared variables exits the program
*/
P       : decls list
		;

decls   : /* empty */
		| dec decls
		;


dec     : INT VARIABLE
			{
				/* Variable already defined, do nothing and continue parsing */
				if( Search($2) )
				{
					fprintf(stderr, "Yacc: ERROR on line [%d]: Variable [%s] already defined\n", lineno, $2);
				}
				/* Variable not defined, if insufficient register space available, 
				   do nothing and continue parsing, else insert into the symbol table */
				else
				{
					if( STACKP >= MAXSTACK )
					{
						fprintf(stderr,"Yacc: ERROR on line [%d]: no more register space\n", lineno);
					}
					else
					{
						Insert($2, STACKP);
						fprintf(stderr, "Yacc: Symbol [%s] added to symbol table, addr [%d]\n", $2, FetchAddr($2) );
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
				/* if symbol found, fetch address,
				   else terminate the program */
				if( Search($1) )
				{
					regs[FetchAddr($1)] = $3;
				}
				else
				{
					fprintf(stderr,"Yacc: ERROR on line[%d]: Variable [%s] not defined,\n", lineno - 1, $1);
					fprintf(stderr,"      TERMINATING PROGRAM\n");
					exit(0);
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
				/* if the variable has been defined, set $$ = addr of the variable */
				if( Search($1) )
				{
					$$ = regs[FetchAddr($1)]; 
					fprintf(stderr,"Yacc: Variable [%s] on line [%d] is defined\n", $1, lineno);
				}
				else
				{
					fprintf(stderr,"Yacc: ERROR on line[%d]: Variable [%s] not defined,\n      TERMINATING PROGRAM\n", lineno, $1);
					exit(0);
				}
			}
		|	INTEGER
			{
				$$=$1; 
				fprintf(stderr,"Yacc: Found an integer, value [%d]\n", $1);
			}
		;


%%	/* end of rules, start of program */

main()
{ 
	yyparse();
}
