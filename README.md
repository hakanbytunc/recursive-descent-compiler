# recursive-descent-compiler

Converts a given grammar into a recursive-descent parser code.

MAKE FILE:
all: yacc lex
	cc lex.yy.c y.tab.c -o project

yacc: project.y
	yacc -d project.y

lex: project.l
	lex project.l
FOR COMPILE:
Cd /project-location
2. make
3. ./project input.txt output.txt
(ex: example1.sh output.sh)
(you can get input&output on txt document, i wrote .sh document) 

Analysis 1:

The line “%rules E 3 T 1;” in the input means that non-terminal E has three distinct rules and non-terminal T has only one rule. Thus, this information must be consistent with the given grammar. In this first analysis, you have to check if there is an inconsistency between this rule definition line and the given grammar. As it is seen in the example below, the rule definition line claims that there are three rules of the non-terminal “E”, but in the grammar there are only two rules. In this case, you should print an appropriate error message.

Analysis 2:

The line “%rules E 2 T 3;” in the input also means there are grammar rules with E and T non-terminals.It gives an error message if there is no grammar rule with E and/or T. On the contrary, if a there is a grammar rule for non-terminal X but it is not defined in the rule definition line, again, gives an error message

Analysis 3:

Give an error message if a non-terminal is referenced but it is not defined as a rule.

Analysis 4:

You have to give an error message if there is a useless rule. Non-terminals F and G are never referenced in the right-hand side of any grammar rule, and, thus, they are useless.
