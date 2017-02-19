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
    string block;
};

int yylex(void);
void yyerror(string);

%}

%token TK_START TK_END
%token TK_TYPE TK_DYNAMIC_TYPE TK_NUMBER TK_NUMBER_TYPE TK_ID
%token TK_IF TK_ELIF TK_ELSE
%token TK_PLUS_PLUS TK_MINUS_MINUS
%token TK_WHILE TK_REPEAT TK_UNTIL
%token TK_CONTINUE TK_BREAK
%token TK_SWITCH TK_CASE TK_DEFAULT
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

                cout << "Loop Stack Size: " << loop_stack.size() << endl;
                cout << "Conditional Return Stack Size: " << conditional_return_stack.size() << endl;
                cout << "Switch Variable Size: " << switch_temp.size() << endl;
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

WHILE_COM   : WHILE EXP BLOCK
            {
                string label_block = current_label();

                $$.attributions = $2.attributions;
                $$.translate = "\t" + loop_stack.top().start_block + ":\n" + $2.translate + "\tif(" + $2.temp + ") goto " + label_block + ";\n\t" + loop_stack.top().return_block + ":\n";

                $$.block = "\t" + label_block + ":\n" + $3.attributions + $3.translate + "\tgoto " + loop_stack.top().start_block + ";\n\n" + $3.block;

                loop_stack.pop();
                /*
                LABEL_6:
            	tmp_25 = tmp_13 < tmp_1;
            	if(tmp_25) goto LABEL_5;

                É necessário criar uma label após o if para ser o return_block.

                Forma esperada:
                    LABEL_5:
                	tmp_25 = tmp_13 < tmp_1;
                	if(tmp_25) goto LABEL_7;
                    LABEL_6:

                loop_stack.top().start_block = LABEL_5
                loop_stack.top().return_block = LABEL_6
                (Variável auxiliar de retorno) block_end = LABEL_7

                break - goto LABEL_6
                continue - goto LABEL_5

                LABEL_5:
            	tmp_25 = tmp_13 < tmp_1;
            	if(tmp_25) goto LABEL_7;
            	LABEL_6:
                */
            }
            ;

WHILE      : TK_WHILE
            {
                push_loop_block();
            }
            ;

DO_WHILE_COM: REPEAT ':' COMMANDS TK_UNTIL EXP '\n'
            {
                string label_block = current_label();

                $$.attributions = $5.attributions;
                $$.translate = "\tgoto " + label_block + ";\n\t" + loop_stack.top().start_block + ":\n" + $5.translate + "\tif(" + $5.temp + ") goto " + label_block + ";\n\t" + loop_stack.top().return_block + ":\n";

                $$.block = "\t" + label_block + ":\n" + $3.attributions + $3.translate + "\tgoto " + loop_stack.top().start_block + ";\n\n" + $3.block;

                loop_stack.pop();
                /*
                LABEL_9:
            	goto LABEL_7;
            	LABEL_8:
            	tmp_30 = tmp_1 < tmp_3;
            	if(tmp_30) goto LABEL_9;

                Ao invés de ir para LABEL_9 o goto do if deveria ir direto para LABEL_7 fazendo com que LABEL_9
                seja desnecessário nesse caso.

                É necessário criar uma label após o if para ser o return_block.

                Forma esperada:
                    goto LABEL_9;
                    LABEL_7:
                    tmp_30 = tmp_1 < tmp_3;
                    if(tmp_30) goto LABEL_9;
                    LABEL_8:

                loop_stack.top().start_block = LABEL_7
                loop_stack.top().return_block = LABEL_8
                (Variável auxiliar de retorno) block_end = LABEL_9

                break - goto LABEL_8
                continue - goto LABEL_7

                goto LABEL_9;
            	LABEL_7:
            	tmp_30 = tmp_1 < tmp_3;
            	if(tmp_30) goto LABEL_9;
            	LABEL_8:
                */
            }
            ;

