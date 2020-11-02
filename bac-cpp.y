%require "3.2"
%debug
%defines "parser.h"
%output "parser.cpp"
%define api.namespace {bac}
%define api.parser.class {Parser}
%language "c++"

%code requires {
    #include <cstdio>
    #include <string>
    #include <inttypes.h>

    namespace bac {
        class Lexer;
    }

    // The following definitions is missing when %locations isn't used
    #ifndef YY_NULLPTR
        #if defined __cplusplus && 201103L <= __cplusplus
            #define YY_NULLPTR nullptr
        #else
            #define YY_NULPTR 0
        #endif
    #endif
}

%parse-param {Lexer &lexer}

%code{
    #undef yylex
    #define yylex lexer.yylex

//    void print_rule(const char*, const char*);
}

%define api.value.type variant
%define parse.assert

%token                  S_COMMENT S_NL S_WS
%token                  T_COMMA T_SEMIC T_UNKNOWN
%token                  T_LPAREN T_RPAREN T_LBRACK
%token                  T_RBRACK T_LBRACE T_RBRACE
%token                  T_STAR T_DIV T_MINUS T_PLUS
%token                  T_LT T_GT T_LE T_GE T_EQ T_NE
%token                  T_AND T_OR T_AMPR T_NOT T_ASSIGN
%token                  K_BOOL K_CHAR K_INT K_VOID
%token                  K_CONST K_IF K_ELSE K_WHILE K_RET
%token <bool>           L_BOOL
%token <char>           L_CHAR
%token <std::string>    L_STRING T_IDENT
%token <int32_t>        L_INT


%locations

%start start

%%

start
    : expr
    ;

// Expression

expr
    : prim_expr                 {

                                }
    ;

prim_expr
    : literal                   {

                                }
    | T_LPAREN expr T_RPAREN    {

                                }
    | variable                  {

                                }
    ;

literal
    : L_CHAR                    {

                                }
    | L_INT                     {

                                }
    | L_STRING                  {

                                }
    | L_BOOL                    {

                                }
    ;

variable
    : T_IDENT                   {

                                }
    ;

%%

void bac::Parser::error( const location_type &loc, const std::string &msg ) {
    /* std::fprintf(stderr, "Line %d: %s\n", loc.begin.line, msg.c_str());
		exit(1); */
}
