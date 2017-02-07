%{
#include <string>

%}

SPACE [ \t]
DIGIT [0-9]
LETTER [A-Za-z_]

DELIM {SPACE}+
NUM {DIGIT}+
FLOAT ([-|+]?){NUM}+([.]{NUM}+)?
CHAR '({LETTER}|{DIGIT})'
ID {LETTER}({LETTER}|{NUM})*

%%

{DELIM}		{}

"start"     {return TK_START;}
"end"       {return TK_END;}

"int"		{yylval.translate = yytext; return TK_NUMBER_TYPE;}
"float"		{yylval.translate = yytext; return TK_NUMBER_TYPE;}

"var"       {yylval.translate = yytext; return TK_DYNAMIC_TYPE;}

"number"    {yylval.translate = yytext; return TK_NUMBER;}

"char"		{yylval.translate = yytext; return TK_TYPE;}
"bool"		{yylval.translate = yytext; return TK_TYPE;}

"true"      {yylval.translate = yytext; return TK_BOOL;}
"false"     {yylval.translate = yytext; return TK_BOOL;}

"and" 		{yylval.translate = yytext; return TK_AND;}
"or"		{yylval.translate = yytext; return TK_OR;}
"not"		{yylval.translate = yytext; return TK_NOT;}

"if"        {yylval.translate = yytext; return TK_IF;}
"elif"      {yylval.translate = yytext; return TK_ELIF;}
"else"      {yylval.translate = yytext; return TK_ELSE;}

"outl"      {yylval.translate = yytext; return TK_OUT_LINE;}

"::"        {yylval.translate = yytext; return TK_DOUBLE_COLON;}
"<<"        {yylval.translate = yytext; return TK_SHIFT_LEFT;}
">>"        {yylval.translate = yytext; return TK_SHIFT_RIGHT;}

"=="        {yylval.translate = yytext; return TK_RELAT;}
"!="        {yylval.translate = yytext; return TK_RELAT;}
"<"         {yylval.translate = yytext; return TK_RELAT;}
"<="        {yylval.translate = yytext; return TK_RELAT;}
">"         {yylval.translate = yytext; return TK_RELAT;}
">="        {yylval.translate = yytext; return TK_RELAT;}

"==="       {yylval.translate = yytext; return TK_EQUALS_RELAT;}
"!=="       {yylval.translate = yytext; return TK_NOT_EQUALS_RELAT;}

"+="		{yylval.translate = yytext; return TK_PLUS_EQUAL;}
"-="		{yylval.translate = yytext; return TK_MINUS_EQUAL;}
"*="		{yylval.translate = yytext; return TK_MULTIPLIES_EQUAL;}
"/="		{yylval.translate = yytext; return TK_DIVIDES_EQUAL;}

[(){}[\];,:]	{return *yytext;}

"\n"		{return *yytext;}

[+\-*/=%]	{return *yytext;}

{FLOAT}		{yylval.translate = yytext; return TK_REAL;}
{CHAR}      {yylval.translate = yytext; return TK_CHAR;}
{ID}		{yylval.label = yytext; return TK_ID;}

.			{ *yytext; }

%%
