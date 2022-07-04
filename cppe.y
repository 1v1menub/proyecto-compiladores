%{
#include "heading.h"

extern "C" int yylex();
int yyerror(char *s);


struct variable {
  std::string *tipo;
  int val;
  bool array;
  bool funcion;
  int tamano;
  int args;
};

std::map<std::string, variable> tabla;
std::map<std::string, variable> temp; // mapa de parametros y variables de funciones
std::map<std::string, std::map<std::string, variable> > tabla_func;
std::string func_actual;
int temp_args = 0;

void insertar_variable(std::string id, variable val);
bool buscar_variable(std::string id);
bool buscar_param(std::string id);
void actualizar_variable(std::string, variable new_val);
void insertar_param(std::string id, variable val);

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

programa: declaraciones
{
  std::cout << "Compilado!" << std::endl;
};
 
declaraciones:  declaraciones declaracion
              | declaracion;
 
declaracion:  declaracion_variable declaracion
            | declaracion_funcion declaracion
            | principal;
 
declaracion_variable: ENTERO ID END
    {
      if (!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        insertar_variable(std::string(*$2), v);
      }
      else
      {
        std::string v = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + v + "\' ya definida").c_str()));
      }
    }
  |  ENTERO ID COR_A NUM COR_C END
    {
      if (!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=true;
        v.funcion=false;
        v.tamano=$4;
        insertar_variable(std::string(*$2), v);
      }
      else
      {
        std::string v = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + v + "\' ya definida").c_str()));
      }
    }
  |  BOOLEANO ID END
    {
      if (!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        insertar_variable(std::string(*$2), v);
      }
      else
      {
        std::string v = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + v + "\' ya definida").c_str()));
      }
    }
  |  BOOLEANO ID COR_A NUM COR_C END
    {
      if (!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=true;
        v.funcion=false;
        v.tamano=$4;
        insertar_variable(std::string(*$2), v);
      }
      else
      {
        std::string v = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + v + "\' ya definida").c_str()));
      }
    }
  |  FLOTANTE ID END
    {
      if (!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        insertar_variable(std::string(*$2), v);
      }
      else
      {
        std::string v = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + v + "\' ya definida").c_str()));
      }
    }
  |  FLOTANTE ID COR_A NUM COR_C END
    {
      if (!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=true;
        v.funcion=false;
        v.tamano=$4;
        insertar_variable(std::string(*$2), v);
      }
      else
      {
        std::string v = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + v + "\' ya definida").c_str()));
      }
    }
  |  CARACTER ID END
    {
      if (!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        insertar_variable(std::string(*$2), v);
      }
      else
      {
        std::string v = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + v + "\' ya definida").c_str()));
      }
    }
  |  CARACTER ID COR_A NUM COR_C END
    {
      if (!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=true;
        v.funcion=false;
        v.tamano=$4;
        insertar_variable(std::string(*$2), v);
      }
      else
      {
        std::string v = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + v + "\' ya definida").c_str()));
      }
    };

declaracion_funcion:  ENTERO ID PAR_A parametros PAR_C sent_compuesta
    {
      if (!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=true;
        insertar_variable(std::string(*$2), v);
      }
      else
      {
        std::string v = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + v + "\' ya definida").c_str()));
      }
    }
|  BOOLEANO ID PAR_A parametros PAR_C sent_compuesta
    {
      if(!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=true;
        v.args = temp_args;
        tabla_func[std::string(*$2)] = temp;
        temp.clear();
        insertar_variable(std::string(*$2), v);
        temp_args = 0;
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Funcion \'"   + s + "\' ya definida").c_str()));
      }
    };
|  FLOTANTE ID PAR_A parametros PAR_C sent_compuesta
    {
      if(!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=true;
        tabla_func[std::string(*$2)] = temp;
        temp.clear();
        v.args = temp_args;
        insertar_variable(std::string(*$2), v);
        temp_args = 0;
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Funcion \'" + s + "\' ya definida").c_str()));
      }
    }

|  CARACTER ID PAR_A parametros PAR_C sent_compuesta
    {
      if(!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=true;
        tabla_func[std::string(*$2)] = temp;
        temp.clear();
        v.args = temp_args;
        insertar_variable(std::string(*$2), v);
        temp_args = 0;
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Funcion \'" + s + "\' ya definida").c_str()));
      }
    }
|  VACIO ID PAR_A parametros PAR_C sent_compuesta
    {
      if(!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=true;
        tabla_func[std::string(*$2)] = temp;
        temp.clear();
        v.args = temp_args;
        insertar_variable(std::string(*$2), v);
        temp_args = 0;
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Funcion \'" + s + "\' ya definida").c_str()));
      }
    };
 
principal:  ENTERO PRINCIPAL PAR_A parametros PAR_C sent_compuesta
    {
      if(!buscar_variable(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=true;
        insertar_variable(std::string(*$2), v);
        temp_args = 0;
      }
      else
      {
        yyerror(const_cast<char*>(("Funcion principal ya definida")));
      }
    };
 
parametros: lista_parametros
          | VACIO; 
 
lista_parametros: lista_parametros COMA parametro 
                | parametro;
 
parametro:  ENTERO ID 
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        temp_args++;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
          | ENTERO ID COR_A COR_C
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        temp_args++;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
          | BOOLEANO ID
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        temp_args++;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
          | BOOLEANO ID COR_A COR_C
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        temp_args++;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
          | FLOTANTE ID
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        temp_args++;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
          | FLOTANTE ID COR_A COR_C 
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        temp_args++;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
          | CARACTER ID
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        temp_args++;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }      
          | CARACTER ID COR_A COR_C
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        temp_args++;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
          | VACIO ID
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        temp_args++;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    };
 
