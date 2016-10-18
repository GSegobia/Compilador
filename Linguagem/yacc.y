%{
#include <iostream>
#include <cstdlib>
#include <sstream>
#include <map>
#include <cassert>

#define YYSTYPE atributos

using namespace std;

struct atributos{

    string label;
    string traducao;
};

typedef struct{

    string type;
    string tmp;
}META_VAR;

map<string, META_VAR> variable;

string types[] = {"float", "int", "bool", "char"};

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
string current_temp();
string set_variable(string var_name, string var_type = "");
%}

%token TK_NUM TK_REAL TK_CHAR TK_BOOL
%token TK_MAIN TK_ID TK_TIPO
%token TK_FIM TK_ERROR

%start S

%left '+' '-'
%left '*' '/'
%left '^' '&'
%left '(' ')'

%%

S           : TK_TIPO TK_MAIN '(' ')' BLOCO
            {
                cout << "/*Cry me a Ocean*/\n" << "#include <iostream>\n#include<string.h>\n#include<stdio.h>\nint main(void)\n{\n" << $5.traducao <<"\treturn 0;\n}" << endl;
            }
            ;

BLOCO       : '{' COMANDOS '}'
            {
                $$.traducao = $2.traducao;
            }
            ;

COMANDOS    : COMANDO COMANDOS
            {
                $$.traducao = $1.traducao + $2.traducao;
                cout << $1.traducao << '\t' << $2.traducao;
            }
            |
            {
                $$.traducao = "";
            }
            ;

COMANDO     : E ';'
            {
                $$.traducao = "\t" + $1.traducao + ";\n";
            }
            ;

E           : E '+' E
            {
                $$.traducao = $1.traducao + " + " + $3.traducao;
            }
            | E '-' E
            {
                $$.traducao = $1.traducao + " - " + $3.traducao;
            }
            | E '*' E
            {
                $$.traducao = $1.traducao + " * " + $3.traducao;
            }
            | E '/' E
            {
                $$.traducao = $1.traducao + " / " + $3.traducao;
            }
            | '(' E ')'
            {
                $$.traducao = "(" + $1.traducao + ")";
            }
            | TK_NUM
            {
                $$.traducao = $1.traducao;
            }
            | TK_REAL
            {
                $$.traducao = $1.traducao;
            }
            | TK_CHAR
            {
                $$.traducao = $1.traducao;
            }
            | TK_BOOL
            {
                string value = $1.traducao == "true" ? "1" : "0";
                $$.traducao = value;
            }
            | TK_ID
            {
                string variable_name = set_variable($1.label);
                $$.label = variable_name;
            }
            | TK_ID '=' E
            {
                string variable_name = set_variable($1.label);
                $$.traducao = variable_name + " = " + $3.traducao;
            }
            | TK_TIPO TK_ID
            {
                string variable_name = set_variable($2.label, $1.traducao);
                $$.traducao = $1.traducao + " " + variable_name;
            }
            | TK_TIPO TK_ID '=' E
            {
                string variable_name = set_variable($2.label, $1.traducao);
                $$.traducao = $1.traducao + " " + variable_name + " = " + $4.traducao;
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

    for(int i = 0; i < 4; i++){

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

string current_temp(){

    static int var_number = 0;

    string var = "tmp_" + to_string(var_number);

    var_number++;

    return var;
}

string set_variable(string var_name, string var_type){

    META_VAR var_aux;

    if(variable.count(var_name) > 0){

        var_aux = variable[var_name];

        return var_aux.tmp;
    }
    else{

        assert(var_type != "");
        assert(validate_types(var_type));

        var_aux.type = var_type;
        var_aux.tmp = current_temp();

        variable.insert(pair<string, META_VAR>(var_name, var_aux));

        return var_aux.tmp;
    }
}
