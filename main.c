#include <stdio.h>
#include "tokens.h"
#include "hash.h"

extern FILE* yyin;
extern int yylex();
extern int running;
extern int getLineNumber();


int main()
{
	int token;
	yyin = fopen("in.txt", "r");
	while (running)
	{
		token = yylex();
		switch(token)
		{
			case KW_WORD: 			printf("KW_WORD ");
										break;
			case LIT_STRING:		printf("STRING! ");
										break;
			case LIT_CHAR:			printf("CHAR ");
										break;
			case LIT_INTEGER:		printf("INT ");
										break;
			case TK_IDENTIFIER:	printf("ID ");
										break;
			case OPERATOR_EQ:		printf("EQ ");
										break;
			case TOKEN_ERROR:		printf("ERRO ");
										break;
			default:					printf("%c ", token);
		}
	}
	printf("\nconteudo da tabela hash:\n");
	hashPrint();
	printf("o arquivo de entrada tem %d linhas\n", getLineNumber());
	return 0;
}