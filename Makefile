etapa3: 			parser.tab.o lex.yy.o hash.o syntaxTree.o
					gcc parser.tab.o lex.yy.o hash.o syntaxTree.o -o etapa3
					
syntaxTree.o:	syntaxTree.c
					gcc -c syntaxTree.c
					
hash.o:			hash.c
					gcc -c hash.c
				
lex.yy.o:		lex.yy.c
					gcc -c lex.yy.c
				
lex.yy.c: 		scanner.l
					flex scanner.l
				
parser.tab.o:	parser.tab.c
					gcc -c parser.tab.c

parser.tab.c:	parser.y
					bison -d -v parser.y

clean:
					rm *.o etapa3.exe lex.yy.c parser.tab.c parser.tab.h parser.output
