%{
#include <iostream>
#include <fstream>
#include <string>
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

    string start_block_label;
    string return_block_label;
    string block;
};

int yylex(void);
void yyerror(string);

%}

%token TK_START TK_END
%token TK_TYPE TK_DYNAMIC_TYPE TK_NUMBER TK_NUMBER_TYPE TK_ID
%token TK_IF TK_ELIF TK_ELSE
%token TK_WHILE TK_REPEAT TK_UNTIL
%token TK_REAL TK_CHAR TK_BOOL TK_STRING
%token TK_OR TK_AND TK_NOT
%token TK_RELAT TK_NOT_EQUALS_RELAT TK_EQUALS_RELAT
%token TK_PLUS_EQUAL TK_MINUS_EQUAL TK_MULTIPLIES_EQUAL TK_DIVIDES_EQUAL
%token TK_DOUBLE_COLON TK_SHIFT_LEFT TK_SHIFT_RIGHT
%token TK_OUT_LINE

%start S

%left '+' '-'
%left '*' '/' '%'
%left '^'
%left '(' ')'

%%

S           : MAIN
            {
                ofstream compiled("compiled.cpp");
                if(compiled.is_open()){
                    compiled << "/*Cry me a Ocean*/\n\n#include <iostream>\n\nusing namespace std;\n\n";
                    compiled << "int main(){\n";
                    compiled << $1.attributions;
                    compiled << "\n //---- FIM DAS ATRIBUIÇÕES ----\n\n";
                    compiled << $1.translate;
                    compiled << "\n \treturn 0;\n\n";
                    compiled << $1.block;
                    compiled << "}\n";
                    cout << "Compilation success!" << endl;
                    compiled.close();
                }
                else
                    cout << "Unable to open file. Couldn\'t generate intermediary code.";

                // ofstream compiled_sentence("compiled_sentence.cpp");
                // if(compiled_sentence.is_open()){
                //     compiled_sentence << "/*Cry me a Ocean*/\n#include <iostream>\n#include <string>\n";
                //     compiled_sentence << "int main(){\n";
                //     compiled_sentence << $1.sentence;
                //     compiled_sentence << "\n \treturn 0;\n}\n";
                //     cout << "Compilation Sentence success!" << endl;
                //     compiled_sentence.close();
                // }
                // else
                //     cout << "Unable to open file. Couldn\'t generate intermediary code.";

                for(auto i : variable)
                    cout << i.first << " : " << "[" << i.second.type << ","<< i.second.tmp << "]" << endl;
                }
                ;

MAIN        : TK_START BLOCK
            {
                $$.attributions = $2.attributions;
                $$.translate = $2.translate;

                $$.block = $2.block;
            }
            ;

BLOCK       : ':' COMMANDS TK_END '\n'
            {
                $$.attributions = $2.attributions;
                $$.translate = $2.translate;

                $$.block = $2.block;
            }
            ;

WHILE_COM   : TK_WHILE EXP BLOCK
            {
                $$.start_block_label = current_label();
                $$.return_block_label = current_label();

                $$.attributions = $2.attributions;
                $$.translate = "\t" + $$.return_block_label + ":\n" + $2.translate + "\n\tif(" + $2.temp + ") goto " + $$.start_block_label + ";\n";

                $$.block = "\t" + $$.start_block_label + ":\n" + $3.attributions + $3.translate + "\tgoto " + $$.return_block_label + ";\n\n" + $3.block;
            }
            ;

DO_WHILE_COM: TK_REPEAT ':' COMMANDS TK_UNTIL EXP
            {
                string label_auto_return = current_label();

                $$.start_block_label = current_label();
                $$.return_block_label = current_label();

                $$.attributions = $5.attributions;
                $$.translate = "\t" + label_auto_return + ":\n\tgoto " + $$.start_block_label + ";\n\t" + $$.return_block_label + ":\n" + $5.translate + "\tif(" + $5.temp + ") goto " + label_auto_return + ";\n";

                $$.block = "\t" + $$.start_block_label + ":\n" + $3.attributions + $3.translate + "\tgoto " + $$.return_block_label + ";\n\n" + $3.block;
            }
            ;

