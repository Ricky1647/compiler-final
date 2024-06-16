%{
#include "y.tab.h"
#include <string.h>
#include "hashtable.h"
extern HashTable Mytable;

%}
spa [ \t\n]*
digit [0-9]*
var [a-zA-Z][a-zA-Z0-9]*


%%
{spa}	;

[bB][eE][gG][iI][nN] {return START;}
[eE][nN][dD] {return END;}
[Pp][Rr][Oo][Gg][Rr][Aa][Mm] {return PROGRAM;} 
[dD][eE][cC][lL][aA][rR][eE] {
    // printf("get delcare\n");
    return DECLARE;
}
[aA][sS] {
    // printf("get AS\n");
    return AS;
}
[fF][oO][rR] {
    return FOR;
}
[eE][nN][dD][fF][oO][rR] {
    return ENDFOR;
}
[tT][oO] {
    return TO;
}
[iI][nN][tT][eE][gG][eE][rR] {return INTEGER;}
[fF][lL][oO][aA][tT] {return FLOAT;}

(([0-9]*)\.[0-9]*) {
		yylval.fval = atof(yytext);
        //printf("%f\n", yylval.fval);
		return FNUMBER;
	}

{digit} {
    yylval.vblno = atoi(yytext);
    return NUMBER;
}

{var} {
    yylval.reserved = strdup(yytext);
    // printf("get variable %s\n", yylval.reserved);
    return NAME;
}  


. {
    return yytext[0];
}
%%