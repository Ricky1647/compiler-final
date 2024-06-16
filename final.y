%{
#include <string.h>
#include "hashtable.h"

char* string_array[20];
int array_index = 0;
int cur_index = 0;
int branch = 0;
int temp = 0;
char* program_name[20];
// struct symbol array[20000000];
HashTable Mytable;



char* num_list[20];


%}

%union {
	float fval;
	int vblno;
    char* reserved;
    struct DataContainer* symbol;
    // strcut symbol* sym;
}
%left '-' '+'
%nonassoc UMINUS
%left '*' '/'


%token <reserved> NAME
%token <reserved> TO
%token <reserved> FOR
%token <reserved> ENDFOR
%token <vblno> NUMBER
%token <reserved> START
%token <reserved> END
%token <fval> FNUMBER
%token <reserved> AS
%token <reserved> PROGRAM
%token <reserved> DECLARE
%token <reserved> INTEGER
%token <reserved> FLOAT
%type <reserved> PRO_NAME
%type <reserved> vartype;
%type <reserved> assignment;
%type <reserved> arithmetic;
%type <symbol> expression;
%type <reserved> dummy;
// %type <sym> expression;

%%
PROG: PRO_HEADER START statement_list END {
    printf("%-10sHALT %s\n\n", "", program_name);
    for (int i = 1; i <= temp; i++){
        char tmpname[256];
        bzero(tmpname, 256);
        sprintf(tmpname, "T&%d", i);
        printf("%-10sDeclare %s, Float\n","", tmpname);
    }
}

PRO_HEADER: PROGRAM PRO_NAME {
                                printf("%-10sSTART %s\n", "", $2);
                                strcpy(program_name, $2);
                                create_table(&Mytable);
                            }

PRO_NAME: NAME {}

statement_list : statement {}
    | statement_list statement {}
    ;

statement: vardeclare {}
    | assignment {}
    | forloop {}
    ;



forloop: FOR dummy '(' assignment TO NUMBER ')' arithmetic  ENDFOR {
    printf("%-10sINC %s\n", "", $4);
    printf("%-10sI_CMP %s,%d\n","", $4, $6);
    printf("%-10sJL %s\n", "", $2);
}


dummy: {

    char target[256];
    bzero(target, 256);
    sprintf(target,"IB&%d",++branch);
    printf("%-10s\n",target);
    $$ = strdup(target);
}
//NAME ':''=' expression  
arithmetic : NAME ':''=' expression ';'{
        $4->data.singleFloat = $4->data.singleFloat;
        printf("%-10sF_STORE %s, %s\n", "", $4->name, $1);

    }

//     | NAME '[' NUMBER ']' ':=' expression[

//     ]

expression: expression '+' expression { 
        char newTemp[256];
        sprintf(newTemp, "T&%d", ++temp);
        insert(&Mytable, newTemp, 0);
        printf("%-10sF_ADD %s, %s, %s\n", "", newTemp,$1->name, $3->name);
        $$ = search(&Mytable, newTemp);
    }

	|	expression '-' expression { 
        char newTemp[256];
        sprintf(newTemp, "T&%d", ++temp);
        insert(&Mytable, newTemp, 0);
        printf("%-10sF_SUB %s, %s, %s\n", "", newTemp,$1->name, $3->name);
        $$ = search(&Mytable, newTemp);
    }

	|	expression '*' expression { 
        char newTemp[256];
        sprintf(newTemp, "T&%d", ++temp);
        insert(&Mytable, newTemp, 0);
        printf("%-10sF_MUL %s, %s, %s\n", "", newTemp,$1->name, $3->name);
        $$ = search(&Mytable, newTemp);
    }
    |   '-' expression %prec UMINUS	{ 
        char newTemp[256];
        sprintf(newTemp, "T&%d", ++temp);
        insert(&Mytable, newTemp, 0);
        printf("%-10sF_UMINUS %s, %s\n", "", newTemp, $2->name);
        $$ = search(&Mytable, newTemp);
    }
    |	NAME{ 
        DataContainer *tmp = search(&Mytable, $1);
        $$ = tmp; 
        // printf("%-10s%s, ", "", $1);
    }

    |   NAME '[' NAME ']' {
        DataContainer *tmpArray = search(&Mytable, $1);
        DataContainer *tmpInt = search(&Mytable, $3);
        tmpArray->indexPar = strdup($3);
        tmpArray->index = tmpInt->data.singleInt;
        $$ = tmpArray;
        // printf("%-10s%s[%s], ", "", $1, $3);
    }
	;



