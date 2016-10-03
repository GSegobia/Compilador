%{
#include <iostream>
#include <string>
#include <sstream>

#define YYSTYPE atributos

using namespace std;

struct atributos
{
    string label;
    string traducao;
    string tipo;
    int value;
};

typedef struct{

    string tipo;

}variavel; 

string tabela_operadores = ["int", "float", "+", "float";
                            "float", "int", "-", "float"];


string get_tabela_op(string tp1, string tp2, string op){


}

int yylex(void);
void yyerror(string);
%}

%token TK_NUM TK_REAL
%token TK_MAIN TK_ID TK_TIPO_INT TK_TIPO_FLOAT
%token TK_FIM TK_ERROR

%start S

%left '+' '-'
%left '*' '/'
%left '(' ')'

%%

S           : TK_TIPO_INT TK_MAIN '(' ')' BLOCO
            {
                cout << "/*Compilador FOCA*/\n" << "#include <iostream>\n#include<string.h>\n#include<stdio.h>\nint main(void)\n{\n" << $5.traducao <<"\treturn 0;\n}" << endl; 
            }
            ;

BLOCO       : '{' COMANDOS '}'
            {
                $$.traducao = $2.traducao;
            }
            ;

COMANDOS    : COMANDO COMANDOS
            |
            ;

COMANDO     : E ';'
            ;

E           : E '+' E
            {
                $$.value = $1.value + $3.value;
                cout << $$.value << "\t" << $$.label << endl;
                $$.traducao = $1.traducao + $3.traducao + "\ta =" + to_string($$.value) + ";\n";
            }
            | E '-' E
            {
                $$.value = $1.value - $3.value;
                cout << $$.value << "\t" << $$.label << endl;
                $$.traducao = $1.traducao + $3.traducao + "\ta =" + to_string($$.value) + ";\n";
            }
            | E '*' E
            {
                $$.value = $1.value * $3.value;
                cout << $$.value << "\t" << $$.label << endl;
                $$.traducao = $1.traducao + $3.traducao + "\ta =" + to_string($$.value) + ";\n";   
            }
            | E '/' E
            {
                $$.value = $1.value / $3.value;
                cout << $$.value << "\t" << $$.label << endl;
                $$.traducao = $1.traducao + $3.traducao + "\ta =" + to_string($$.value) + ";\n";  
            }
            | '(' E ')'
            {
                $$.value = ($2.value);
                cout << $$.value << "\t" << $$.label << endl;
                $$.traducao = "\ta =" + to_string($$.value) + ";\n";  
            }
            | TK_NUM
            {
                $$.value = stoi($1.traducao);
                $$.traducao = "\ta = " + $1.traducao + ";\n";
                $$.tipo = "int";
            }
            | TK_REAL
            {
                $$.value = stof($1.traducao);
                $$.traducao = "\ta = " + $1.traducao + ";\n";  
                $$.tipo = "float"; 
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
