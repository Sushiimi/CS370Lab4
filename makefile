all: yacc lex compile

yacc:
	bison -d -y lab2docalc.y

lex:
	flex lab2docalc.l

compile:
	gcc y.tab.c -o lab2docalc

run:
	./lab2docalc.exe

clean:
	rm *.c
	rm *.h
	rm *.exe
