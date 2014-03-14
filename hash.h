#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define hashSize 5013

#define HASH_ID 1
#define HASH_INTEGER 2

typedef struct hash_node
{
	char *text;
	int type;
	struct hash_node *next;
} Hash_Node;

Hash_Node *table[hashSize];

void initMe();
int hashAddress(char*);
Hash_Node* hashFind(char*);
void hashInsert(char*, int);
void hashPrint();