sent_compuesta: LLAVE_A declaracion_local lista_sentencias LLAVE_C; 
 
declaracion_local:  declaracion_local declaracion_variable_func 
                  | /* empty */;
 
declaracion_variable_func:  ENTERO ID END
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
                          | ENTERO ID COR_A NUM COR_C END
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=true;
        v.funcion=false;
        v.tamano=$4;
        
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
                          | BOOLEANO ID END
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    } 
                          | BOOLEANO ID COR_A NUM COR_C END
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=true;
        v.funcion=false;
        v.tamano=$4;
        
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
                          | FLOTANTE ID END
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
                          | FLOTANTE ID COR_A NUM COR_C END
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=true;
        v.funcion=false;
        v.tamano=$4;
        
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
                          | CARACTER ID END
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=false;
        v.funcion=false;
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    }
                          | CARACTER ID COR_A NUM COR_C END
    {
      if(!buscar_param(std::string(*$2)))
      {
        variable v;
        v.tipo=$1;
        v.array=true;
        v.funcion=false;
        v.tamano=$4;
        
        insertar_param(std::string(*$2), v);
      }
      else
      {
        std::string s = std::string(*$2);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' ya definida").c_str()));
      }
    };
   
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
    {
      if(!buscar_variable(std::string(*$1)) && !buscar_param(std::string(*$1)))
      {
        /* Error */
        std::string s = std::string(*$1);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' no definida").c_str()));
        // yyerror("Variable no definida!");
      }
      else if(buscar_param(std::string(*$1)))
      {
        if(!temp[std::string(*$1)].array)
        {
          std::string s = std::string(*$1);
          yyerror(const_cast<char*>(("Uso de la variable \'" + s + "\' de modo incorrecto").c_str()));
          // yyerror("Tipo de variable incorrecto!");

        }
        else if(temp[std::string(*$1)].funcion)
        {
          std::string s = std::string(*$1);
          yyerror(const_cast<char*>(("Uso de la variable \'" + s + "\' de modo incorrecto").c_str()));
          // yyerror("Tipo de variable incorrecto!");
        }
      }
      else if(buscar_variable(std::string(*$1)))
      {
        if(!tabla[std::string(*$1)].array)
        {
          std::string s = std::string(*$1);
          yyerror(const_cast<char*>(("Uso de la variable \'" + s + "\' de modo incorrecto").c_str()));
          // yyerror("Tipo de variable incorrecto!");

        }
        else if(tabla[std::string(*$1)].funcion)
        {
          std::string s = std::string(*$1);
          yyerror(const_cast<char*>(("Uso de la variable \'" + s + "\' de modo incorrecto").c_str()));
          // yyerror("Tipo de variable incorrecto!");
        }
      }
    }
    | ID
    {
      if(!buscar_variable(std::string(*$1)) && !buscar_param(std::string(*$1)))
      {
        /* Error */
        std::string s = std::string(*$1);
        yyerror(const_cast<char*>(("Variable \'" + s + "\' no definida").c_str()));
        // yyerror("Variable no definida!");
      }else if(buscar_param(std::string(*$1))){
        if(temp[std::string(*$1)].array)
        {
          std::string s = std::string(*$1);
          yyerror(const_cast<char*>(("Uso de la variable \'" + s + "\' de modo incorrecto").c_str()));
          // yyerror("Tipo de variable incorrecto!");

        }
        else if(temp[std::string(*$1)].funcion)
        {
          std::string s = std::string(*$1);
          yyerror(const_cast<char*>(("Uso de la variable \'" + s + "\' de modo incorrecto").c_str()));
          // yyerror("Tipo de variable incorrecto!");
        }
      }
      else if(buscar_variable(std::string(*$1))){
        if(tabla[std::string(*$1)].array)
        {
          std::string s = std::string(*$1);
          yyerror(const_cast<char*>(("Uso de la variable \'" + s + "\' de modo incorrecto").c_str()));
          // yyerror("Tipo de variable incorrecto!");

        }
        else if(tabla[std::string(*$1)].funcion)
        {
          std::string s = std::string(*$1);
          yyerror(const_cast<char*>(("Uso de la variable \'" + s + "\' de modo incorrecto").c_str()));
          // yyerror("Tipo de variable incorrecto!");
        }
      }
    };
 
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
 
call: ID PAR_A args PAR_C 
    {
      if(!buscar_variable(std::string(*$1)))
      {
        /* Error */
        yyerror(const_cast<char*>("Variable no definido!"));
      }
      else if(tabla[std::string(*$1)].array)
      {
        yyerror(const_cast<char*>("Tipo de variable incorrecto!"));
      }
      else if(!tabla[std::string(*$1)].funcion)
      {
        yyerror(const_cast<char*>("Tipo de variable incorrecto!"));
      }
      else if (tabla[std::string(*$1)].args != temp_args)
      {
        std::string s = std::string(*$1);
        yyerror(const_cast<char*>(("Fallo en el ingreso de argumentos de " + s +"()").c_str()));
      }

      temp_args = 0;
    };
   
args: lista_arg 
    | /* empty */ ;
 
lista_arg:  lista_arg COMA expresion 
    {
      temp_args++;
    }
          | expresion 
    {
      temp_args++;
    };

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

void insertar_variable(std::string id, variable val)
{
  tabla[id]=val;
}

void insertar_param(std::string id, variable val)
{
  temp[id]=val;
}

bool buscar_variable(std::string id)
{
  return tabla.find(id)!=tabla.end();
}

bool buscar_param(std::string id)
{
  return temp.find(id)!=temp.end();
}