IF_COMMAND  : TK_IF EXP BLOCK
            {
                $$.start_block_label = current_label();
                $$.return_block_label = current_label();

                $$.attributions = $2.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + $$.start_block_label + ";\n\t" + $$.return_block_label + ":\n";

                $$.block = "\t" + $$.start_block_label + ":\n" + $3.attributions + $3.translate + "\tgoto " + $$.return_block_label + ";\n\n" + $3.block;
            }
            | TK_IF EXP ':' COMMANDS ELSE_BLOCK
            {
                $$.start_block_label = current_label();
                $$.return_block_label = $5.return_block_label;

                $$.attributions = $2.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + $$.start_block_label + ";\n" + $5.translate;

                $$.block = "\t" + $$.start_block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + $$.return_block_label + ";\n\n" + $5.block + "\n" + $4.block;
            }
            | TK_IF EXP ':' COMMANDS ELIF_BLOCK
            {
                $$.start_block_label = current_label();
                $$.return_block_label = $5.return_block_label;

                $$.attributions = $2.attributions + $5.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + $$.start_block_label + ";\n" + $5.translate;;

                $$.block = "\t" + $$.start_block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + $$.return_block_label + ";\n\n" + $5.block + "\n" + $4.block;
            }
            ;

ELIF_BLOCK  : TK_ELIF EXP BLOCK
            {
                $$.start_block_label = current_label();
                $$.return_block_label = current_label();

                $$.attributions = $2.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + $$.start_block_label + ";\n\t" + $$.return_block_label + ";\n";

                $$.block = "\t" + $$.start_block_label + ":\n" + $3.attributions + $3.translate + "\tgoto " + $$.return_block_label + ";\n\n" + $3.block;
            }
            | TK_ELIF EXP ':' COMMANDS ELIF_BLOCK
            {
                $$.start_block_label = current_label();
                $$.return_block_label = $5.return_block_label;

                $$.attributions = $2.attributions + $5.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + $$.start_block_label + ";\n" + $5.translate;
                $$.block = "\t" + $$.start_block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + $$.return_block_label + ";\n\n" + $5.block + "\n" + $4.block;
            }
            | TK_ELIF EXP ':' COMMANDS ELSE_BLOCK
            {
                $$.start_block_label = current_label();
                $$.return_block_label = $5.return_block_label;

                $$.attributions = $2.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + $$.start_block_label + ";\n" + $5.translate;

                $$.block = "\t" + $$.start_block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + $$.return_block_label + ";\n\n" + $5.block + "\n" + $4.block;
            }
            ;

ELSE_BLOCK  : TK_ELSE BLOCK
            {
                $$.start_block_label = current_label();
                $$.return_block_label = current_label();

                $$.attributions = "";
                $$.translate = "\tgoto " + $$.start_block_label + ";\n\t" + $$.return_block_label + ":\n";

                $$.block = "\t" + $$.start_block_label + ":\n" + $2.attributions + $2.translate
                            + "\tgoto " + $$.return_block_label + ";\n\n" + $2.block;
            }
            ;

COMMANDS    : COMMAND COMMANDS
            {
                $$.attributions = $1.attributions + $2.attributions;
                $$.translate = $1.translate + $2.translate;
                $$.block = $1.block + $2.block;
            }
            |
            {
                $$.attributions = "";
                $$.translate = "";
                $$.block = "";
            }
            ;

COMMAND     : EXP '\n'
            {
                $$.type = $1.type;
                $$.attributions = $1.attributions;
                $$.translate = $1.translate;
                $$.block = "";
            }
            | ATTR '\n'
            {
                $$.attributions = $1.attributions;
                $$.translate = $1.translate;
                $$.block = "";
            }
            | IF_COMMAND
            {
                $$.attributions = $1.attributions;
                $$.translate = $1.translate;
                $$.block = $1.block;
            }
            | WHILE_COM
            {
                $$.attributions = $1.attributions;
                $$.translate = $1.translate;
                $$.block = $1.block;
            }
            | DO_WHILE_COM
            {
                $$.attributions = $1.attributions;
                $$.translate = $1.translate;
                $$.block = $1.block;
            }
            | '\n'
            {
                $$.attributions = "";
                $$.translate = "";
                $$.block = "";
            }
            | TK_OUT_LINE TK_SHIFT_LEFT EXP '\n'
            {
                $$.attributions = "";
                $$.translate = "\tcout << " + $3.temp + " << endl;\n";
            }
            ;

