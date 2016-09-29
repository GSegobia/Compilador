all:
		clear
		lex lex.l
		yacc -d yacc.y
		g++ -std=c++11 -o juninho y.tab.c -lfl

		./juninho < exemplo.juninho