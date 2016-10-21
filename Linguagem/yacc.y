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
    string tipo;
    string conversao;
};

typedef struct{

    string type;
    string tmp;
}META_VAR;

map<string, META_VAR> variable;

string types[] = {"float", "int", "bool", "char"};

string cast_table[][2] ={ 
                        {"float","int"}
                        };

string tabela_operadores[][4] = {
                                    {"float", "int", "+", "float"},
                                    {"float", "int", "-", "float"},
                                    {"float", "int", "*", "float"},
                                    {"float", "int", "/", "float"}
                                };

map<string,string> type_value = {
                                    {"float", "0"},
                                    {"int", "1"},
                                    {"bool", "2"},
                                    {"char", "3"}
                                };

int yylex(void);
void yyerror(string);

bool validate_types(string type);
void validate_attribute(string exp_type, string var_type);
string verify_bool(string type);
string get_operation_type(string tp1, string tp2, string op);
string current_temp();
string set_variable(string var_name, string var_type = "");
bool validate_cast(string tp1,string tip2);
void validate_bool(string type);
%}

%token TK_NUM TK_REAL TK_CHAR TK_BOOL 
%token TK_OR TK_AND TK_NOT
%token TK_MAIN TK_ID TK_TIPO TK_RELAT TK_NOT_EQUALS_RELAT TK_EQUALS_RELAT TK_PLUS_EQUAL TK_MINUS_EQUAL TK_MULTIPLIES_EQUAL TK_DIVIDES_EQUAL
%token TK_FIM TK_ERROR

%start S

%left '+' '-'
%left '*' '/'
%left '^'
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
            }
            |
            {
                $$.traducao = "";
            }
            ;

COMANDO     : E ';'
            {
                $$.tipo = $1.tipo;
                $$.traducao = "\t" + $1.traducao + ";\n";
            }
            | ATTR ';'
            {
                $$.traducao = "\t" + $1.traducao + ";\n";
            }
            ;

ATTR        : TK_ID '=' E
            {
                string variable_name = set_variable($1.label);
                validate_attribute($3.tipo, variable[$1.label].type);
                $$.traducao = variable_name + " = " + $3.traducao;
            }
            | TK_TIPO TK_ID
            {
                string variable_name = set_variable($2.label, $1.traducao);
                $$.traducao = verify_bool($1.traducao) + " " + variable_name;
            }
            | TK_TIPO TK_ID '=' E
            {
                string variable_name = set_variable($2.label, $1.traducao);
                validate_attribute($4.tipo, variable[$2.label].type);
                $$.traducao = verify_bool($1.traducao) + " " + variable_name + " = " + $4.traducao;
            }
            | TK_ID TK_PLUS_EQUAL E
            {
                string variable_name = set_variable($1.label);
                validate_attribute($3.tipo,variable[$1.label].type);
                $$.traducao = variable_name + " = " + variable_name + " + (" + $3.traducao + ")";
            }
            | TK_ID TK_MINUS_EQUAL E
            {
                string variable_name = set_variable($1.label);
                validate_attribute($3.tipo,variable[$1.label].type);
                $$.traducao = variable_name + " = " + variable_name + " - (" + $3.traducao + ")";
            }
            | TK_ID TK_MULTIPLIES_EQUAL E
            {
                string variable_name = set_variable($1.label);
                validate_attribute($3.tipo,variable[$1.label].type);
                $$.traducao = variable_name + " = " + variable_name + " * (" + $3.traducao + ")";
            }
            | TK_ID TK_DIVIDES_EQUAL E
            {
                string variable_name = set_variable($1.label);
                validate_attribute($3.tipo,variable[$1.label].type);
                $$.traducao = variable_name + " = " + variable_name + " / (" + $3.traducao + ")";
            }
            ;

