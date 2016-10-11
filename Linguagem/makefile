all:
		clear
		lex lex.l
		yacc -d yacc.y
		g++ -std=c++11 -o ocean y.tab.c -lfl

		./ocean < exemplo.oc