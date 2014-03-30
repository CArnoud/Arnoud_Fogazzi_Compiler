%token KW_WORD KW_BOOL KW_BYTE KW_IF KW_THEN KW_ELSE KW_LOOP KW_INPUT KW_OUTPUT KW_RETURN
%token OPERATOR_LE OPERATOR_GE OPERATOR_EQ OPERATOR_NE OPERATOR_AND OPERATOR_OR
%token TK_IDENTIFIER LIT_INTEGER LIT_FALSE LIT_TRUE LIT_CHAR LIT_STRING
%token TOKEN_ERROR

%%

function:				header localDeclarations block;
header:					variableType TK_IDENTIFIER '(' parameters ')';
parameters:				empty | parameterList;
parameterList:			variableType TK_IDENTIFIER ',' parameterList | variableType TK_IDENTIFIER;
localDeclarations:		simpleDeclarations;
simpleDeclarations:		empty | simpleDeclarationList;
simpleDeclarationList:	simpleDeclaration simpleDeclarationList | simpleDeclaration;

command:				block | simpleCommand;
block:					'{' command '}'
simpleCommand:			empty | assignment | input | output | return | if | loop ';';
assignment: 			TK_IDENTIFIER '=' expression | TK_IDENTIFIER '[' expression ']' '=' expression;
input:					KW_INPUT TK_IDENTIFIER;
output:					KW_OUTPUT elementList;
elementList:			element ',' elementList | element;
element:				LIT_STRING | expression;
return:					KW_RETURN expression;
if:						KW_IF '(' expression ')' KW_THEN command |
						KW_IF '(' expression ')' KW_THEN command KW_ELSE command;
loop:					KW_LOOP '(' expression ')' command;			

expression:				arithmeticExpression | booleanExpression | functionCall | reference;
arithmeticExpression:	literal | TK_IDENTIFIER | TK_IDENTIFIER '[' arithmeticExpression ']' | 
						'(' arithmeticExpression ')' | arithmeticExpression arithmeticOperator arithmeticExpression ;
arithmeticOperator:		"+"|"-"|"*"|"/";
booleanExpression:		LIT_CHAR | LIT_TRUE | LIT_FALSE |
						arithmeticExpression relationalOperator arithmeticExpression |
						"!" booleanExpression | booleanExpression logicalOperators booleanExpression ;
relationalOperator:		"<" | ">" | OPERATOR_LE | OPERATOR_GE | OPERATOR_EQ | OPERATOR_NE;
logicalOperators:		OPERATOR_AND | OPERATOR_OR;		
functionCall:			TK_IDENTIFIER '(' arguments ')';
arguments:				empty | argumentList;
argumentList:			argument ',' argumentList | argument;
argument:				expression;
reference:				'&' TK_IDENTIFIER | '*' TK_IDENTIFIER;

simpleDeclaration: 		variableType TK_IDENTIFIER ':' literal ';' ;
pointerDeclaration:		'$' variableType TK_IDENTIFIER ':' literal ';' ;
arrayDeclaration:		variableType TK_IDENTIFIER '[LIT_INTEGER]' ';' |
						variableType TK_IDENTIFIER '[LIT_INTEGER]' ':' literalList ';' ;
variableType: 			KW_WORD | KW_BOOL | KW_BYTE ;
literalList:			literal literalList | literal ;
literal:				LIT_STRING | LIT_CHAR | LIT_INTEGER ;

empty:					;

%%