E           : E '+' E
            {
                $$.tipo = get_operation_type($1.tipo, $3.tipo, "+");
                $$.traducao = $1.traducao + " + " + $3.traducao;
            }
            | E '-' E
            {
                $$.tipo = get_operation_type($1.tipo, $3.tipo, "-");
                $$.traducao = $1.traducao + " - " + $3.traducao;
            }
            | E '*' E
            {
                $$.tipo = get_operation_type($1.tipo, $3.tipo, "*");
                $$.traducao = $1.traducao + " * " + $3.traducao;
            }
            | E '/' E
            {
                $$.tipo = get_operation_type($1.tipo, $3.tipo, "/");
                $$.traducao = $1.traducao + " / " + $3.traducao;
            }
            | '(' E ')'
            {
                $$.tipo = $2.tipo;
                $$.traducao = "(" + $2.traducao + ")";
            }
            | '-' E
            {
                $$.tipo = $2.tipo;
                $$.traducao = "-(" + $2.traducao + ")";
            }
            | E TK_RELAT E
            {
                $$.tipo = "bool";
                $$.traducao = $1.traducao + " " + $2.traducao + " " + $3.traducao;
            }
            | E TK_NOT_EQUALS_RELAT E
            {
                $$.tipo = "bool";
                $$.traducao = "(" + $1.traducao + " != " + $3.traducao + ") || (" + type_value[$1.tipo] + " != " + type_value[$3.tipo] + ")";
            }
            | E TK_EQUALS_RELAT E
            {
                $$.tipo = "bool";
                $$.traducao = "(" + $1.traducao + " == " + $3.traducao + ") && (" + type_value[$1.tipo] + " == " + type_value[$3.tipo] + ")";
            }
            | TK_NUM
            {
                $$.tipo = "int";
                $$.traducao = $1.traducao;
            }
            | TK_REAL
            {
                $$.tipo = "float";
                $$.traducao = $1.traducao;
            }
            | TK_CHAR
            {
                $$.tipo = "char";
                $$.traducao = $1.traducao;
            }
            | TK_BOOL
            {
                $$.tipo = "bool";
                string value = $1.traducao == "true" ? "1" : "0";
                $$.traducao = value;
            }
            | TK_ID
            {
                $$.tipo = variable[$1.label].type;
                string variable_name = set_variable($1.label);
                $$.label = variable_name;
                $$.traducao = variable_name;
            }
            | E TK_AND E
            {
                validate_bool($1.tipo);
                validate_bool($3.tipo);
                $$.tipo = "bool";
                $$.traducao = $1.traducao + " && " + $3.traducao;
            }
            | E TK_OR E
            {
                validate_bool($1.tipo);
                validate_bool($3.tipo);
                $$.tipo = "bool";
                $$.traducao = $1.traducao + " || " + $3.traducao;
            }
            | TK_NOT E
            {
                validate_bool($2.tipo);
                $$.tipo = "bool";
                $$.traducao = "!" + $2.traducao;
            }
            | '(' TK_TIPO ')' E
            {
                assert(validate_cast($2.traducao,$4.tipo));
                $$.tipo = $2.traducao;
                $$.traducao = "(" + $2.traducao + ")(" + $4.traducao + ")";
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

    assert(validate_types(tp1) && validate_types(tp2));
    assert((tp1 != "char") && (tp1 != "bool"));
    assert((tp2 != "char") && (tp2 != "bool"));

    if(tp1 == tp2){

        return tp1;
    }
    else{

        for(int i = 0; i < 4; i++){

            if(tp1 == tabela_operadores[i][0] || tp1 == tabela_operadores[i][1])

                if(tp2 == tabela_operadores[i][1] || tp2 == tabela_operadores[i][0])

                    if(op == tabela_operadores[i][2])

                       return  tabela_operadores[i][3];
        }
    }

    assert(false);
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

string verify_bool(string type){

    if(type=="bool")
      return "int";

    return type;
}

void validate_bool(string type){
    assert(type == "bool");

    return;
}

void validate_attribute(string exp_type, string var_type){
    assert(exp_type == var_type);

    return;
}

bool validate_cast(string tp1,string tp2){

    assert(validate_types(tp1) && validate_types(tp2));
    assert((tp1 != "char") && (tp1 != "bool"));
    assert((tp2 != "char") && (tp2 != "bool"));

    if(tp1 == tp2){
        return true;
    }
    else{

        for(int i = 0; i < 1; i++){

            if(tp1 == cast_table[i][0] || tp1 == cast_table[i][1])
                if(tp2 == cast_table[i][1] || tp2 == cast_table[i][0])
                    return true;
        }
    }

    return false;
}
