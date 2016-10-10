%{
#include <iostream>
#include <sstream>
#include <vector>
#include <cassert>

#define YYSTYPE atributos

using namespace std;

struct atributos
{
    string label;
    string traducao;
};

string types[] = {"float", "int", "boolean", "char"};

string tabela_operadores[][4] = {
                                    {"float", "int", "+", "float"},
                                    {"float", "int", "-", "float"},
                                    {"float", "int", "*", "float"},
                                    {"float", "int", "/", "float"}
                                };

int yylex(void);
void yyerror(string);

bool validate_types(string type);
string get_operation_type(string tp1, string tp2, string op);
string current_variable();
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
                $$.traducao = $1.traducao + $3.traducao + "\ta = b + c;\n";
                cout << "#" << $1.traducao << " && " << $1.label << endl;
            }
            | E '-' E
            {
                $$.traducao = $1.traducao + $3.traducao + "\ta = b - c;\n";
            }
            | E '*' E
            {
                $$.traducao = $1.traducao + $3.traducao + "\ta = b * c;\n";   
            }
            | E '/' E
            {
                $$.traducao = $1.traducao + $3.traducao + "\ta = b / c;\n";  
            }
            | '(' E ')'
            {
                $$.traducao = "\ta = (b);\n";  
            }
            | TK_NUM
            {
                $$.traducao = "\ta = " + $1.traducao + ";\n";
            }
            | TK_REAL
            {
                $$.traducao = "\ta = " + $1.traducao + ";\n";  
            }
            | TK_ID
            {
                $$.label = $1.label;
                cout << $1.label << endl;
            }
            | TK_ID '=' E
            {
                $$.traducao = $3.traducao;
                cout << '#' << $1.label << endl;
            }
            ;

%%

#include "lex.yy.c"

int yyparse();

int main(int argc, char* argv[]){
    
    yyparse();

    return 0;
}

void yyerror(string MSG){

    cout << MSG << endl;
    exit (0);
}               

bool validate_types(string type){

    bool valid = false;

    for(int i = 0; i < 2 | valid; i++){

        if(type == types[i]){
            valid = true;
        }
    }

    return valid;
}

string get_operation_type(string tp1, string tp2, string op){

    string operation = "";

    assert(validate_types(tp1) | validate_types(tp2));

    if(tp1 == tp2){
        
        return tp1;
    }
    else{

        for(int i = 0; i < 4; i++){

            if(tp1 == tabela_operadores[i][0] | tp1 == tabela_operadores[i][1])

                if(tp2 == tabela_operadores[i][1] | tp2 == tabela_operadores[i][0])

                    if(op == tabela_operadores[i][2])

                       return  tabela_operadores[i][3];
        }
    }

    return "ERROOOU";

}

string current_variable(){

    static int var_number = 0;

    string var = "tmp_" + to_string(var_number);

    var_number++;

    return var;
}