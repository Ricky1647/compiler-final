%{
#include<string.h>
char* string_array[20];
int array_index = 0;
%}

%union {
	double dval;
	int vblno;
    char* reserved;
}

%token <reserved> NAME
%token <reserved> START
%token <reserved> END
%token <reserved> AS
%token <reserved> DECLARE
%token <reserved> INTEGER
%token <reserved> FLOAT

%type <reserved> vartype;

%%
PROGRAM: statement_list 

statement_list : statement {}
    | statement_list statement {}
    ;

statement: vardeclare {}
    ;

vardeclare: DECLARE varlist AS vartype {
    for(int i = 0; i < array_index; i++){
        printf("DECLARE %s AS %s\n", string_array[i], $4);
    }
};

varlist: NAME {
        string_array[array_index] = strdup($1);
        array_index++;
    }
    | varlist ',' NAME {        
        string_array[array_index] = strdup($3);
        array_index++;}
    ;
vartype: INTEGER { $$ = strdup("INTEGER");}
    |   FLOAT { $$ = strdup("FLOAT");}
    ;
%%
