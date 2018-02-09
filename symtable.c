/*
******************************************************************************
*
*  Ian Johnson -- 2-2-2018 -- CS370 Lab3
*  Code pulled from: http://forgetcode.com/C/101-Symbol-table
*  This code implements a symbol table using a linked list-esqe data structure. 
*  The table is searchable and has several manipulative functions. Comments
*  have been added to describe the basic structure and implementations of
*  the various functions.
*
******************************************************************************
*/


// include statements for necessary code libraries
#include<stdio.h>
/* #include<conio.h> */
#include<malloc.h>
#include<string.h>
#include<stdlib.h>

/*
***************************
*  Function prototypes
***************************
*/
int size = 0;
void Insert();
void Display();
void Delete();
int Search(char lab[]);
void Modify();

// Symbol table structures
struct SymbTab
{
    char symbol[10];
    int addr;
    struct SymbTab *next;
};
struct SymbTab *first, *last;


/*
********************************************************************
*
*  main() function: displays the available options to the user,
*  gets input from the user (which option they would like to use),
*  and then calls the corresponding symbol table function based on
*  that input.
*  
********************************************************************
*/
/*void main()
{
    int op, y;
    char la[10];
    do
    {
        printf("\n\tSYMBOL TABLE IMPLEMENTATION\n");
        printf("\n\t1.INSERT\n\t2.DISPLAY\n\t3.DELETE\n\t4.SEARCH\n\t5.MODIFY\n\t6.END\n");
        printf("\n\tEnter your option : ");
        scanf( "%d", &op );
        switch (op)
        {
        case 1:
            Insert();
            break;
        case 2:
            Display();
            break;
        case 3:
            Delete();
            break;
        case 4:
            printf("\n\tEnter the symbol to be searched : ");
            scanf("%s", la);
            y = Search(la);
            printf("\n\tSearch Result:");
            if (y == 1)
                printf("\n\tThe symbol is present in the symbol table\n");
            else
                printf("\n\tThe symbol is not present in the symbol table\n");
            break;
        case 5:
            Modify();
            break;
        case 6:
            exit(0);
        }
    } while (op < 6);

}  *//* and of main */


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
void Insert()
{
    int n;
    char l[10];
    printf("\n\tEnter the symbol : ");
    scanf("%s", l);
    n = Search(l);
    if (n == 1)
        printf("\n\tThe symbol exists already in the symbol table\n\tDuplicate can.t be inserted");
    else
    {
        struct SymbTab *p;
        p = malloc( sizeof( struct SymbTab ) );
        printf( "\n\tEnter the symbol : " );
        scanf( "%s", p->symbol );
        printf( "\n\tEnter the address : " );
        scanf( "%d", &p->addr );
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
    printf("\n\tSymbol inserted\n");
}


/*
*********************************************************
*
*  Display() function: displays the entire symbol table
*  in its current state.
*
*********************************************************
*/
void Display()
{
    int i;
    struct SymbTab *p;
    p = first;
    printf("\n\tSYMBOL\t\tADDRESS\n");
    for (i = 0; i < size; i++)
    {
        printf("\t%s\t\t%d\n", p->symbol, p->addr);
        p = p->next;
    }
}


/*
****************************************************************
*
*  Search() function: searches symtable for a symbol specified
*  by the user. returns 1 if symbol is found, 0 if the symbol 
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
*  Delete() function: deletes a struct by manipulating
*  the next* value of the struct in the table prior to
*  the one being deleted to point to the struct following
*  the one being deleted (leaving the deleted struct 
*  stranded without anything pointing to it)
*
***********************************************************
*/
void Delete()
{
    int a;
    char l[10];
    struct SymbTab *p, *q;
    p = first;
    printf("\n\tEnter the symbol to be deleted : ");
    scanf("%s", l);
    a = Search(l);
    if (a == 0)
        printf("\n\tSymbol not found\n");
    else
    {
        if (strcmp(first->symbol, l) == 0)
            first = first->next;
        else if (strcmp(last->symbol, l) == 0)
        {
            q = p->next;
            while (strcmp(q->symbol, l) != 0)
            {
                p = p->next;
                q = q->next;
            }
            p->next = NULL;
            last = p;
        }
        else
        {
            q = p->next;
            while (strcmp(q->symbol, l) != 0)
            {
                p = p->next;
                q = q->next;
            }
            p->next = q->next;
        }
        size--;
        printf("\n\tAfter Deletion:\n");
        Display();
    }
}

