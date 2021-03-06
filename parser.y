%{
#include <stdio.h>
#include <stdlib.h>
#include "hash.h"
#include "syntaxTree.h"

extern FILE* yyin;

void yyerror(char const*);

syntaxTree *rootNode;

%}
%union 
{
	struct hash_node *symbol;
	struct _syntaxTree *syntaxTree;
};

%token KW_WORD KW_BOOL KW_BYTE KW_IF KW_THEN KW_ELSE KW_LOOP KW_INPUT KW_OUTPUT KW_RETURN
%token OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_NE OPERATOR_AND OPERATOR_OR
%token <symbol> TK_IDENTIFIER LIT_INTEGER LIT_FALSE LIT_TRUE LIT_CHAR LIT_STRING
%token TOKEN_ERROR

%left '+' '-'
%left '*' '/'
%left '<' '>' OPERATOR_LE OPERATOR_GE OPERATOR_NE OPERATOR_EQ
%left OPERATOR_OR
%left OPERATOR_AND

%type <syntaxTree> literal program literalList expression

%glr-parser
%%

program					: declarations { return(0); }

declarations			: empty 							{ $$ = NULL; }
							| declarations declaration { $$ = create_AST_Node(AST_DECLARATION, 0, $1, $2, NULL, NULL); }
							| declarations function {$$ = create_AST_Node(AST_DECLARATION, 0, $1, $2, NULL, NULL); } 										
function					: header body ';' { $$ = create_AST_Node(AST_FUNCTION_DECLARATION, 0, $1, $2, NULL, NULL); }

header					: variableType TK_IDENTIFIER '(' parameters ')' { $$ = create_AST_Node(AST_FUNCTION_HEADER, $2, $1, $3, NULL, NULL); }

parameters				: empty { $$ = NULL; }
							| parameterList { $$ = $1; }

parameterList			: parameterList ',' variableType TK_IDENTIFIER   { $$ = create_AST_Node(AST_PARAMETER_LIST, $4, $3, $1, NULL, NULL); }
							| variableType TK_IDENTIFIER { $$ = create_AST_Node(AST_PARAMETER_LIST, $2, $1, NULL, NULL, NULL); }

body						: command		{ $$ = $1; }

command					: block 			 	{ $$ = $1; }
							| simpleCommand	{ $$ = $1; }	

block						: '{' simpleCommandList '}' { $$ = create_AST_Node(AST_BLOCK, 0, $2, NULL, NULL, NULL); }

simpleCommandList		: empty { $$ = NULL; }
							| simpleCommandList simpleCommand { $$ = create_AST_Node(AST_COMMAND_LIST, 0, $2, $1, NULL, NULL); }

simpleCommand			: assignment { $$ = $1; }
							| input 		{ $$ = $1; }
							| output { $$ = $1; }
							| return { $$ = $1; }
							| if { $$ = $1; }
							| loop { $$ = $1; }

assignment				: TK_IDENTIFIER '=' expression { $$ = create_AST_Node(AST_VAR_ASSINGN, $1, $3, NULL, NULL, NULL); }
							| TK_IDENTIFIER '[' expression ']' '=' expression	{ $$ = create_AST_Node(AST_ARR_ASSINGN, $1, $3, $6, NULL, NULL); }

input						: KW_INPUT TK_IDENTIFIER { $$ = create_AST_Node(AST_INPUT, $2, NULL, NULL, NULL, NULL); }

output					: KW_OUTPUT elementList { $$ = create_AST_Node(AST_OUTPUT, 0, $2, NULL, NULL, NULL); }

elementList				: elementList ',' expression { $$ = create_AST_Node(AST_ELEMENT_LIST, 0, $3, $1, NULL, NULL); }
							| expression { $$ = create_AST_Node(AST_ELEMENT_LIST, 0, $1, NULL, NULL, NULL); }

return					: KW_RETURN expression { $$ = create_AST_Node(AST_RETURN, 0, $2, NULL, NULL, NULL); }

if							: KW_IF '(' expression ')' KW_THEN command { $$ = create_AST_Node(AST_IF_THEN, 0, $3, $6, NULL, NULL); }
							| KW_IF '(' expression ')' KW_ELSE command KW_THEN command  { $$ = create_AST_Node(AST_IF_ELSE, 0, $3, $6, $8, NULL); }

loop						: KW_LOOP command '(' expression ')' { $$ = create_AST_Node(AST_LOOP, 0, $2, $4, NULL, NULL); }	

