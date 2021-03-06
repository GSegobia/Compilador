%{
#include <string>

%}

SPACE [ \t]
DIGIT [0-9]
LETTER [A-Za-z_]

DELIM {SPACE}+
NUM {DIGIT}+
FLOAT {NUM}+([.]{NUM}+)?
STRING [^"\\]*(?:\\.[^"\\]*)*
STRING_QUOTE \'{STRING}\'|\"{STRING}\"
CHAR '({LETTER}|{DIGIT})'
ID {LETTER}({LETTER}|{NUM})*

%%

{DELIM}		{}

"start"     {return TK_START;}
"end"       {return TK_END;}

"int"		{yylval.translate = yytext; return TK_NUMBER_TYPE;}
"float"		{yylval.translate = yytext; return TK_NUMBER_TYPE;}

"var"       {yylval.translate = yytext; return TK_DYNAMIC_TYPE;}

"number"    {yylval.translate = yytext; return TK_TYPE;}
"char"		{yylval.translate = yytext; return TK_TYPE;}
"bool"		{yylval.translate = yytext; return TK_TYPE;}
"string"    {yylval.translate = yytext; return TK_TYPE;}

"true"      {yylval.translate = yytext; return TK_BOOL;}
"false"     {yylval.translate = yytext; return TK_BOOL;}

"and" 		{yylval.translate = yytext; return TK_AND;}
"or"		{yylval.translate = yytext; return TK_OR;}
"not"		{yylval.translate = yytext; return TK_NOT;}

"if"        {yylval.translate = yytext; return TK_IF;}
"elif"      {yylval.translate = yytext; return TK_ELIF;}
"else"      {yylval.translate = yytext; return TK_ELSE;}

"for"       {yylval.translate = yytext; return TK_FOR;}

"while"     {yylval.translate = yytext; return TK_WHILE;}

"repeat"    {yylval.translate = yytext; return TK_REPEAT;}
"until"     {yylval.translate = yytext; return TK_UNTIL;}

"switch"    {yylval.translate = yytext; return TK_SWITCH;}
"case"      {yylval.translate = yytext; return TK_CASE;}
"default"   {yylval.translate = yytext; return TK_DEFAULT;}

"break"     {yylval.translate = yytext; return TK_BREAK;}
"continue"  {yylval.translate = yytext; return TK_CONTINUE;}

"outl"      {yylval.translate = yytext; return TK_OUT_LINE;}
"out"       {yylval.translate = yytext; return TK_OUT;}
"in"        {yylval.translate = yytext; return TK_IN;}

"function"  {yylval.translate = yytext; return TK_FUNCTION;}
"return"    {yylval.translate = yytext; return TK_RETURN;}

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

"++"        {yylval.translate = yytext; return TK_PLUS_PLUS;}
"--"        {yylval.translate = yytext; return TK_MINUS_MINUS;}

[(){}[\];,:]	{return *yytext;}

"\n"		{return *yytext;}

[+\-*/=%]	{return *yytext;}

{FLOAT}		{yylval.translate = yytext; return TK_REAL;}
{CHAR}      {yylval.translate = yytext; return TK_CHAR;}
{STRING_QUOTE}    {yylval.translate = yytext; return TK_STRING;}
{ID}		{yylval.label = yytext; return TK_ID;}

.			{ *yytext; }

%%
