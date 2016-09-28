%{
#include <iostream>
#include <string>
#include <sstream>

#define YYSTYPE atributos

using namespace std;

int geraVariavel(){
	
	static int id_variable = 0;

	id_variable++;

	return id_variable;
}

struct atributos
{
	string label;
	string traducao;
	int value;
};

int yylex(void);
void yyerror(string);
%}

%token TK_NUM
%token TK_MAIN TK_ID TK_TIPO_INT
%token TK_FIM TK_ERROR

%start S

%left '+'

%%

S 			: TK_TIPO_INT TK_MAIN '(' ')' BLOCO
			{
				cout << "/*Compilador FOCA*/\n" << "#include <iostream>\n#include<string.h>\n#include<stdio.h>\nint main(void)\n{\n" << $5.traducao << "\treturn 0;\n}" << endl; 
			}
			;

BLOCO		: '{' COMANDOS '}'
			{
				$$.traducao = $2.traducao;
			}
			;

COMANDOS	: COMANDO COMANDOS
			|
			;

COMANDO 	: E ';'
			;

E 			: E '+' E
			{
				$$.label = to_string(geraVariavel());
				$$.value = $1.value + $3.value;
				cout << $$.value << "\t" << $$.label << endl;
				$$.traducao = $1.traducao + $3.traducao + "\ta =" + to_string($$.value) + ";\n";
			}
			| TK_NUM
			{
				$$.value = stoi($1.traducao);
				$$.traducao = "\ta = " + $1.traducao + ";\n";
			}
			| TK_ID
			;

%%

#include "lex.yy.c"

int yyparse();

int main( int argc, char* argv[] )
{
	yyparse();

	return 0;
}

void yyerror( string MSG )
{
	cout << MSG << endl;
	exit (0);
}				
