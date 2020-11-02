%{
    #include <inttypes.h>
    #include "lexer.h"
    #undef YY_DECL
    #define YY_DECL int bac::Lexer::yylex(bac::Parser::semantic_type *lval, bac::Parser::location_type *loc)

    using token = bac::Parser::token;

    #define YY_USER_ACTION loc->step(); loc->columns(YYLeng());

    /* const char* token_to_string(int token) {
        switch(token) {
            case token::T_LPAREN:
                return "T_LPAREN";
            case token::T_RPAREN:
                return "T_RPAREN";
            case token::T_COMMA:
                return "T_COMMA";
            case token::T_SEMIC:
                return "T_SEMIC";
            case token::T_LBRACK:
                return "T_LBRACK";
            case token::T_RBRACK:
                return "T_RBRACK";
            case token::T_LBRACE:
                return "T_LBRACE";
            case token::T_RBRACE:
                return "T_RBRACE";
            case token::T_STAR:
                return "T_STAR";
            case token::T_DIV:
                return "T_DIV";
            case token::T_MINUS:
                return "T_MINUS";
            case token::T_PLUS:
                return "T_PLUS";
            case token::T_LT:
                return "T_LT";
            case token::T_GT:
                return "T_GT";
            case token::T_GE:
                return "T_GE";
            case token::T_LE:
                return "T_LE";
            case token::T_EQ:
                return "T_EQ";
            case token::T_NE:
                return "T_NE";
            case token::T_AND:
                return "T_AND";
            case token::T_OR:
                return "T_OR";
            case token::T_AMPR:
                return "T_AMPR";
            case token::T_NOT:
                return "T_NOT";
            case token::T_ASSIGN:
                return "T_ASSIGN";
            case token::K_BOOL:
                return "K_BOOL";
            case token::K_CHAR:
                return "K_CHAR";
            case token::K_CONST:
                return "K_CONST";
            case token::K_IF:
                return "K_IF";
            case token::K_ELSE:
                return "K_ELSE";
            case token::K_INT:
                return "K_INT";
            case token::K_WHILE:
                return "K_WHILE";
            case token::K_VOID:
                return "K_VOID";
            case token::K_RET:
                return "K_RET";
            case token::L_FALSE:
                return "L_FALSE";
            case token::L_TRUE:
                return "L_TRUE";
            case token::L_CHAR:
                return "L_CHAR";
            case token::L_STRING:
                return "L_STRING";
            case token::T_IDENT:
                return "T_IDENT";
            case token::T_UNKNOWN:
                return "T_UNKNOWN"
            case token::S_COMMENT:
                return "S_COMMENT";
            case token::S_NL:
                return "S_NL";
            case token::S_WS:
                return "S_WS";
            default:
                return "UNKNOWN";
        }
    } */

    void print_token(int token, char* text) {
        /* printf("Token: %s, Lexeme: %s\n", token_to_string(token), text); */
    }

    void print_loc(int token, bac::Parser::location_type *loc) {
        /* printf(
            "Token: %s, Loc: %d:%d to %d:%d\n",
            token_to_string(token),
            loc->begin->line, loc->begin->column,
            loc->end->line, loc->end->column
        ); */
    }
%}

%option debug
%option nodefault
%option yyclass="bac::Lexer"
%option noyywrap
%option c++
%option outfile="lexer.cpp"

NEWLINE         "\n"
WSPACE          [ \t\r]+

QUOTE           "'"
DOUBLEQUOTE     "\""
UNDERSCORE      "_"

OCTAL           [0-7]
N_DIGIT         [1-9]
DIGIT           [0-9]
HEX             [0-9a-fA-F]
ALPHA           [a-zA-Z]
ALPHANUM        {ALPHA}|{DIGIT}

IDENT           ({ALPHA}|{UNDERSCORE})({ALPHANUM}|{UNDERSCORE})*

ESC_SEQ         "\\"({OCTAL}{1,3}|"x"{HEX}{1,2}|"u"{HEX}{4}|"U"{HEX}{8}|.)
CHAR_LIT        {QUOTE}([^\\]|{ESC_SEQ}){QUOTE}
/* CHAR_LIT				{QUOTE}.{QUOTE} */
STR_LIT         {DOUBLEQUOTE}([^\\]|{ESC_SEQ})*{DOUBLEQUOTE}
/* STR_LIT				{DOUBLEQUOTE}.*{DOUBLEQUOTE} */

DEC_LIT         {N_DIGIT}{DIGIT}*
HEX_LIT         "0"[Bb]{HEX}+
OCT_LIT         "0"{OCTAL}*
BIN_LIT         "0"[Xx][01]+

%x C_COMMENT
%%

"//".*                  {
                            // skip comment
                            print_loc(token::S_COMMENT, loc);
                        }

"/*"                    {
                            // skip comment
                            BEGIN(C_COMMENT);
                            print_loc(token::S_COMMENT, loc);
                        }

<C_COMMENT>"*/"         {
                            BEGIN(INITIAL);
                            print_loc(token::S_COMMENT, loc);
                        }

<C_COMMENT>.            {

                        }

<C_COMMENT>{NEWLINE}    {
                            loc->lines();
                        }

","                     {
                            print_token(token::T_COMMA, YYText());
                            return token::T_COMMA;
                        }

