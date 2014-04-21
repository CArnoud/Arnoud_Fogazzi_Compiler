etapa2: 			rules.tab.o lex.yy.o hash.o 
					gcc hash.o lex.yy.o rules.tab.o -o etapa2
					
hash.o:			hash.c
					gcc -c hash.c
				
lex.yy.o:		lex.yy.c
					gcc -c lex.yy.c
				
lex.yy.c: 		scanner.l
					flex scanner.l
				
rules.tab.o:	rules.tab.c
					gcc -c rules.tab.c

rules.tab.c:	rules.y
					bison -d rules.y

clean:
					rm *.o etapa2.exe lex.yy.c rules.tab.c rules.tab.h
