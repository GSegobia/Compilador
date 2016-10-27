%{
#include "functions.h"

#define YYSTYPE attributes

using namespace std;

struct attributes{

    string label;
    string type;
    string temp;
    string attributions;
    string translate;
    string sentence;
};

int yylex(void);
void yyerror(string);

%}

%token TK_START TK_END
%token TK_TYPE TK_DYNAMIC_TYPE TK_NUMBER TK_NUMBER_TYPE TK_ID
%token TK_NUM TK_REAL TK_CHAR TK_BOOL
%token TK_OR TK_AND TK_NOT
%token TK_RELAT TK_NOT_EQUALS_RELAT TK_EQUALS_RELAT
%token TK_PLUS_EQUAL TK_MINUS_EQUAL TK_MULTIPLIES_EQUAL TK_DIVIDES_EQUAL

%start S

%left '+' '-'
%left '*' '/'
%left '^'
%left '(' ')'

%%

S           : TK_START BLOCK
            {
                cout << "/*Cry me a Ocean*/\n" << "#include <iostream>\n#include<string.h>\n#include<stdio.h>\nint main(void)\n{\n" << $2.attributions << $2.translate <<"\treturn 0;\n}" << endl;
            }
            ;

BLOCK       : ':' COMMANDS TK_END '\n'
            {
                $$.attributions = $2.attributions;
                $$.translate = $2.translate;
            }
            ;

COMMANDS    : COMMAND COMMANDS
            {
                $$.attributions = $1.attributions + $2.attributions;
                $$.translate = $1.translate + $2.translate;
            }
            |
            {
                $$.attributions = "";
                $$.translate = "";
            }
            ;

COMMAND     : EXP '\n'
            {
                $$.type = $1.type;
                $$.translate = "\t" + $1.translate + ";\n";
            }
            | ATTR '\n'
            {
                $$.attributions = "\t" + $1.attributions + ";\n";
                $$.translate = "\t" + $1.translate + ";\n";
            }
            | '\n'
            {
                $$.attributions = "";
                $$.translate = "";
            }
            ;

ATTR        : TK_ID '=' EXP
            {
                $$.translate = "";
            }
            | TK_TYPE TK_ID
            {
                string var_aux = set_variable($2.label, $1.translate);

                $$.type = get_type($1.translate);
                $$.temp = var_aux;
                $$.attributions = $$.type + " " + $$.temp;
                $$.translate = "";
            }
            | TK_NUMBER TK_ID
            {
                $$.attributions = get_type($1.translate) + " " + set_variable($2.label, $1.translate);
                $$.translate = "";
            }
            ;

EXP         : EXP '+' EXP
            {
                $$.type = get_operation_type($1.translate, $3.translate, "+");
                $$.temp = set_variable(current_exp());
                $$.attributions = $1.attributions + $3.attributions + ";\n\t";
                $$.translate = define_translation($1.translate, $1.temp) + " + " + define_translation($3.translate, $3.temp);

            }
            | TK_NUM
            {
                $$.type = "int";
                $$.temp = "";
                $$.attributions = "";
                $$.translate = $1.translate;
                $$.sentence = "";
            }
            | TK_REAL
            {
                $$.type = "float";
                $$.temp = "";
                $$.attributions = "";
                $$.translate = $1.translate;
                $$.sentence = "";
            }
            | TK_CHAR
            {
                $$.type = "char";
                $$.temp = "";
                $$.attributions = "";
                $$.translate = $1.translate;
                $$.sentence = "";
            }
            | TK_BOOL
            {
                $$.type = "bool";
                $$.temp = "";
                $$.attributions = "";
                $$.translate = $1.translate;
                $$.sentence = "";
            }
            | TK_ID
            {
                $$.type = get_variable_type($1.label);
                $$.temp = "";
                $$.attributions = "";
                $$.translate = get_variable_temp($1.label);
                $$.sentence = "";
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
