#include <iostream>
#include <cstdlib>
#include <sstream>
#include <map>
#include <cassert>

#define OPERATORS 5
#define CAST 2
#define TYPES 5

using namespace std;

typedef struct{

    string type;
    string tmp;
}META_VAR;

map<string, META_VAR> variable;

string types[] = {"float", "int", "bool", "char", "number"};

string cast_table[][CAST] ={
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
