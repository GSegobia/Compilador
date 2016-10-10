#include <cstdio>
#include <iostream>
#include <string>
#include <cassert>

using namespace std;

string types[] = {"float", "int"};

string tabela_operadores[][4] = {
                            {"float", "int", "+", "float"},
                            {"float", "int", "-", "float"},
                            {"float", "int", "*", "float"},
                            {"float", "int", "/", "float"}
                        };


bool validate_types(string type){

    bool valid = false;

    for(int i = 0; i < 2; i++){

        if(type == types[i]){
            valid = true;
        }
    }

    return valid;
}

string get_tabela_op(string tp1, string tp2, string op){

    string operation="";

    assert(validate_types(tp1) && validate_types(tp2));

    if(tp1==tp2){
        return tp1;
    }
    else{
        for(int i=0;i<4;i++){
            if(tp1 == tabela_operadores[i][0] | tp1 == tabela_operadores[i][1])
                if(tp2 == tabela_operadores[i][1] | tp2 == tabela_operadores[i][0])
                    if(op == tabela_operadores[i][2])
                       return  tabela_operadores[i][3];
        }
    }

    return "ERROOOU";

}


int main(){


    cout << get_tabela_op("int","float","/") << endl;

}