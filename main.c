#include <stdio.h>
#include "hash.h"
//#include "rules.tab.h"

extern FILE* yyin;
extern FILE *yyout;
extern int yyparse();
extern int getLineNumber();

void yyerror (char const *s)
{
	fprintf (stderr, "%s\n", s);
}

int main()
{
	yyin = fopen("in.txt", "r");
	int result = yyparse();
	if (result == 0)
		printf("This IS a program!");
	else
		printf("Something is wrong, return %i",result);
	printf("\nconteudo da tabela hash:\n");
	hashPrint();
	printf("o arquivo de entrada tem %d linhas\n", getLineNumber());
	return 0;
}