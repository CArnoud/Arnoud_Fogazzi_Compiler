#include "hash.h"

void initMe()
{
	int i;
	for(i = 0; i < hashSize; i++)
	{
		table[i] = NULL;
	}
}

int hashAddress(char *text)
{
	int i, address=1;
	for (i=0; i < strlen(text); i++)
	{
		address = (address * text[i]) % hashSize + 1;
	}
	return address-1;
}

Hash_Node* hashFind(char *text)
{
	int address;
	address = hashAddress(text);
	Hash_Node *node = table[address];
	while(node != NULL)
	{
		if (!strcmp(node->text,text))
			return node;
		node = node->next;			
	}
	return NULL;
}

void hashInsert(char *text, int token)
{
	int address;
	if (hashFind(text) == NULL)
	{
		address = hashAddress(text);
		Hash_Node *node = calloc(1,sizeof(Hash_Node));
		node->text = calloc(strlen(text), sizeof(char));
		strcpy(node->text,text);
		node->type = token;
		node->next = table[address];
		table[address] = node;
	}
}

void hashPrint()
{
	int i;
	for (i=0; i < hashSize; i++)
	{
		Hash_Node *node = table[i];
		while(node != NULL)
		{
			printf("address: %d, type: %d, text: %s;  \n", i, node->type, node->text); 
			node = node->next;
		}	
	}
}