%{
#include <stdio.h>
#include <iostream>
#include <string>
#include <map>


extern "C" int yylex();
int yyerror(char *s);
%}

%union{
  int	  int_val;
  float float_val;
  bool bool_val;
  char char_val;
  std::string* id_val;
  std::string* op_val;
  std::string* relop_val;
  std::string* tipo_val;
}


%start	programa

%token <tipo_val>	ENTERO
%token <tipo_val>	BOOLEANO
%token <tipo_val>	FLOTANTE
%token <tipo_val>	CARACTER
%token <tipo_val>	VACIO
%token	SINO
%token	SI
%token	MIENTRAS
%token	RETORNO
%token <id_val>	PRINCIPAL

%token <int_val> NUM
%token <bool_val> BOOL
%token <float_val> FLOT
%token <char_val> CAR
%token <id_val>	ID

%token	SUMA
%token	RESTA
%token	MULT
%token	DIV
%token	RESTO

%token      PAR_A
%token	PAR_C
%token	LLAVE_A
%token	LLAVE_C
%token	COR_A
%token	COR_C

%token	LE
%token	GE
%token	IGL
%token	DIF
%token	MENOR
%token	MAYOR

%token	ASIGNAR

%token	END
%token	COMA

%%

programa: declaraciones;
 
declaraciones:  declaraciones declaracion
              | declaracion;
 
declaracion:  declaracion_variable declaracion
            | declaracion_funcion declaracion
            | principal;
 
declaracion_variable: ENTERO ID END
                   |  ENTERO ID COR_A NUM COR_C END
                   |  BOOLEANO ID END
                   |  BOOLEANO ID COR_A NUM COR_C END
                   |  FLOTANTE ID END
                   |  FLOTANTE ID COR_A NUM COR_C END
                   |  CARACTER ID END
                   |  CARACTER ID COR_A NUM COR_C END;

declaracion_funcion:  ENTERO ID PAR_A parametros PAR_C sent_compuesta
                   |  BOOLEANO ID PAR_A parametros PAR_C sent_compuesta
                   |  FLOTANTE ID PAR_A parametros PAR_C sent_compuesta
                   |  CARACTER ID PAR_A parametros PAR_C sent_compuesta
                   |  VACIO ID PAR_A parametros PAR_C sent_compuesta;
 
principal:  ENTERO PRINCIPAL PAR_A parametros PAR_C sent_compuesta;
 
parametros: lista_parametros
          | VACIO; 
 
lista_parametros: lista_parametros COMA parametro 
                | parametro;
 
parametro:  ENTERO ID 
          | ENTERO ID COR_A COR_C 
          | BOOLEANO ID 
          | BOOLEANO ID COR_A COR_C 
          | FLOTANTE ID 
          | FLOTANTE ID COR_A COR_C 
          | CARACTER ID 
          | CARACTER ID COR_A COR_C 
          | VACIO ID;
 
sent_compuesta: LLAVE_A declaracion_local lista_sentencias LLAVE_C; 
 
declaracion_local:  declaracion_local declaracion_variable_func 
                  | /* empty */;
 
declaracion_variable_func:  ENTERO ID END 
                          | ENTERO ID COR_A NUM COR_C END
                          | BOOLEANO ID END 
                          | BOOLEANO ID COR_A NUM COR_C END
                          | FLOTANTE ID END 
                          | FLOTANTE ID COR_A NUM COR_C END
                          | CARACTER ID END 
                          | CARACTER ID COR_A NUM COR_C END;
   
lista_sentencias: lista_sentencias sentencia 
                | /* empty */ ;
  
sentencia:  sentencia_expresion 
          | sentencia_seleccion 
          | sentencia_iteracion 
          | sentencia_retorno;
 
sentencia_expresion:  expresion END 
                    | END ;
 
sentencia_seleccion:  SI PAR_A expresion PAR_C sentencia SINO sentencia VACIO
                    | SI PAR_A expresion PAR_C sentencia;
 
sentencia_iteracion:  MIENTRAS PAR_A expresion PAR_C LLAVE_A lista_sentencias LLAVE_C ;
 
sentencia_retorno:  RETORNO END 
                  | RETORNO expresion END ;
 
expresion:  var ASIGNAR expresion 
          | expresion_simple ;
 
var:  ID COR_A expresion COR_C 
    | ID ;
 
expresion_simple: expresion_aditiva relop expresion_aditiva 
                | expresion_aditiva ;
 
relop:  MENOR 
      | LE 
      | MAYOR 
      | GE 
      | IGL 
      | DIF ;
 
expresion_aditiva:  expresion_aditiva sumaop term  
                  | term ;
 
sumaop:  SUMA 
       | RESTA ;
 
term: term multop factor 
    | factor ;
 
multop:  MULT 
       | DIV ;
 
factor: PAR_A expresion PAR_C 
      | var 
      | call 
      | NUM ;
 
call: ID PAR_A args PAR_C ;
   
args: lista_arg 
    | /* empty */ ;
 
lista_arg:  lista_arg COMA expresion 
          | expresion ;

%%

int yyerror(std::string s)
{
  extern int yylineno;    // defined and maintained in lex.c
  // extern char *yytext;    // defined and maintained in lex.c
  
  std::cerr << "ERROR: " << s  << " en la linea " << yylineno << std::endl;
  std::exit(1);
}

int yyerror(char *s)
{
  return yyerror(std::string(s));
}
