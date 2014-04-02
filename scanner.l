%{
#include "hash.h"
#include "rules.tab.h"

int numberOfLines = 1;
int running = 1;

%}
%x COMM_M
%x COMM_S
%%
"word"									{ return KW_WORD; hashInsert(yytext, SYMBOL_LIT_TRUE);}
"bool"									{ return KW_BOOL; }
"byte"									{ return KW_BYTE; }
"if"										{ return KW_IF; }
"then"									{ return KW_THEN; }
"else"									{ return KW_ELSE; }
"loop"									{ return KW_LOOP; }
"input"									{ return KW_INPUT; }
"return"									{ return KW_RETURN; }
"output"									{ return KW_OUTPUT; }
"true"									{ yylval.symbol = hashInsert(yytext, SYMBOL_LIT_TRUE); return LIT_TRUE; }
"false"									{ yylval.symbol = hashInsert(yytext, SYMBOL_LIT_FALSE); return LIT_FALSE; }
"<="										{ return OPERATOR_LE; }
">="										{ return OPERATOR_GE; }
"=="										{ return OPERATOR_EQ; }
"!="										{ return OPERATOR_NE; }
"&&"										{ return OPERATOR_AND; }
"||"										{ return OPERATOR_OR; }
[0-9]*[a-zA-Z_][a-zA-Z_0-9]*		{ yylval.symbol = hashInsert(yytext, SYMBOL_IDENTIFIER); return TK_IDENTIFIER; }
[0-9]+									{ yylval.symbol = hashInsert(yytext, SYMBOL_LIT_INTEGER); return LIT_INTEGER; }
'.' 										{ yylval.symbol = hashInsert(yytext, SYMBOL_LIT_CHAR); return LIT_CHAR; }
\"((\\\")|[^"])*\"					{ yylval.symbol = hashInsert(yytext, SYMBOL_LIT_STRING); return LIT_STRING; }
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
