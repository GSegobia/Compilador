/*Cry me a Ocean*/

#include <iostream>
#include <cstdlib>
#include <cstring>
#include <cstdio>

using namespace std;

#define BUFFER_SIZE 1000

double func_0(double tmp_1, double tmp_0){
	double tmp_2;
	double tmp_3;
	double tmp_4;
	int tmp_5;

	tmp_2 = 5;
	tmp_3 = tmp_2;
	tmp_4 = 10;
	tmp_5 = tmp_0 > tmp_4;
	if(tmp_5) goto LABEL_1;
	LABEL_0:
	cout << tmp_3 << endl;
	return tmp_3;

	LABEL_1:
	double tmp_6;
	tmp_6 = 10;
	tmp_3 = tmp_6;
	goto LABEL_0;

}
void func_1(int tmp_8, int tmp_7){
	double tmp_9;
	double tmp_10;

	tmp_9 = 7;
	tmp_10 = tmp_9;
	cout << tmp_10 << endl;

	return;

}

int main(){
	char* buffer;
	double tmp_11;
	double tmp_12;
	double tmp_13;	double tmp_14;
	int length_tmp_15;
	char* tmp_15;
	double tmp_16;
	double tmp_17;
	double tmp_18;
	double tmp_19;
	int length_tmp_20;
	char* tmp_20;
	double tmp_21;
	int tmp_22;
	double tmp_23;
	int tmp_24;
	double tmp_26;
	int tmp_27;
	double tmp_31;
	int tmp_32;
	double tmp_34;//ATTRIBUTION SWITCH
	bool tmp_41;
	double tmp_35;
	bool tmp_40;
	double tmp_37;
	int length_tmp_42;
	char* tmp_42;
	int length_tmp_43;
	char* tmp_43;
	int length_tmp_44;
	char* tmp_44;
	int length_tmp_45;
	char* tmp_45;
	int length_tmp_46;
	char* tmp_46;
	int length_tmp_47;
	char* tmp_47;
	int line_tmp_48;
	int column_tmp_48;
	double* tmp_48;
	int line_tmp_49;
	int column_tmp_49;
	double* tmp_49;

 //---- FIM DAS ATRIBUIÇÕES ----

	tmp_11 = 5;
	tmp_12 = 7;
	tmp_13 = func_0(tmp_11, tmp_12);
	tmp_14 = tmp_13;
	length_tmp_15 = 13;
	tmp_15 = (char*)"Valor de f = ";
	cout << tmp_15;
	cout << tmp_14 << endl;
	tmp_16 = 0;
	tmp_17 = tmp_16;
	tmp_18 = 10;
	tmp_19 = tmp_18;
	length_tmp_20 = 26;
	tmp_20 = (char*)"Listagem de valores de A: ";
	cout << tmp_20 << endl;
	LABEL_2:
	tmp_21 = 10;
	tmp_22 = tmp_17 < tmp_21;
	if(tmp_22) goto LABEL_4;
	LABEL_3:
	tmp_23 = 7;
	tmp_24 = tmp_17 == tmp_23;
	if(tmp_24) goto LABEL_8;
	tmp_26 = 10;
	tmp_27 = tmp_17 == tmp_26;
	if(tmp_27) goto LABEL_7;
	goto LABEL_6;
	LABEL_5:
	goto LABEL_11;
	LABEL_9:
	tmp_31 = 0;
	tmp_32 = tmp_17 > tmp_31;
	if(tmp_32) goto LABEL_11;
	LABEL_10:
	tmp_34 = tmp_17;//DECLARATION SWITCH
	tmp_35 = 10;
	tmp_41 = tmp_34 == tmp_35;
	if(tmp_41) goto LABEL_15;
	tmp_37 = 20;
	tmp_40 = tmp_34 == tmp_37;
	if(tmp_40) goto LABEL_14;
	goto LABEL_13;
	LABEL_12:
	length_tmp_44 = 24;
	tmp_44 = (char*)"Insira o primeiro nome: ";
	cout << tmp_44;
	buffer = (char*)malloc(BUFFER_SIZE * sizeof(char));
	fgets(buffer, BUFFER_SIZE, stdin);
	length_tmp_42 = strlen(buffer);
	buffer[strlen(buffer) - 1] = 0;
	tmp_42 = (char *)malloc((length_tmp_42 + 1) * sizeof(char));
	strcpy(tmp_42, buffer);
	free(buffer);
	length_tmp_45 = 25;
	tmp_45 = (char*)"Insira o último o nome: ";
	cout << tmp_45;
	buffer = (char*)malloc(BUFFER_SIZE * sizeof(char));
	fgets(buffer, BUFFER_SIZE, stdin);
	length_tmp_43 = strlen(buffer);
	buffer[strlen(buffer) - 1] = 0;
	tmp_43 = (char *)malloc((length_tmp_43 + 1) * sizeof(char));
	strcpy(tmp_43, buffer);
	free(buffer);
	length_tmp_46 = length_tmp_42 + length_tmp_43;
	tmp_46 = (char*)malloc((length_tmp_46 + 1)*sizeof(char));
	strcat(tmp_46, tmp_42);
	strcat(tmp_46, tmp_43);
	length_tmp_47 = length_tmp_46;
	tmp_47 = tmp_46;
	cout << tmp_47 << endl;
	line_tmp_48 = (int)5;
	column_tmp_48 = (int)5;
	tmp_48 = (double*)calloc(line_tmp_48 * column_tmp_48, sizeof(double));
	line_tmp_49 = (int)10;
	column_tmp_49 = 1;
	tmp_49 = (double*)calloc(line_tmp_49, sizeof(double));

 	return 0;

	LABEL_4:
	cout << tmp_17 << endl;
	tmp_17 = tmp_17 + 1;
	goto LABEL_2;

	LABEL_8:
	int length_tmp_25;
	char* tmp_25;
	length_tmp_25 = 7;
	tmp_25 = (char*)"A é 7!";
	cout << tmp_25 << endl;
	goto LABEL_5;

	LABEL_7:
	int length_tmp_28;
	char* tmp_28;
	length_tmp_28 = 8;
	tmp_28 = (char*)"A é 10!";
	cout << tmp_28 << endl;
	goto LABEL_5;

	LABEL_6:
	int length_tmp_29;
	char* tmp_29;
	int length_tmp_30;
	char* tmp_30;
	length_tmp_29 = 5;
	tmp_29 = (char*)"A é ";
	cout << tmp_29;
	cout << tmp_17;
	length_tmp_30 = 1;
	tmp_30 = (char*)".";
	cout << tmp_30 << endl;
	goto LABEL_5;



	LABEL_11:
	cout << tmp_17 << endl;
	tmp_17 = tmp_17 - 1;
	goto LABEL_9;

	LABEL_15:
	int length_tmp_36;
	char* tmp_36;
	length_tmp_36 = 12;
	tmp_36 = (char*)"AAAAAAAAAAAa";
	cout << tmp_36 << endl;
	goto LABEL_12;

	LABEL_14:
	int length_tmp_38;
	char* tmp_38;
	length_tmp_38 = 12;
	tmp_38 = (char*)"BBBBBBBBBBBB";
	cout << tmp_38 << endl;
	goto LABEL_12;

	LABEL_13:
	int length_tmp_39;
	char* tmp_39;
	length_tmp_39 = 10;
	tmp_39 = (char*)"CCCCCCCCCC";
	cout << tmp_39 << endl;
	goto LABEL_12;

}