REPEAT      : TK_REPEAT
            {
                push_loop_block();
            }
            ;

IF_COMMAND  : IF EXP BLOCK
            {
                string block_label = current_label();

                $$.attributions = $2.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + block_label + ";\n\t" + conditional_return_stack.top() + ":\n";

                $$.block = "\t" + block_label + ":\n" + $3.attributions + $3.translate + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $3.block;

                conditional_return_stack.pop();
            }
            | IF EXP ':' COMMANDS ELSE_BLOCK
            {
                string block_label = current_label();

                $$.attributions = $2.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + block_label + ";\n" + $5.translate;

                $$.block = "\t" + block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $5.block + "\n" + $4.block;

                conditional_return_stack.pop();
            }
            | IF EXP ':' COMMANDS ELIF_BLOCK
            {
                string block_label = current_label();

                $$.attributions = $2.attributions + $5.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + block_label + ";\n" + $5.translate;;

                $$.block = "\t" + block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $5.block + "\n" + $4.block;

                conditional_return_stack.pop();
            }
            ;

ELIF_BLOCK  : TK_ELIF EXP BLOCK
            {
                string block_label = current_label();

                $$.attributions = $2.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + block_label + ";\n\t" + conditional_return_stack.top() + ";\n";

                $$.block = "\t" + block_label + ":\n" + $3.attributions + $3.translate + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $3.block;
            }
            | TK_ELIF EXP ':' COMMANDS ELIF_BLOCK
            {
                string block_label = current_label();

                $$.attributions = $2.attributions + $5.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + block_label + ";\n" + $5.translate;
                $$.block = "\t" + block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $5.block + "\n" + $4.block;
            }
            | TK_ELIF EXP ':' COMMANDS ELSE_BLOCK
            {
                string block_label = current_label();

                $$.attributions = $2.attributions;
                $$.translate = $2.translate + "\tif(" + $2.temp + ") goto " + block_label + ";\n" + $5.translate;

                $$.block = "\t" + block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $5.block + "\n" + $4.block;
            }
            ;

ELSE_BLOCK  : TK_ELSE BLOCK
            {
                string block_label = current_label();

                $$.attributions = "";
                $$.translate = "\tgoto " + block_label + ";\n\t" + conditional_return_stack.top() + ":\n";

                $$.block = "\t" + block_label + ":\n" + $2.attributions + $2.translate
                            + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $2.block;
            }
            ;

IF          : TK_IF
            {
                conditional_return_stack.push(current_label());
            }
            ;

SWITCH_COM  : SWITCH PRIMITIVE ':' '\n' CASE
            {
                variable[switch_temp.top()].type = $2.type;

                $$.attributions = "\t" + get_type(variable[switch_temp.top()].type) + " " + variable[switch_temp.top()].tmp + ";//ATTRIBUTION SWITCH\n" + $5.attributions;

                $$.translate = "\t" + variable[switch_temp.top()].tmp + " = " + $2.temp + ";//DECLARATION SWITCH\n" +   $5.translate;

                $$.block = $5.block;

                switch_temp.pop();
                conditional_return_stack.pop();
            }
            ;

