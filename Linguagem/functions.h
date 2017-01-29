#include "tables.h"

bool validate_type(string type){

    for(int i = 0; i < TYPES; i++){

        if(type == types[i])
            return true;
    }

    cout << "Type " << type << " is not a valid type." << endl;
    exit(EXIT_FAILURE);
}

string get_type(string type){
  
    validate_type(type);

    if(type == "number")
        return "float";

    return type;
}

string current_exp(){

    static unsigned long var_exp = 0;

    string var = "tmp_" + to_string(var_exp);

    var_exp++;

    return var;
}

string current_temp(){

    static unsigned long var_number = 0;

    string var = "tmp_" + to_string(var_number);

    var_number++;

    return var;
}

string set_variable(string var_name, string var_type = ""){

    META_VAR var_aux;

    if(variable.count(var_name) > 0){

        cout << "Variable " << var_name << " was declared before." << endl;
        exit(EXIT_FAILURE);
    }

    var_aux.type = get_type(var_type);
    var_aux.tmp = current_temp();

    variable.insert(pair<string, META_VAR>(var_name, var_aux));

    return var_aux.tmp;
}

//código antigo, é usada a get_type atualmente
string get_variable_type(string var_name){

    if(variable.count(var_name) == 0){

        cout << "Variable " << var_name << " not defined." << endl;
        exit(EXIT_FAILURE);
    }

    META_VAR var_aux = variable[var_name];

    return var_aux.type;
}

string get_variable_temp(string var_name){

    if(variable.count(var_name) == 0){

        cout << "Variable " << var_name << " not defined." << endl;
        exit(EXIT_FAILURE);
    }

    META_VAR var_aux = variable[var_name];

    return var_aux.tmp;
}

string verify_bool(string type){

    if(type=="bool")
      return "int";

    return type;
}

string boolean_operation(string type1, string type2, string op){

  validate_type(type1);
  validate_type(type2);

  if(type1 == "bool" and type2 == "bool")
    return "int";

  cout << "Type \'" << type1 << "\' can not \'" << op << "\' type \'" << type2 << "\'." << endl;
  exit(EXIT_FAILURE);
}

string boolean_value(string value){

  if(value == "true")
    return "1";

  return "0";
}

//Corrigir essa função
string get_operation_type(string type1, string type2, string op){

    validate_type(type1);
    validate_type(type2);

    if(type1 == type2)
      return type1;



    string type = "";

    for(int i = 0; i < OPERATORS; i++){

        if(op_table[i][0] == type1 || op_table[i][1] == type1){

            if(op_table[i][0] == type2 || op_table[i][1] == type2){

                if(op_table[i][2] == op){

                    type = op_table[i][3];
                    break;
                }
            }
        }
    }

    if(type == ""){

        cout << "Type \'" << type1 << "\' can not \'" << op << "\' type \'" << type2 << "\'." << endl;
        exit(EXIT_FAILURE);
    }

    return type;
}
