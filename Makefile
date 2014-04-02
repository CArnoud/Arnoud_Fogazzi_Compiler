etapa2: 		rules.o lex.yy.o hash.o main.o
				gcc hash.o lex.yy.o main.o -o etapa2
				
main.o: 		main.c
				gcc -c main.c
				
hash.o:			hash.c
				gcc -c hash.c
				
lex.yy.o:		lex.yy.c
				gcc -c lex.yy.c
				
lex.yy.c: 		scanner.l
				flex scanner.l
				
rules.o:		rules.tab.c
				gcc -c rules.tab.c

rules.tab.c:	rules.y
				bison -d rules.y

clean:
				rm *.o etapa2.exe lex.yy.c rules.tab.c rules.tab.h