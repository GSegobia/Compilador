%{
#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <cassert>

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

string types[] = {"float", "int"};

string tabela_operadores[][4] = {
                            {"float", "int", "+", "float"},
                            {"float", "int", "-", "float"},
                            {"float", "int", "*", "float"},
                            {"float", "int", "/", "float"}
                        };


bool validate_types(string type){

    bool valid = false;

    for(int i = 0; i < 2 | valid; i++){

        if(type == types[i]){
            valid = true;
        }
    }

    return valid;
}

string get_tabela_op(string tp1, string tp2, string op){

    string operation="";

    assert(validate_types(tp1) | validate_types(tp2));

    if(tp1==tp2){
        return tp1;
    }
    else{
        for(int i=0;i<4;i++){
            if(tp1 == tabela_operadores[i][0] | tp1 == tabela_operadores[i][1])
                if(tp2 == tabela_operadores[i][1] | tp2 == tabela_operadores[i][0])
                    if(op == tabela_operadores[i][2])
                       return  tabela_operadores[i][3];
        }
    }

    return "ERROOOU";

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
            | TK_ID '=' E
            {
                $$.traducao = $1.label+"="+$3.label;
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
            {
                $$.label = $1.label;
            }
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