ATTR        : TK_TYPE TK_ID
            {
                $$.type = $1.translate;
                $$.temp = set_variable($2.label, $1.translate);
                $$.attributions = '\t' + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = "";
            }
            | TK_NUMBER TK_ID
            {
                $$.type = get_type($1.translate);
                $$.temp = set_variable($2.label, $$.type);
                $$.attributions = '\t' + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = "";
            }
            | TK_TYPE TK_ID '=' EXP
            {
                $$.type = $1.translate;
                $$.temp = set_variable($2.label, $1.translate);
                $$.attributions = $4.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $4.translate + '\t' + $$.temp + " = " + $4.temp + ";\n";
            }
            | TK_NUMBER TK_ID '=' EXP
            {
                $$.type = get_type($1.translate);
                $$.temp = set_variable($2.label, $1.translate);
                $$.attributions = $4.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $4.translate + '\t' + $$.temp + " = " + $4.temp + ";\n";
            }
            | TK_ID '=' EXP
            {
                $$.type = get_variable($1.label).type;
                $$.temp = get_variable($1.label).tmp;
                $$.attributions = $3.attributions;
                $$.translate = $3.translate + '\t' + $$.temp + " = " + $3.temp + ";\n";
            }
            ;

EXP         : EXP '+' EXP
            {
                $$.type = get_type(get_operation_type($1.type, $3.type, "+"));
                cout << $$.type << endl;
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $1.attributions + $3.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $1.translate + $3.translate + "\t" + $$.temp + " = " + $1.temp + " + " + $3.temp + ";\n";
            }
            | EXP '-' EXP
            {
                $$.type = get_type(get_operation_type($1.type, $3.type, "-"));
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $1.attributions + $3.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $1.translate + $3.translate + "\t" + $$.temp + " = " + $1.temp + " - " + $3.temp + ";\n";
            }
            | EXP '*' EXP
            {
                $$.type = get_type(get_operation_type($1.type, $3.type, "*"));
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $1.attributions + $3.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $1.translate + $3.translate + "\t" + $$.temp + " = " + $1.temp + " * " + $3.temp + ";\n";
            }
            | EXP '/' EXP
            {
                $$.type = get_type(get_operation_type($1.type, $3.type, "/"));
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $1.attributions + $3.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $1.translate + $3.translate + "\t" + $$.temp + " = " + $1.temp + " / " + $3.temp + ";\n";
            }
            | EXP '%' EXP
            {
                $$.type = get_type(get_operation_type($1.type, $3.type, "%"));
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $1.attributions + $3.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $1.translate + $3.translate + "\t" + $$.temp + " = " + $1.temp + " % " + $3.temp + ";\n";
            }
            | EXP TK_RELAT EXP
            {
                $$.type = get_operation_type($1.type, $3.type, $2.translate);
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $1.attributions + $3.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $1.translate + $3.translate + "\t" + $$.temp + " = "
                                + $1.temp + " " + $2.translate + " " + $3.temp + ";\n";
            }
            /*| '|' EXP '|'
            {
                $$.type = get_operation_type($2.type, "-");
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $2.attributions + "\t" + $$.type + " " + $$.temp + ";\n";
                $$.translate = $2.translate + "\t" + $$.temp + " = " + " | " + $2.temp + " | " + ";\n";
            }*/
            | EXP TK_OR EXP
            {
                $$.type = get_operation_type($1.type, $3.type, $2.translate);
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $1.attributions + $3.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $1.translate + $3.translate + "\t" + $$.temp + " = " + $1.temp + " || " + $3.temp + ";\n";
            }
            | EXP TK_AND EXP
            {
                $$.type = get_operation_type($1.type, $3.type, $2.translate);
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = $1.attributions + $3.attributions + "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = $1.translate + $3.translate + "\t" + $$.temp + " = " + $1.temp + " && " + $3.temp + ";\n";
            }
            | TK_REAL
            {
                $$.type = "float64";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = " + $1.translate + ";\n";
            }
            | TK_STRING
            {
                $$.type = "string";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = (char*)\"" + $1.translate.substr(1, $1.translate.length() - 2) + "\";\n";
            }
            | TK_CHAR
            {
                $$.type = "char";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = " + $1.translate + ";\n";
            }
            | TK_BOOL
            {
                $$.type = "bool";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = " + parse_boolean($1.translate) + ";\n";
            }
            | TK_ID
            {
                $$.type = get_variable($1.label).type;
                $$.temp = get_variable($1.label).tmp;
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
