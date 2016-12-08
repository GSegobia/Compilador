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
                $$.attributions = $1.attributions;
                $$.translate = $1.translate;
            }
            | ATTR '\n'
            {
                $$.attributions = $1.attributions;
                $$.translate = $1.translate;
            }
            | '\n'
            {
                $$.attributions = "";
                $$.translate = "";
            }
            ;

ATTR        : TK_TYPE TK_ID
            {
                $$.type = $1.translate;
                $$.temp = set_variable($2.label, $1.translate);
                $$.attributions = verify_bool($$.type) + " " + $$.temp;
                $$.translate = "";
            }
            | TK_NUMBER TK_ID
            {
                $$.type = get_type($1.translate);
                $$.temp = set_variable($2.label, $$.type);
                $$.attributions = $$.type + " " + $$.temp;
                $$.translate = "";
            }
            | TK_TYPE TK_ID '=' EXP
            {
                $$.type = $1.translate;
                $$.temp = set_variable($2.label, $1.translate);
                $$.attributions = $4.attributions + "\t" + verify_bool($$.type) + " " + $$.temp + ";\n";
                $$.translate = $4.translate + '\t' + $$.temp + " = " + $4.temp + ";\n";
            }
            | TK_NUMBER TK_ID '=' EXP
            {
                $$.type = get_type($1.translate);
                $$.temp = set_variable($2.label, $1.translate);
                $$.attributions = $4.attributions + "\t" + $$.type + " " + $$.temp + ";\n";
                $$.translate = $4.translate + '\t' + $$.temp + " = " + $4.temp + ";\n";
            }
            | TK_ID '=' EXP
            {
                $$.type = get_variable_type($1.translate);
                $$.temp = get_variable_temp($1.translate);
                $$.attributions = $3.attributions;
                $$.translate = $3.translate + '\t' + $$.temp + " = " + $3.temp + ";\n";
            }
            ;

EXP         : EXP '+' EXP
            {
                $$.type = get_operation_type($1.type, $3.type, "+");
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $1.attributions + $3.attributions + "\t" + $$.type + " " + $$.temp + ";\n";
                $$.translate = $1.translate + $3.translate + "\t" + $$.temp + " = " + $1.temp + " + " + $3.temp + ";\n";

            }
            | TK_NUM
            {
                $$.type = "int";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + $$.type + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = " + $1.translate + ";\n";
            }
            | TK_REAL
            {
                $$.type = "float";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + $$.type + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = " + $1.translate + ";\n";
            }
            | TK_CHAR
            {
                $$.type = "char";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + $$.type + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = " + $1.translate + ";\n";
            }
            | TK_BOOL
            {
                $$.type = "bool";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + $$.type + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = " + $1.translate + ";\n";
            }
            | TK_ID
            {
                $$.type = get_variable_type($1.label);
                $$.temp = get_variable_temp($1.label);
                $$.attributions = "";
                $$.translate = "";
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