";"                     {
                            print_token(token::T_SEMIC, YYText());
                            return token::T_SEMIC;
                        }

"("                     {
                            print_token(token::T_LPAREN, YYText());
                            return token::T_LPAREN;
                        }

")"                     {
                            print_token(token::T_RPAREN, YYText());
                            return token::T_RPAREN;
                        }

"["                     {
                            print_token(token::T_LBRACK, YYText());
                            return token::T_LBRACK;
                        }

"]"                     {
                            print_token(token::T_RBRACK, YYText());
                            return token::T_RBRACK;
                        }

"{"                     {
                            print_token(token::T_LBRACE, YYText());
                            return token::T_LBRACE;
                        }

"}"                     {
                            print_token(token::T_RBRACE, YYText());
                            return token::T_RBRACE;
                        }

"*"                     {
                            print_token(token::T_STAR, YYText());
                            return token::T_STAR;
                        }

"/"                     {
                            print_token(token::T_DIV, YYText());
                            return token::T_DIV;
                        }

"-"                     {
                            print_token(token::T_MINUS, YYText());
                            return token::T_MINUS;
                        }

"+"                     {
                            print_token(token::T_PLUS, YYText());
                            return token::T_PLUS;
                        }

"<"                     {
                            print_token(token::T_LT, YYText());
                            return token::T_LT;
                        }

"<="                    {
                            print_token(token::T_LE, YYText());
                            return token::T_LE;
                        }

"!="                    {
                            print_token(token::T_NE, YYText());
                            return token::T_NE;
                        }

"=="                    {
                            print_token(token::T_EQ, YYText());
                            return token::T_EQ;
                        }

">"                     {
                            print_token(token::T_GT, YYText());
                            return token::T_GT;
                        }

">="                    {
                            print_token(token::T_GE, YYText());
                            return token::T_GE;
                        }

"&&"                    {
                            print_token(token::T_AND, YYText());
                            return token::T_AND;
                        }

"||"                    {
                            print_token(token::T_OR, YYText());
                            return token::T_OR;
                        }

"&"                     {
                            print_token(token::T_AMPR, YYText());
                            return token::T_AMPR;
                        }

"!"                     {
                            print_token(token::T_NOT, YYText());
                            return token::T_NOT;
                        }

"="                     {
                            print_token(token::T_ASSIGN, YYText());
                            return token::T_ASSIGN;
                        }

"bool"                  {
                            print_token(token::K_BOOL, YYText());
                            return token::K_BOOL;
                        }

"char"                  {
                            print_token(token::K_CHAR, YYText());
                            return token::K_CHAR;
                        }

"const"                 {
                            print_token(token::K_CONST, YYText());
                            return token::K_CONST;
                        }

"if"                    {
                            print_token(token::K_IF, YYText());
                            return token::K_IF;
                        }

"else"                  {
                            print_token(token::K_ELSE, YYText());
                            return token::K_ELSE;
                        }

"int"                   {
                            print_token(token::K_INT, YYText());
                            return token::K_INT;
                        }

"while"                 {
                            print_token(token::K_WHILE, YYText());
                            return token::K_WHILE;
                        }

"void"                  {
                            print_token(token::K_VOID, YYText());
                            return token::K_VOID;
                        }

"return"                {
                            print_token(token::K_RET, YYText());
                            return token::K_RET;
                        }

"false"                 {
                            print_token(token::K_FALSE, YYText());
                            lval->build<bool>(false);
                            return token::L_BOOL;
                        }

"true"                  {
                            print_token(token::K_TRUE, YYText());
                            lval->build<bool>(true);
                            return token::L_BOOL;
                        }

{CHAR_LIT}              {
                            print_token(token::L_CHAR, YYText());
                            lval->build<char>(YYText()[1]);
                            return token::L_CHAR;
                        }

{STR_LIT}               {
                            print_token(token::L_STRING, YYText());
                            std::string tmp(YYText());
                            tmp = std::string::substr(1, YYLeng() - 2);
                            lval->build<std::string>(tmp);
                            return token::L_STRING;
                        }

{DEC_LIT}               {
                            print_token(token::L_INT, YYText());
                            lval->build<int32_t>(std::stoi(YYText()));
                            return token::L_INT;
                        }

{OCT_LIT}               {
                            print_token(token::L_INT, YYText());
                            lval->build<int32_t>(std::stoi(YYText(), nullptr, 8));
                            return token::L_INT;
                        }

{HEX_LIT}               {
                            print_token(token::L_INT, YYText());
                            lval->build<int32_t>(std::stoi(YYText(), nullptr, 16));
                            return token::L_INT;
                        }

{BIN_LIT}               {
                            print_token(token::L_INT, YYText());
                            lval->build<int32_t>(std::stoi(YYText(), nullptr, 2));
                        }

{IDENT}                 {
                            print_token(token::T_IDENT, YYText());
                            lval->build<std::string>(YYText());
                            return token::T_IDENT
                        }

{WSPACE}                {
                            // skip whitespace
                            print_loc(token::S_WS, loc);
                        }

{NEWLINE}               {
                            print_loc(token::S_NL, loc);
                            loc->lines();
                        }

.                       {
                            print_token(token::T_UNKNOWN, YYText());
                            return T_UNKNOWN;
                        }

%%
