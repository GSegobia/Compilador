#include <iostream>
#include <cstdlib>
#include <sstream>
#include <map>
#include <list>
#include <cassert>

#define OPERATORS 4
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
                                    {"float", "int", "/", "float"}
                                };

map<string,string> type_value = {
                                    {"float", "0"},
                                    {"int", "1"},
                                    {"bool", "2"},
                                    {"char", "3"}
                                };

static map<string, string> types_map = {
                                              {"number", "float64"},
                                              {"float64", "double"},
                                              {"float32", "float"},
                                              {"int64", "long int"},
                                              {"int32", "int"},
                                              {"int16", "short int"},
                                              {"string", "char *"},
                                              {"char", "char"},
                                              {"bool", "int"}
                                            };

static map<string, list<string>> implicit_cast = {
                                                {"float64", {}},
                                                {"float32", {"float64"}},
                                                {"int64", {}},
                                                {"int32", {"float64", "int64", "int32"}},
                                                {"int16", {"int32", "int64", "float32", "float64"}}
                                              };
