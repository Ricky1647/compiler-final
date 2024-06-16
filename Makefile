all: custom_compiler 
debug: y.tab.c lex.yy.c hashtable.c
	gcc -Wall -fsanitize=address -g -o ./custom_compiler y.tab.c lex.yy.c hashtable.c  -ly -lfl

release: y.tab.c lex.yy.c hashtable.c
	gcc -Wall -o ./custom_compiler y.tab.c lex.yy.c hashtable.c  -ly -lfl

clean:
	rm custom_compiler y.tab.c y.tab.h lex.yy.c

y.tab.c: final.y
	yacc -d final.y

lex.yy.c: final.l
	lex final.l
