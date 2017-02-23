#include <iostream>
#include <cstdlib>
#include <sstream>
#include <map>
#include <list>
#include <stack>
#include <vector>
#include <algorithm>
#include <cassert>

#define OPERATORS 5
#define CAST 2
#define TYPES 5

using namespace std;

struct META_VAR{

    string type;
    string tmp;
};

struct META_FUNC{

    string name;
    string tmp_name;
    string type;
    vector<string> args;
    vector<string> args_types;
    vector<string> ordered_args_types;
};

struct LABELS{

    string start_block;
    string return_block;
};

map<string, META_VAR> variable;

string types[] = {"float", "int", "bool", "char", "number"};

string cast_table[][CAST] = {
                                {"float","int"}
                            };

string op_table[][OPERATORS] = {
                                        {"float", "int", "+", "float"},
                                        {"float", "int", "-", "float"},
                                        {"float", "int", "*", "float"},
                                        {"float", "int", "/", "float"},
                                        {"float", "int", "%", "float"}
                                    };

map<string,string> type_value = {
                                        {"float", "0"},
                                        {"int", "1"},
                                        {"bool", "2"},
                                        {"char", "3"}
                                    };

map<string, string> types_map = {
                                              {"undefined", "undefined"},
                                              {"number", "double"},
                                              {"number*", "double*"},
                                              {"void", "void"},
                                              {"string", "char*"},
                                              {"char", "char"},
                                              {"bool", "int"},
                                              {"bool*", "int*"}
                                        };

map<string, list<string>> implicit_cast = {
                                                    {"float64", {}},
                                                    {"float32", {"float64"}},
                                                    {"int64", {}},
                                                    {"int32", {"float64", "int64", "int32"}},
                                                    {"int16", {"int32", "int64", "float32", "float64"}}
                                              };

map<string, string> op_type = {
                                    {"+", "number"},
                                    {"-", "number"},
                                    {"*", "number"},
                                    {"/", "number"},
                                    {"%", "number"},
                                    {"and", "bool"},
                                    {"or", "bool"},
                                    {"not", "bool"},
                                    {"==", "bool"},
                                    {"!=", "bool"},
                                    {"<", "bool"},
                                    {"<=", "bool"},
                                    {">", "bool"},
                                    {">=", "bool"}
                              };

map<string, string> unary_op_type = {
                                        {"++", "number"},
                                        {"--", "number"},
                                        {"not", "bool"}
                                    };

stack<LABELS> loop_stack;
stack<string> conditional_return_stack;
stack<string> switch_temp;
vector<META_FUNC> functions_list;
META_FUNC current_function;
map<string, META_VAR> global_scope;
vector<map<string, META_VAR>> scope_variables = {global_scope};
stack<string> return_types;
vector<string> stack_arg_functions;
bool isFunction = false;
