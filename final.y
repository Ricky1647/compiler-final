%{
#include <string.h>
#include "hashtable.h"
#include "hashtable.h"
char* string_array[20];
char* program_name[20];
// struct symbol array[20000000];
HashTable Mytable;

int array_index = 0;
int cur_index = 0;

char* string_array_list[20];
int array_index_list = 0;
int cur_index_list = 0;
char* num_list[20];

%}

%union {
	double dval;
	int vblno;
    char* reserved;
    // strcut symbol* sym;
}

%token <reserved> NAME
%token <vblno> NUMBER
%token <reserved> START
%token <reserved> END
%token <reserved> AS
%token <reserved> PROGRAM
%token <reserved> DECLARE
%token <reserved> INTEGER
%token <reserved> FLOAT
%type <reserved> PRO_NAME
%type <reserved> vartype;
// %type <sym> expression;

%%
PROG: PRO_HEADER START statement_list END {printf("HALT %s\n", program_name);}

PRO_HEADER: PROGRAM PRO_NAME {
                                printf("START %s\n", $2);
                                strcpy(program_name, $2);
                                create_table(&Mytable);
                            }

PRO_NAME: NAME {}

statement_list : statement {}
    | statement_list statement {}
    ;

statement: vardeclare {}
    ;

vardeclare: DECLARE varlist AS vartype {
    for(; cur_index < array_index; cur_index++){
        printf("DECLARE %s AS %s\n", string_array[cur_index], $4);
    }
    if(strcmp("FLOAT", $4) == 0){
        for(; cur_index_list < array_index_list; ){
            printf("DECLARE %s, Float_array,%d\n", string_array_list[cur_index_list], num_list[cur_index_list]);
            cur_index_list++;
        }
    }
    else{
        for(; cur_index_list < array_index_list; ){
            printf("DECLARE %s, int_array,%d\n", string_array_list[cur_index_list], num_list[cur_index_list]);
            cur_index_list++;
        }
    }
};

varlist: NAME {
        string_array[array_index] = strdup($1);
        array_index++;
    }
    | varlist ',' NAME {        
        string_array[array_index] = strdup($3);
        array_index++;}
    | NAME '[' NUMBER ']'{
        string_array_list[array_index_list] = strdup($1);
        num_list[array_index_list++] = $3;
        
        
    }
    | varlist ',' NAME '[' NUMBER ']'{
        string_array_list[array_index_list] = strdup($3);
        num_list[array_index_list] = $5;
        array_index_list++;
    }
    ;
vartype: INTEGER { $$ = strdup("INTEGER");}
    |   FLOAT { $$ = strdup("FLOAT");}
    ;
%%
