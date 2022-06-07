%{
#include <stdio.h>
#include <iostream>
#include <string>
#include <map>
#include "cppe.tab.h"


extern "C" int yylex();
int yyerror(char *s);

%}

digito		[0-9]
bool        [true-false]
letra       [a-zA-z]
car         [{digito}|{letra}]
num         {digito}+
real        {digito}+"."{digito}+   
id          _?[a-zA-Z0-9_]+

%%

"entero"    { yylval.tipo_val = new std::string(yytext); return ENTERO; }
"booleano"  { yylval.tipo_val = new std::string(yytext); return BOOLEANO; }
"flotante"  { yylval.tipo_val = new std::string(yytext); return FLOTANTE; }
"caracter"  { yylval.tipo_val = new std::string(yytext); return CARACTER; }
"vacio"     { yylval.tipo_val = new std::string(yytext); return VACIO; }

"si"        { return SI; }
"sino"      { return SINO; }
"mientras"  { return MIENTRAS; }
"retorno"   { return RETORNO; }
"principal" { return PRINCIPAL; }

"+"		    { yylval.op_val = new std::string(yytext); return SUMA; }
"-"	    	{ yylval.op_val = new std::string(yytext); return RESTA; }
"*" 		{ yylval.op_val = new std::string(yytext); return MULT; }
"/"		    { yylval.op_val = new std::string(yytext); return DIV; }
"%"         { yylval.op_val = new std::string(yytext); return RESTO; }

"("		{ return PAR_A; }
")"		{ return PAR_C; }
"{"		{ return LLAVE_A; }
"}"		{ return LLAVE_C; }
"["		{ return COR_A; }
"]"		{ return COR_C; }

"<="    { yylval.relop_val = new std::string(yytext); return LE; }
">="    { yylval.relop_val = new std::string(yytext); return GE; }
"=="    { yylval.relop_val = new std::string(yytext); return IGL; }
"!="    { yylval.relop_val = new std::string(yytext); return DIF; }
"<"     { yylval.relop_val = new std::string(yytext); return MENOR; }
">"     { yylval.relop_val = new std::string(yytext); return MAYOR; }

"="    { return ASIGNAR; }

";"    { return END; }
","    { return COMA; }

{num}	{ yylval.int_val = atoi(yytext); return NUM; }
{bool}	{ yylval.bool_val = atoi(yytext); return BOOL; }
{real}  { yylval.float_val = atoi(yytext); return FLOT; }
{car}  { yylval.char_val = atoi(yytext); return CAR; }
{id}	{ yylval.id_val = new std::string(yytext); return ID; }

[ \t]*		{}
[\n]		{ yylineno++;	}

.		{ std::cerr << "SCANNER "; yyerror(const_cast<char*>("")); exit(1);	}
