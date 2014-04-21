#ifndef HASH_H
#define HASH_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define hashSize 5013

//#define HASH_ID 1
//#define HASH_INTEGER 2

#define SYMBOL_UNDEFINED 0 
#define SYMBOL_LIT_INTEGER 1 
#define SYMBOL_LIT_FLOATING 2 
#define SYMBOL_LIT_TRUE 3 
#define SYMBOL_LIT_FALSE 4 
#define SYMBOL_LIT_CHAR 5 
#define SYMBOL_LIT_STRING 6 
#define SYMBOL_IDENTIFIER 7

typedef struct hash_node Hash_Node;

struct hash_node
{
	char *text;
	int type;
	struct hash_node *next;
};

Hash_Node *table[hashSize];

void initMe();
int hashAddress(char*);
Hash_Node* hashFind(char*);
Hash_Node* hashInsert(char*, int);
void hashPrint();

#endif