assignment: 
    NAME ':''=' NUMBER {
        DataContainer* tmp = search(&Mytable, strdup($1));
        tmp->data.singleInt = $4;
        // printf("%-10sI_STORE %d,%s\n","Ib&1", tmp->data.singleInt, $1);
        printf("%-10sI_STORE %d,%s\n","", tmp->data.singleInt, $1);
        $$ = $1;
    }   
    | NAME ':''=' FNUMBER{
        DataContainer* tmp = search(&Mytable, strdup($1));
        tmp->data.singleFloat = $4;
        printf("%-10sF_STORE %f,%s\n", "", tmp->data.singleFloat, $1);
        $$ = $1;
    }   
    | NAME '[' NUMBER ']' ':''=' NUMBER{
        DataContainer* tmp = search(&Mytable, strdup($1));
        tmp->data.intArray[$3] = $7;
        printf("I_STORE %d,%s[%d]\n", "", tmp->data.intArray[$3], $1, $3);
        $$ = $1;
    }
    | NAME '[' NUMBER ']' ':''=' FNUMBER{
        DataContainer* tmp = search(&Mytable, strdup($1));
        tmp->data.floatArray[$3] = $7;
        printf("%-10sF_STORE %f,%s[%d]\n", "", tmp->data.floatArray[$3], $1, $3);
        $$ = $1;
    }
    ;

vardeclare: DECLARE varlist AS vartype ';'{
    for(; cur_index < array_index; cur_index++){
        DataContainer* tmp = search(&Mytable, string_array[cur_index]);
        if(strcmp("FLOAT", $4) == 0) {
            if(tmp->dataType == 1){
                tmp->data.floatArray = (float *) malloc(sizeof(float) * tmp->size);
                printf("%-10sDECLARE %s, Float_array, %d\n", "", string_array[cur_index], tmp->size);
            }
            else{
                tmp->data.singleFloat = (float) 0.0;
                printf("%-10sDECLARE %s AS %s\n", "", string_array[cur_index], $4);
            }
        }
        else{
            if(tmp->dataType == 1){
                tmp->data.intArray = (int *) malloc(sizeof(int) * tmp->size);
                printf("%-10sDECLARE %s, int_array,%d\n", "", string_array[cur_index], tmp->size);
            }
            else{
                tmp->data.singleInt = (int) 0;
                printf("%-10sDECLARE %s AS %s\n", "", string_array[cur_index], $4);
            }
        }
    }
    // for(; cur_index < array_index; cur_index++){
    //     printf("DECLARE %s AS %s\n", string_array[cur_index], $4);
    // }
    // if(strcmp("FLOAT", $4) == 0){
    //     for(; cur_index_list < array_index_list; ){
    //         printf("DECLARE %s, Float_array,%d\n", string_array_list[cur_index_list], num_list[cur_index_list]);
    //         cur_index_list++;
    //     }
    // }
    // else{
    //     for(; cur_index_list < array_index_list; ){
    //         printf("DECLARE %s, int_array,%d\n", string_array_list[cur_index_list], num_list[cur_index_list]);
    //         cur_index_list++;
    //     }
    // }
};

varlist: NAME {
        insert(&Mytable, strdup($1), 0);
        string_array[array_index] = strdup($1);
        array_index++;
    }
    | varlist ',' NAME {        
        insert(&Mytable, strdup($3), 0);
        string_array[array_index] = strdup($3);
        array_index++;
    }
    | NAME '[' NUMBER ']'{
        insert(&Mytable, strdup($1), $3);
        string_array[array_index] = strdup($1);
        array_index++;
    }
    | varlist ',' NAME '[' NUMBER ']'{
        insert(&Mytable, strdup($3), $5);
        string_array[array_index] = strdup($3);
        array_index++;
        // string_array_list[array_index_list] = strdup($3);
        // num_list[array_index_list] = $5;
        // array_index_list++;
    }
    ;
vartype: INTEGER { $$ = strdup("INTEGER");}
    |   FLOAT { $$ = strdup("FLOAT");}
    ;
%%
