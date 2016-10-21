%{
#include <string>

%}

ESPACO [ \t]
DIGITO [0-9]
LETRA [A-Za-z_]

DELIM {ESPACO}+
NUM {DIGITO}+
REAL {NUM}+("."{NUM}+)?
CHAR \'({LETRA}|{DIGITO})\'
ID {LETRA}({LETRA}|{NUM})*

%%

"\n"		{}

{DELIM}		{}

"main"		{return TK_MAIN;}

"int"		{yylval.traducao = yytext; return TK_TIPO;}
"float"		{yylval.traducao = yytext; return TK_TIPO;}
"char"		{yylval.traducao = yytext; return TK_TIPO;}
"bool"		{yylval.traducao = yytext; return TK_TIPO;}

"true"      {yylval.traducao = yytext; return TK_BOOL;}
"false"     {yylval.traducao = yytext; return TK_BOOL;}

"=="        {yylval.traducao = yytext; return TK_RELAT;}
"!="        {yylval.traducao = yytext; return TK_RELAT;}
"<"         {yylval.traducao = yytext; return TK_RELAT;}
"<="        {yylval.traducao = yytext; return TK_RELAT;}
">"         {yylval.traducao = yytext; return TK_RELAT;}
">="        {yylval.traducao = yytext; return TK_RELAT;}

"+="		{yylval.traducao = yytext; return TK_PLUS_EQUAL;}
"-="		{yylval.traducao = yytext; return TK_MINUS_EQUAL;}
"*="		{yylval.traducao = yytext; return TK_MULTIPLIES_EQUAL;}
"/="		{yylval.traducao = yytext; return TK_DIVIDES_EQUAL;}

"and" 		{yylval.traducao = yytext; return TK_AND;}
"or"		{yylval.traducao = yytext; return TK_OR;}
"not"		{yylval.traducao = yytext; return TK_NOT;}	

"==="       {yylval.traducao = yytext; return TK_EQUALS_RELAT;}
"!=="       {yylval.traducao = yytext; return TK_NOT_EQUALS_RELAT;}

[(){}[\];,:]	{ return *yytext; }

[+\-*/=]	{ return *yytext; }

{NUM}		{yylval.traducao = yytext; return TK_NUM;}
{REAL}		{yylval.traducao = yytext; return TK_REAL;}
{CHAR}      {yylval.traducao = yytext; return TK_CHAR;}
{ID}		{yylval.label = yytext; return TK_ID;}

.			{ *yytext; }

%%