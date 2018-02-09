all: yacc lex compile

yacc:
	bison -d -y lab4docalc.y

lex:
	flex lab2docalc.l

compile:
	gcc y.tab.c -o lab4docalc

run:
	./lab4docalc.exe

clean:
	rm *.c
	rm *.h
	rm *.exe
