%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    void yyerror(char *);
    int yylex(void);
    extern FILE *yyin;
    extern int linenum;
    char writeBuffer[400];
    void openFile(char*);
    void writeLinetoFile(char*);
    FILE *outputFile;
    void closeFile();
%}

%union
{
	char *string;
}
//defining tokens
%token <string> IDENT
%token <string> INT
%token <string> DOLLAR
%token <string> ASSIGNOPERATOR 
%token <string> IF
%token <string> FI
%token <string> THEN
%left MULTIP DIV
%left PLUS MINUS
%token <string> ELIF
%token <string> ELSE
%token <string> OPENCURLY
%token <string> CLOSEDCURLY
%token <string> OPENSQUARE
%token <string> CLOSESQUARE
%token <string> CLOSEP
%token <string> OPENP
%token <string> COMMENT
%token LARGER SMALLER LARGEREQ SMALLEREQ IFEQUAL DEF STRING ECHO 
//defining types
%type <string> intorident
%type <string> program
%type <string> sentence
//%type <string> paranthesis
%type <string> operation
%type <string> lines
%type <string> echofunction
%type <string> value
%type <string> thenstament
%type <string> equal
%type <string> elifstatement
%type <string> echofunc
%type <string> elsestatement
%type <string> commentfunction

%%
//first it gets in this statement
program:
		sentence
		|
		sentence program
;
//second it gets in this statement
sentence:
		echofunction
		{
			writeLinetoFile(writeBuffer);//it prints whats in echofunction
		}
		|
		ifstatement
		{
			writeLinetoFile(writeBuffer);
		}
		|
		lines
		{
			writeLinetoFile(writeBuffer);
		}
		|
		thenstament
		{
			writeLinetoFile(writeBuffer);
		}
		|
		equal
		{
			writeLinetoFile(writeBuffer);
		}
		|
		fistatement
		{
			writeLinetoFile(writeBuffer);
		}
		|
		elifstatement
		{
			writeLinetoFile(writeBuffer);
		}
		|
		elsestatement
		{
			writeLinetoFile(writeBuffer);
		}
		|
		commnentfunction
		{
			writeLinetoFile(writeBuffer);
		}



;
equal:
		//int or ident with dollar or not , it equals int or ident with dollar or not
		intorident intorident
		{
			sprintf(writeBuffer,"%s%s\n",$1,$2);
		}
		|
		intorident intorident
		{
			sprintf(writeBuffer,"%s%s\n",$1,$2);
		}	
;

commnentfunction://prints comment lines(prints on sentence statement in here it scans)
				COMMENT
				{
				sprintf(writeBuffer,"%s\n",$1);
				}
intorident:
			//int or ident with dollar or not 
			DOLLAR IDENT
			{
				sprintf($$,"$%s",$2);
			}
			|
			DOLLAR INT
			{
				sprintf($$,"$%s",$2);
			}
			|
			INT
			{
				sprintf($$,"%s",$1);
			}
			|
			IDENT
			{
				sprintf($$,"%s",$1);
			}
			|
			//prints ident equals (scans in here prints in sentence statement)
			IDENT ASSIGNOPERATOR
			{
				sprintf($$,"%s=",$1);
			}
			|
			//prints equals ident (scans in here prints in sentence statement)
			ASSIGNOPERATOR IDENT
			{
				sprintf($$,"=%s",$2);
			}
;

lines:	
			//iss111=$((3+4)) input
			//$iss111=3+4 output
			intorident DOLLAR OPENP OPENP value CLOSEP CLOSEP
			{
				sprintf(writeBuffer,"$%s%s\n",$1,$5);
			}
			|
			//a=$(($iss111+($i55abc2zsd/5))) input
				intorident DOLLAR OPENP OPENP intorident operation OPENP value CLOSEP CLOSEP CLOSEP
				{
					sprintf(writeBuffer,"$%s%s%s%s\n",$1,$5,$6,$8);
				}
			//a=$(((z+10)*a1)) input
			|
			intorident DOLLAR OPENP OPENP OPENP value CLOSEP operation intorident CLOSEP CLOSEP
				{
					sprintf(writeBuffer,"%s($%s)%s%s \n",$1,$6,$8,$9);
				}
			|
			//x3=$((($x1*$x2)-($x1+$x2))) input
			intorident DOLLAR OPENP OPENP OPENP value CLOSEP operation OPENP value CLOSEP CLOSEP CLOSEP
				{
					sprintf(writeBuffer,"%s(%s)%s(%s) \n",$1,$6,$8,$10);
				}
			|
			//ss34ss=$((($rr1abc1*$rr2xy)*($ss3aaaa-100/($rr2xy-$rr1abc1)))) input
			intorident DOLLAR OPENP OPENP OPENP value CLOSEP operation OPENP value operation OPENP value CLOSEP CLOSEP CLOSEP CLOSEP
				{
					sprintf(writeBuffer,"%s(%s)%s(%s%s(%s)) \n", $1,$6,$8,$10,$11,$13);
				}

			
