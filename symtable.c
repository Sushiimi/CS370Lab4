/*
******************************************************************************
*
*  Ian Johnson -- 2-14-2018 -- CS370 Lab4
*  Parts of this code pulled from: http://forgetcode.com/C/101-Symbol-table
*  This code implements a symbol table using a linked list-esqe data structure.
*  The code in its current form is meant to be utilized by YACC through
*  syntax-directed semantic action.
*
******************************************************************************
*/


// include statements for necessary code libraries
#include<stdio.h>
#include<conio.h>
#include<malloc.h>
#include<string.h>
#include<stdlib.h>

// Function prototypes
int size = 0;
int Search(char lab[]);
void Insert(char sym[], int STACKP);
int FetchAddr(char sym[]);

// Symbol table structures
struct SymbTab
{
    char symbol[10];
    int addr;
    struct SymbTab *next;
};
struct SymbTab *first, *last;


/*
****************************************************************
*
*  Search() function: searches symtable for a symbol specified
*  returns 1 flag if symbol is found, 0 flag if the symbol 
*  is not found.
*
****************************************************************
*/
int Search(char sym[])
{
    int i, flag = 0;
    struct SymbTab *p;
    p = first;
    for (i = 0; i < size; i++)
    {
        if (strcmp(p->symbol, sym) == 0)
            flag = 1;
        p = p->next;
    }
    return flag;
}


/*
***********************************************************
*
*  Insert() function: performs a check to make sure the
*  current symbol does not exist in the table. if symbol does
*  not exist, space is allocated for a struct and added to
*  the table.
*
***********************************************************
*/
void Insert(char sym[], int STACKP)
{
    struct SymbTab *p;
    p = malloc( sizeof( struct SymbTab ) );
    strcpy(p->symbol, sym);
    p->addr = STACKP;
    p->next = NULL;
    if (size == 0)
    {
        first = p;
        last = p;
    }
    else
    {
        last->next = p;
        last = p;
    }
    size++;
}

/*
************************************************************
* 
*  FetchAddr() function: gets address of specified symbol
*  from symbol table, returns the int value
*
************************************************************
*/
int FetchAddr(char sym[])
{
    int i, returnAddr;
    struct SymbTab *p;
    p = first;
    for (i = 0; i < size; i++)
    {
        if (strcmp(p->symbol, sym) == 0)
            returnAddr = p->addr;
        p = p->next;
    }
    return returnAddr;
}



