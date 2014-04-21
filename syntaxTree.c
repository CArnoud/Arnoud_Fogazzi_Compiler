#include "syntaxTree.h"

syntaxTree* create_AST_node (int type, int value, syntaxTree* child0, syntaxTree* child1, syntaxTree* child2, syntaxTree* child3)
{
	syntaxTree* newTree = malloc(sizeof(syntaxTree));
	newTree->type = type;
	newTree->value = value;
	newTree->child[0] = child0;
	newTree->child[1] = child1;
	newTree->child[2] = child2;
	newTree->child[3] = child3;
	
	return newTree;
}

void astWriteToFile(syntaxTree *tree, FILE *output)
{
	if (tree == NULL)
		return;
	switch (tree->type)
	{
		//a bunch of cases go in here
		;
	}
}