;

ifstatement:
		//if [ $a1 -le 200 ] input
		IF OPENSQUARE intorident operation intorident CLOSESQUARE
		{
			sprintf(writeBuffer,"if(%s %s %s)\n",$3,$4,$5);
		}
;
elifstatement:
		//elif [ $yttt122xx -ge 22 ] input
		ELIF OPENSQUARE intorident operation intorident CLOSESQUARE
		{
			sprintf(writeBuffer,"}elsif(%s %s %s)",$3,$4,$5);;
		}
;
elsestatement:
			ELSE
			{
				sprintf(writeBuffer,"}else{ \n");
			}
;


fistatement:
			FI
			{
				sprintf(writeBuffer,"} \n");

			}
;

thenstament:
			THEN
			{
				sprintf(writeBuffer,"{ \n");
			}
;
value: //int or ident with dollar or not plus operation int or ident with dollar or not
		intorident PLUS intorident
		{
			sprintf(writeBuffer,"%s+%s",$1,$3);
		}
		//int or ident with dollar or not minus operation int or ident with dollar or not
		|
		intorident MINUS intorident
		{
			sprintf(writeBuffer,"%s-%s",$1,$3);
		}
		//int or ident with dollar or not multiplication operation int or ident with dollar or not
		|
		intorident MULTIP intorident
		{
			sprintf(writeBuffer,"%s*%s",$1,$3);
		}
		//int or ident with dollar or not division operation int or ident with dollar or not
		|
		intorident DIV intorident
		{
			sprintf(writeBuffer,"%s/%s",$1,$3);
		}
;


operation:	//operations and comparisons that i use 
			PLUS
			{
				sprintf($$,"+");
			}
			|
			MINUS
			{
				sprintf($$,"-");
			}
			|
			MULTIP
			{
				sprintf($$,"*");
			}
			|
			DIV
			{
				sprintf($$,"/");
			}
			|
			LARGER
			{
				sprintf($$,">");
			}
			|
			SMALLER
			{
				sprintf($$,"<");
			}
			|
			LARGEREQ
			{
				sprintf($$,">=");
			}
			|
			SMALLEREQ
			{
				sprintf($$,"<=");
			}
			|
			IFEQUAL
			{
				sprintf($$,"==");
			}			
;

			

echofunc:
		//statement that i call in echofunction only
		//$(($x32zz11+$yttt122xx)) tırnaklı ve parantezli lazım
		DOLLAR OPENP OPENP value CLOSEP CLOSEP
		{
			sprintf(writeBuffer,"%s\n",$4);
		}


;			

echofunction:
			//prints print(prints in sentence statement)
			ECHO intorident
			{
				sprintf(writeBuffer, "print %s\n" ,$2);
			}
			|
			ECHO echofunc
			{
				sprintf(writeBuffer, "print %s\n" ,$2);
			}
;



/*
paranthesis statement that i couln't use
paranthesis:
			OPENP
			|
			CLOSEP
			|
			OPENCURLY 
			|
			CLOSEDCURLY
			|
			OPENSQUARE
			|
			CLOSESQUARE
;

*/
%%
void openFile(char* fileName){
	outputFile=fopen(fileName,"w");
}
void yyerror(char *s) {
    fprintf(stderr, "%s\n ++++ %d\n", s,linenum);
}
int yywrap(){
	return 1;
}
void writeLinetoFile(char* str){
    fprintf(outputFile,"%s",str);
}
void closeFile()
{
	fclose(outputFile);	
}
int main(int argc, char *argv[])
{
    /* Call the lexer, then quit. */
    
    openFile("output.c");
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
    closeFile();
    return 0;

}
