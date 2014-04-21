%{
#include <stdio.h>
<<<<<<< HEAD
#include <stdlib.h>
=======
>>>>>>> c1484affe34d0dee47bce3bba3ac0aecbf75c868
#include "hash.h"

extern FILE* yyin;

void yyerror(char const*);

<<<<<<< HEAD

=======
>>>>>>> c1484affe34d0dee47bce3bba3ac0aecbf75c868
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

<<<<<<< HEAD
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
=======
program:					empty | declaration program | function program	{ return(0); }

function:				header body ';'
header:					variableType TK_IDENTIFIER '(' parameters ')'
parameters:				empty | parameterList
parameterList:			variableType TK_IDENTIFIER ',' parameterList | variableType TK_IDENTIFIER
body:						command ';'

command:					block | simpleCommand
block:					'{' simpleCommandList '}'
simpleCommandList:	empty | simpleCommand simpleCommandList
simpleCommand:			assignment | input | output | return | if | loop 
assignment: 			TK_IDENTIFIER '=' expression | TK_IDENTIFIER '[' expression ']' '=' expression
input:					KW_INPUT TK_IDENTIFIER
output:					KW_OUTPUT elementList
elementList:			expression ',' elementList | expression
return:					KW_RETURN expression
if:						KW_IF '(' expression ')' KW_THEN command |
							KW_IF '(' expression ')' KW_ELSE command KW_THEN command 
loop:						KW_LOOP command '(' expression ')'	

expression:				functionCall | literal | TK_IDENTIFIER '[' expression ']' | TK_IDENTIFIER | 
							'!' expression | reference | precedence | expression operator expression 
operator:				'+'|'-'|'*'|'/'|'<'|'>' | OPERATOR_LE | OPERATOR_GE | 
							OPERATOR_EQ | OPERATOR_NE | OPERATOR_AND | OPERATOR_OR 
functionCall:			TK_IDENTIFIER '(' arguments ')'
arguments:				empty | argumentList
argumentList:			argument ',' argumentList | argument
argument:				expression
precedence:				'(' expression ')'
reference:				'&' TK_IDENTIFIER | '$' TK_IDENTIFIER

declaration:			simpleDeclaration | pointerDeclaration | arrayDeclaration 
simpleDeclaration: 	variableType TK_IDENTIFIER ':' literal ';'
pointerDeclaration:	'$' variableType TK_IDENTIFIER ':' literal ';'
arrayDeclaration:		variableType TK_IDENTIFIER '[' LIT_INTEGER ']' ';' |
							variableType TK_IDENTIFIER '[' LIT_INTEGER ']' ':' literalList ';'
variableType: 			KW_WORD | KW_BOOL | KW_BYTE
literalList:			literal literalList | literal
literal:					LIT_STRING | LIT_CHAR | LIT_INTEGER | LIT_TRUE | LIT_FALSE
>>>>>>> c1484affe34d0dee47bce3bba3ac0aecbf75c868

empty:					;

%%
void yyerror(char const *s)
{
<<<<<<< HEAD
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
=======
	fprintf(stderr, "%s\n", s);
}

/*int main()
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
}*/
int main()
{
	yyparse();
	return 0;
}
>>>>>>> c1484affe34d0dee47bce3bba3ac0aecbf75c868
