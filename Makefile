all: custom_compiler y.tab.c lex.yy.c hashtable.c
custom_compiler: y.tab.c lex.yy.c hashtable.c
	gcc -Wall  -o ./custom_compiler y.tab.c lex.yy.c hashtable.c  -ly -lfl
y.tab.c: final.y
	yacc -d final.y
lex.yy.c: final.l
	lex final.l
clean:
	rm custom_compiler y.tab.c y.tab.h lex.yy.c