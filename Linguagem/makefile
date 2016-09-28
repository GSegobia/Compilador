all:
	flex lex.l

	bison -d yacc.y

	gcc -o calc yacc.tab.c lex.yy.c -lfl

	./calc