%{
#include <stdio.h>
#include <stdlib.h>
#include "hash.h"

extern FILE* yyin;

void yyerror(char const*);


%}
%union {
	struct hash_node *symbol;
	};

%token KW_WORD KW_BOOL KW_BYTE KW_IF KW_THEN KW_ELSE KW_LOOP KW_INPUT KW_OUTPUT KW_RETURN
%token OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_NE OPERATOR_AND OPERATOR_OR
%token <symbol> TK_IDENTIFIER LIT_INTEGER LIT_FALSE LIT_TRUE LIT_CHAR LIT_STRING
%token TOKEN_ERROR
%glr-parser
%%

program					: empty 
							| program declaration  
							| program function   										{ return(0); }

function					: header body ';'

header					: variableType TK_IDENTIFIER '(' parameters ')'

parameters				: empty 
							| parameterList

parameterList			: parameterList ',' variableType TK_IDENTIFIER   
							| variableType TK_IDENTIFIER

body						: command

command					: block 
							| simpleCommand

block						: '{' simpleCommandList '}'

simpleCommandList		: empty 
							| simpleCommandList simpleCommand

simpleCommand			: assignment 
							| input 
							| output 
							| return 
							| if 
							| loop 

assignment				: TK_IDENTIFIER '=' expression 
							| TK_IDENTIFIER '[' expression ']' '=' expression

input						: KW_INPUT TK_IDENTIFIER

output					: KW_OUTPUT elementList

elementList				: elementList ',' expression 
							| expression

return					: KW_RETURN expression

if							: KW_IF '(' expression ')' KW_THEN command 
							| KW_IF '(' expression ')' KW_ELSE command KW_THEN command 

loop						: KW_LOOP command '(' expression ')'	

expression				: functionCall 
							| literal 
							| TK_IDENTIFIER '[' expression ']' 
							| TK_IDENTIFIER 
							| '$' TK_IDENTIFIER
							| '!' expression 
							| reference 
							| precedence 
							| expression operator expression

operator					: '+'
							| '-'
							| '*'
							| '/'
							| '<'
							| '>' 
							| OPERATOR_LE 
							| OPERATOR_GE 
							| OPERATOR_EQ 
							| OPERATOR_NE 
							| OPERATOR_AND 
							| OPERATOR_OR

functionCall			: TK_IDENTIFIER '(' arguments ')'

arguments				: empty 
							| argumentList

argumentList			: argumentList ',' argument
							| argument							

argument					: expression

precedence				: '(' expression ')'

reference				: '&' TK_IDENTIFIER 
							| '$' TK_IDENTIFIER

declaration				: simpleDeclaration 
							| pointerDeclaration 
							| arrayDeclaration 

simpleDeclaration		: variableType TK_IDENTIFIER ':' literal ';'

pointerDeclaration	: variableType '$' TK_IDENTIFIER ':' literal ';'

arrayDeclaration		: variableType TK_IDENTIFIER '[' LIT_INTEGER ']' ';' 
							| variableType TK_IDENTIFIER '[' LIT_INTEGER ']' ':' literalList ';'

variableType			: KW_WORD 
							| KW_BOOL 
							| KW_BYTE

literalList				: literalList literal  
							| literal

literal					: LIT_STRING 
							| LIT_CHAR 
							| LIT_INTEGER 
							| LIT_TRUE 
							| LIT_FALSE

empty:					;

%%
void yyerror(char const *s)
{
	fprintf(stderr, "Line %d: %s\n", getLineNumber() ,s);
	exit(3);
}

int main(int argc, char *argv[])
{
	if(argc < 1) {
		yyparse();
	}
	else {
		FILE *file;
		file = fopen(argv[1],"r");
		if(file) {
			yyin = file;
			yyparse();
			exit(0);
		}
		else {
			fprintf(stderr,"Failed to open file %s\n", argv[1]);
		}
	}
	return 1;
}