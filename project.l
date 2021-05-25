digit	[0-9]
letter	[A-Za-z]
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int linenum=1;
%}
%%
"if" return IF;
"fi" return FI;
"elif" return ELIF;
"else"return ELSE;
"then" return THEN;
"echo" return ECHO;
[0-9]+	{yylval.string=strdup(yytext);return INT;}
{letter}({letter}|{digit})* {yylval.string=strdup(yytext);return IDENT;}
"$"	{yylval.string=strdup(yytext);return DOLLAR;}
"("	return OPENP;
")"	return CLOSEP;
"{"	return OPENCURLY;
"}"	return CLOSEDCURLY;
"[" return OPENSQUARE;
"]" return CLOSESQUARE;
"-gt" return LARGER;
"-lt" return SMALLER;
"-ge" return LARGEREQ;
"-le" return SMALLEREQ;
"-eq" return IFEQUAL;
"="	return ASSIGNOPERATOR;
"+" return PLUS;
"-" return MINUS;
"*" return MULTIP;
"/" return DIV;
"#!/bin/sh" return DEF;
\#\ .*  {yylval.string=strdup(yytext); return COMMENT;}
\'.*\' {yylval.string=strdup(yytext); return STRING;}
\n	{linenum++;}
[ \t]+
("#".*)  

%%