CASE        : TK_CASE PRIMITIVE ':' COMMANDS TK_END
            {
                string block_label = current_label();

                $$.type = "bool";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + $$.type + " " + $$.temp + ";\n" + $2.attributions;

                $$.translate = $2.translate + "\t" + $$.temp + " = " + variable[switch_temp.top()].tmp + " == " + $2.temp + ";\n\tif(" + $$.temp + ") goto " + block_label + ";\n\t" + conditional_return_stack.top() + ":\n";

                $$.block = "\t" + block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $4.block;
            }
            | TK_CASE PRIMITIVE ':' COMMANDS CASE
            {
                string block_label = current_label();

                $$.type = "bool";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + $$.type + " " + $$.temp + ";\n" + $2.attributions + $5.attributions;

                $$.translate = $2.translate + "\t" + $$.temp + " = " + variable[switch_temp.top()].tmp + " == " + $2.temp + ";\n\tif(" + $$.temp + ") goto " + block_label + ";\n" + $5.translate;

                $$.block = "\t" + block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $5.block + $4.block;
            }
            | TK_CASE PRIMITIVE ':' COMMANDS DEFAULT
            {
                string block_label = current_label();

                $$.type = "bool";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + $$.type + " " + $$.temp + ";\n" + $2.attributions + $5.attributions;

                $$.translate = $2.translate + "\t" + $$.temp + " = " + variable[switch_temp.top()].tmp + " == " + $2.temp + ";\n\tif(" + $$.temp + ") goto " + block_label + ";\n" + $5.translate;

                $$.block = "\t" + block_label + ":\n" + $4.attributions + $4.translate + "\tgoto " + conditional_return_stack.top() + ";\n\n" + $5.block + "\n" + $4.block;
            }
            ;

DEFAULT     : TK_DEFAULT ':' COMMANDS TK_END
            {
                string block_label = current_label();

                $$.type = "";
                $$.temp = "";
                $$.attributions = "";
                $$.translate = "\tgoto " + block_label + ";\n\t" + conditional_return_stack.top() + ":\n";

                $$.block = "\t" + block_label + ":\n" + $3.attributions + $3.translate + "\tgoto " + conditional_return_stack.top() + ";\n" + $3.block;
            }
            ;

SWITCH      : TK_SWITCH
            {
                string current_var = current_exp();
                set_variable(current_var, "undefined");
                switch_temp.push(current_var);

                conditional_return_stack.push(current_label());
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
            | SWITCH_COM
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
                $$.block = "";
            }
            | TK_BREAK '\n'
            {
                $$.attributions = "";
                $$.translate = break_to();
                $$.block = "";
            }
            | TK_CONTINUE '\n'
            {
                $$.attributions = "";
                $$.translate = continue_to();
                $$.block = "";
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
            | PRIMITIVE
            {
                $$.type = $1.type;
                $$.temp = $1.temp;
                $$.attributions = $1.attributions;
                $$.translate = $1.translate;
            }
            | UNARY_EXP
            {
                $$.type = $1.type;
                $$.temp = $1.temp;
                $$.attributions = $1.attributions;
                $$.translate = $1.translate;
            }
            ;

UNARY_EXP   : VARIABLE TK_PLUS_PLUS
            {
                cout << $1.type << endl;
                $$.type = get_unary_operation_type($1.type, $2.translate);
                $$.temp = $1.temp;
                $$.attributions = "";
                $$.translate = $1.translate + "\t" + $$.temp + " = " + $$.temp + " + 1;\n";
            }
            | VARIABLE TK_MINUS_MINUS
            {
                $$.type = get_unary_operation_type($1.type, $2.translate);
                $$.temp = $1.temp;
                $$.attributions = "";
                $$.translate = $1.translate + "\t" + $$.temp + " = " + $$.temp + " - 1;\n";
            }
            ;

PRIMITIVE   : TK_REAL
            {
                $$.type = "float64";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = " + $1.translate + ";\n";
            }
            | '-' TK_REAL
            {
                $$.type = "float64";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = -" + $2.translate + ";\n";
            }
            | '+' TK_REAL
            {
                $$.type = "float64";
                $$.temp = set_variable(current_exp(), $$.type);
                $$.attributions = "\t" + get_type($$.type) + " " + $$.temp + ";\n";
                $$.translate = "\t" + $$.temp +" = " + $2.translate + ";\n";
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
            | VARIABLE
            {
                $$.type = $1.type;
                $$.temp = $1.temp;
                $$.attributions = "";
                $$.translate = "";
            }
            ;

VARIABLE    : TK_ID
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
