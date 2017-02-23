#include "tables.h"

bool validate_type(string type){

    if(types_map[type] != "")
        return true;

    cout << "Type " << type << " is not a valid type." << endl;
    exit(EXIT_FAILURE);
}

void add_arg(string type, string var){

    validate_type(type);

    current_function.args.push_back(var);
    current_function.args_types.push_back(type);

    return;
}

void push_array(string temp, string lines, string columns, string el_type){

    int l = (int)stod(lines);
    int c = (int)stod(columns);

    META_ARRAY meta;

    meta.lines = l;
    meta.columns = c;
    meta.element_type = el_type;

    array_map.insert(pair<string, META_ARRAY>(temp, meta));

    return;
}

META_ARRAY get_array(string temp, string name){

    META_ARRAY meta;

    if(array_map.count(temp) == 0){

        cout << "Variable " << name << " is not an Array." << endl;
        exit(EXIT_FAILURE);
    }

    meta = array_map[temp];

    return meta;
}

int get_linear_multi_array_index(int number_columns, int lines, int columns){

    return columns + number_columns * lines;
}

void validate_array_range(int range, string lines){

    int range_aux = (int)stod(lines);

    if(range_aux < range)
        return;

    cout << "Array out of range." << endl;
    exit(EXIT_FAILURE);
}

void validate_string_concat(string type1, string type2){

    validate_type(type1);
    validate_type(type2);

    if(type1 == "string" && type2 == "string")
        return;

    cout << "Unable to concat " << type1 << " with " << type2 << "." << endl;
    exit(EXIT_FAILURE);
}

int validate_multi_array_range(int number_lines, int number_columns, string lines, string columns){

    int lines_aux = (int)stod(lines);
    int columns_aux = (int)stod(columns);
    int linear_position = get_linear_multi_array_index(number_columns, lines_aux, columns_aux);

    if(lines_aux < number_lines && columns_aux < number_columns)
        return linear_position;

    cout << "Array out of range." << endl;
    exit(EXIT_FAILURE);
}

string current_arg(){

    static unsigned long arg_number = 0;

    string arg = "arg_" + to_string(arg_number);

    arg_number++;

    return arg;
}

string current_func(){

    static unsigned long fun_number = 0;

    string func = "func_" + to_string(fun_number);

    fun_number++;

    return func;
}

void clear_current_function(){

    current_function.name = "";
    current_function.type = "";
    current_function.args.clear();
    current_function.args_types.clear();
    current_function.ordered_args_types.clear();
}

void add_function(string type, string name){

    validate_type(type);

    cout << type << endl;
    cout << name << endl;

    current_function.name = name;
    current_function.type = type;
    current_function.tmp_name = current_func();
    current_function.ordered_args_types = current_function.args_types;
    sort(current_function.ordered_args_types.begin(), current_function.ordered_args_types.end());

    for(auto i : functions_list){

        if(i.name == current_function.name && i.ordered_args_types == current_function.ordered_args_types){

            cout << "Function " << i.name << "(";
            for(auto j =  i.args_types.rbegin(); j != i.args_types.rend(); j++)
                cout << *j << " ";
            cout << ") yet declared." << endl;
            exit(EXIT_FAILURE);
        }
    }

    functions_list.push_back(current_function);

    clear_current_function();
}

META_FUNC get_function(string name){

    for(auto i : functions_list){

        if(i.name == name && i.args_types == stack_arg_functions){
            cout << i.type << " " << i.name << endl;
            return i;
        }
    }

    cout << "Function " << name << "(";
    for(auto j =  stack_arg_functions.rbegin(); j != stack_arg_functions.rend(); j++)
        cout << *j << " ";
    cout << ") not declared." << endl;
    exit(EXIT_FAILURE);
}

void clear_args_function(){

    while(!stack_arg_functions.empty()){
        stack_arg_functions.pop_back();
    }
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

    if(scope_variables.back().count(var_name) > 0){

        cout << "Variable " << var_name << " yet declared on this scope." << endl;
        exit(EXIT_FAILURE);
    }

    META_VAR var_aux;

    var_aux.type = var_type;
    var_aux.tmp = current_temp();

    scope_variables.back().insert(pair<string, META_VAR>(var_name, var_aux));

    return var_aux.tmp;
}

META_VAR get_variable(string var_name){

    for(auto i = scope_variables.rbegin(); i != scope_variables.rend(); i++){

        auto j = *i;
        if(j.count(var_name) > 0){
            return j[var_name];
        }
    }

    if(variable.count(var_name) == 0){

        cout << "Variable " << var_name << " not declared." << endl;
        exit(EXIT_FAILURE);
    }
}

void validate_function(){

    if(isFunction)
        return;

    cout << "Command return cannot be called out of a function." << endl;
    exit(EXIT_FAILURE);
}

void validate_return_type(string type){

    if(return_types.empty() && type != "void"){

        cout << "A function with type " << type << " must return one " << type << " value." << endl;
        exit(EXIT_FAILURE);
    }

    while(!return_types.empty()){
        if(return_types.top() != type){

            cout << "Functions with type " << type << " can not return type " << return_types.top() << "." << endl;
            exit(EXIT_FAILURE);
        }

        return_types.pop();
    }

    return;
}

/*
//Será alterada devido a escopo
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

//será alterada devido a escopo
META_VAR get_variable(string var_name){

    if(variable.count(var_name) == 0){

        cout << "Variable " << var_name << " not defined." << endl;
        exit(EXIT_FAILURE);
    }

    META_VAR var_aux = variable[var_name];

    return var_aux;
}
*/
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