expression				: functionCall 																		{ $$ = $1; }
							| literal 																				{ $$ = $1; }
							| TK_IDENTIFIER '[' expression ']' 												{ $$ = create_AST_Node(AST_ARRAY, $1, $3, NULL, NULL, NULL); }
							| TK_IDENTIFIER 																		{ $$ = create_AST_Node(AST_VARIABLE, $1, NULL, NULL, NULL, NULL); }
							| '&' TK_IDENTIFIER 																	{ $$ = create_AST_Node(AST_OPERATOR_REF, $2, NULL, NULL, NULL, NULL); }
							| '$' TK_IDENTIFIER 																	{ $$ = create_AST_Node(AST_OPERATOR_DEREF, $2, NULL, NULL, NULL, NULL); }
							| '!' expression 																		{ $$ = create_AST_Node(AST_OPERATOR_NOT, 0, $2, NULL, NULL, NULL); }
							| '(' expression ')'																	{ $$ = create_AST_Node(AST_PARENTHESIS, 0, $2, NULL, NULL, NULL); }
							| expression '+' expression														{ $$ = create_AST_Node(AST_OPERATOR_ADD, 0, $1, $3, NULL, NULL); }
							| expression '-' expression														{ $$ = create_AST_Node(AST_OPERATOR_SUB, 0, $1, $3, NULL, NULL); }
							| expression '*' expression														{ $$ = create_AST_Node(AST_OPERATOR_MUL, 0, $1, $3, NULL, NULL); }
							| expression '/' expression														{ $$ = create_AST_Node(AST_OPERATOR_DIV, 0, $1, $3, NULL, NULL); }
							| expression '<' expression														{ $$ = create_AST_Node(AST_OPERATOR_LESS, 0, $1, $3, NULL, NULL); }
							| expression '>' expression														{ $$ = create_AST_Node(AST_OPERATOR_GREATER, 0, $1, $3, NULL, NULL); }
							| expression OPERATOR_LE  expression											{ $$ = create_AST_Node(AST_OPERATOR_LE, 0, $1, $3, NULL, NULL); }
							| expression OPERATOR_GE  expression											{ $$ = create_AST_Node(AST_OPERATOR_GE, 0, $1, $3, NULL, NULL); }
							| expression OPERATOR_EQ  expression											{ $$ = create_AST_Node(AST_OPERATOR_EQ, 0, $1, $3, NULL, NULL); }
							| expression OPERATOR_NE  expression											{ $$ = create_AST_Node(AST_OPERATOR_NE, 0, $1, $3, NULL, NULL); }
							| expression OPERATOR_AND  expression											{ $$ = create_AST_Node(AST_OPERATOR_AND, 0, $1, $3, NULL, NULL); }
							| expression OPERATOR_OR  expression											{ $$ = create_AST_Node(AST_OPERATOR_OR, 0, $1, $3, NULL, NULL); }

functionCall			: TK_IDENTIFIER '(' arguments ')'												{ $$ = create_AST_Node(AST_FUNCTION_CALL, $1, $3, NULL, NULL, 0); }

arguments				: empty { $$ = NULL; }
							| argumentList { $$ = $1 }

argumentList			: argumentList ',' argument { $$ = create_AST_Node(AST_ARGUMENT_LIST, 0, $3, $1, NULL, NULL); }
							| argument { $$ = create_AST_Node(AST_ARGUMENT_LIST, 0, $1, NULL, NULL, NULL); }			

argument					: expression { $$ = $1; }

declaration				: simpleDeclaration { $$ = $1; }
							| pointerDeclaration { $$ = $1; }
							| arrayDeclaration { $$ = $1; }

simpleDeclaration		: variableType TK_IDENTIFIER ':' literal ';'										{ $$ = create_AST_Node(AST_SIMPLE_DECLARATION, $2, $1, $4, NULL, NULL); }

pointerDeclaration	: variableType '$' TK_IDENTIFIER ':' literal ';'								{ $$ = create_AST_Node(AST_POINTER_DECLARATION, $3, $1, $5, NULL, NULL); }

arrayDeclaration		: variableType TK_IDENTIFIER '[' LIT_INTEGER ']' ';' 							{ $$ = create_AST_Node(AST_ARRAY_DECLARATION, $2, $1, $4, NULL, NULL); }
							| variableType TK_IDENTIFIER '[' LIT_INTEGER ']' ':' literalList ';'		{ $$ = create_AST_Node(AST_ARRAY_DECLARATION, $2, $1, $4, $7, NULL); }

variableType			: KW_WORD 																					{ $$ = create_AST_Node(AST_KW_WORD, 0, NULL, NULL, NULL, NULL); }
							| KW_BOOL 																					{ $$ = create_AST_Node(AST_KW_BOOL, 0, NULL, NULL, NULL, NULL); }
							| KW_BYTE																					{ $$ = create_AST_Node(AST_KW_BYTE, 0, NULL, NULL, NULL, NULL); }

literalList				: literalList literal  																	{ $$ = create_AST_Node(AST_LIT_LIST, 0, $2, $1, NULL, NULL); }
							| literal																					{ $$ = $1; }

literal					: LIT_STRING 																				{ $$ = create_AST_Node(AST_LIT_STRING, $1, 0, 0, 0, 0); }
							| LIT_CHAR 																					{ $$ = create_AST_Node(AST_LIT_CHAR, $1, 0, 0, 0, 0); }
							| LIT_INTEGER 																				{ $$ = create_AST_Node(AST_LIT_INTEGER, $1, 0, 0, 0, 0); }
							| LIT_TRUE 																					{ $$ = create_AST_Node(AST_LIT_TRUE, $1, 0, 0, 0, 0); }
							| LIT_FALSE																					{ $$ = create_AST_Node(AST_LIT_FALSE, $1, 0, 0, 0, 0); }

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
