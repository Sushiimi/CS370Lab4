all: yacc lex compile

yacc:
	bison -d -y lab4docalc.y

lex:
	flex lab4docalc.l

compile:
	gcc y.tab.c -o lab4docalc

run:
	./lab4docalc.exe

clean:
	rm y.tab.c
	rm lex.yy.c
	rm *.h
	rm lab4docalc
