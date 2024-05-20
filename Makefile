all: custom_compiler
custom_compiler: y.tab.c lex.yy.c
	gcc -Wall  -o ./custom_compiler y.tab.c lex.yy.c  -ly -lfl
y.tab.c:
	yacc -d final.y
lex.yy.c:
	lex final.l
clean:
	rm custom_compiler y.tab.c y.tab.h lex.yy.c