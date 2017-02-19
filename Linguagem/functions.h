#include "tables.h"

bool validate_type(string type){

    if(types_map[type] != "")
        return true;

    cout << "Type " << type << " is not a valid type." << endl;
    exit(EXIT_FAILURE);
}

string get_type(string type){

    validate_type(type);

    return types_map[type];
}

string current_exp(){

    static unsigned long var_exp = 0;

    string var = "_tmp_" + to_string(var_exp);

    var_exp++;

    return var;
}

string current_temp(){

    static unsigned long var_number = 0;

    string var = "tmp_" + to_string(var_number);

    var_number++;

    return var;
}

string set_variable(string var_name, string var_type){

    validate_type(var_type);
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

//unifica 01
META_VAR get_variable(string var_name){

    if(variable.count(var_name) == 0){

        cout << "Variable " << var_name << " not defined." << endl;
        exit(EXIT_FAILURE);
    }

    META_VAR var_aux = variable[var_name];

    return var_aux;
}

/*
  Converte boolean(true ou false) para valor aceito no código intermediário(0 ou 1)
*/
string parse_boolean(string value){

    if(value == "true")
        return "1";

    return "0";
}

string current_label(){

    static long int label_number = 0;

    string label = "LABEL_" + to_string(label_number);

    label_number++;

    return label;
}

string get_unary_operation_type(string type, string op){

    validate_type(type);

    if(unary_op_type[op] == type)
        return type;

    cout << "Invalid operation " << op << " for variables of "<< type << " type." << endl;
    exit(EXIT_FAILURE);
}

void push_loop_block(){

    LABELS current_loop;

    string start = current_label();
    string end = current_label();

    current_loop.start_block = start;
    current_loop.return_block = end;

    loop_stack.push(current_loop);

    return;
}

string break_to(){

    string goto_label = "";

    if(loop_stack.size() > 0)
        goto_label = "\tgoto " + loop_stack.top().return_block + ";\n";

    return goto_label;
}

string continue_to(){

    string goto_label = "";

    if(loop_stack.size() > 0)
        goto_label = "\tgoto " + loop_stack.top().start_block + ";\n";

    return goto_label;
}

//Corrigir essa função
string get_operation_type(string type1, string type2, string op){

    validate_type(type1);
    validate_type(type2);

    string type;

    if(type1 == type2)
        type = op_type[op];

    if(type == ""){
        cout << "Type \'" << type1 << "\' can not \'" << op << "\' type \'" << type2 << "\'." << endl;
        exit(EXIT_FAILURE);
    }

    return type;
    // string type = "";
    //
    // for(int i = 0; i < OPERATORS; i++){
    //     if(op_table[i][0] == type1 || op_table[i][1] == type1){
    //         if(op_table[i][0] == type2 || op_table[i][1] == type2){
    //             if(op_table[i][2] == op){
    //
    //                 type = op_table[i][3];
    //                 break;
    //             }
    //         }
    //     }
    // }

    // if(type == ""){
    //
    //     cout << "Type \'" << type1 << "\' can not \'" << op << "\' type \'" << type2 << "\'." << endl;
    //     exit(EXIT_FAILURE);
    // }

    // return type;
}
