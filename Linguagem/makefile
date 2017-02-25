all:
		clear
		lex lex.l
		yacc -d -v -t yacc.y
		g++ -std=c++11 -o ocean y.tab.c -lfl
		./ocean < exemplo.oc

run:
		clear
		g++ compiled.cpp -o compiled
		./compiled

recompile:
		./ocean < exemplo.oc
