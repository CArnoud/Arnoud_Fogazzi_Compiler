%{
#include "tokens.h"
#include "hash.h"

int numberOfLines = 1;
int running = 1;

%}
%x COMM_M
%x COMM_S
%%
"word"									{ return KW_WORD; }
"bool"									{ return KW_BOOL; }
"byte"									{ return KW_BYTE; }
"if"										{ return KW_IF; }
"then"									{ return KW_THEN; }
"else"									{ return KW_ELSE; }
"loop"									{ return KW_LOOP; }
"input"									{ return KW_INPUT; }
"return"									{ return KW_RETURN; }
"output"									{ return KW_OUTPUT; }
"true"									{ return LIT_TRUE; }
"false"									{ return LIT_FALSE; }
"<="										{ return OPERATOR_LE; }
">="										{ return OPERATOR_GE; }
"=="										{ return OPERATOR_EQ; }
"!="										{ return OPERATOR_NE; }
"&&"										{ return OPERATOR_AND; }
"||"										{ return OPERATOR_OR; }
[0-9]*[a-zA-Z_][a-zA-Z_0-9]*		{ hashInsert(yytext, HASH_ID); return TK_IDENTIFIER; }
[0-9]+									{ hashInsert(yytext, HASH_INTEGER); return LIT_INTEGER; }
'.' 										{ return LIT_CHAR; }
\"((\\\")|[^"])*\"					{ return LIT_STRING; }
"//"										{ BEGIN(COMM_S); }
"/*"										{ BEGIN(COMM_M); }
","|";"|":"|"("|")"|"["|"]"|"{"|"}"|"+"|"-"|"*"|"/"|"<"|">"|"="|"!"|"&"|"$"	{ return yytext[0]; }
[ \t]+    								/* eliminar espaços em braco */
\n											{ numberOfLines++; }
.											{ return TOKEN_ERROR; }

<COMM_M>"*/"							{ BEGIN(INITIAL); }
<COMM_M>\n								{ numberOfLines++; }
<COMM_M>.

<COMM_S>\n								{ numberOfLines++; BEGIN(INITIAL); }
<COMM_S>.					

%%

int getLineNumber()
{
	return numberOfLines;
}

int yywrap() 
{
	running = 0; 
	return 1;
}