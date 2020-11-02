#ifndef MC_SCANNER_HPP
#define MC_SCANNER_HPP

#if ! defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif

#include "parser.h"
#include "location.hh"

namespace bac {

  class Lexer : public yyFlexLexer{
  public:

    Lexer(std::istream *in) : yyFlexLexer(in) {
      loc = new Lexer::location_type();
    };

    //get rid of override virtual function warning
    using FlexLexer::yylex;

    virtual int yylex( bac::Lexer::semantic_type * const lval, Lexer::location_type *loc);
    // YY_DECL defined in mc_lexer.l
    // Method body created by flex in mc_lexer.yy.cc

  private:
    MC::MC_Parser::location_type *loc = nullptr;
  };
} /* end namespace MC */

#endif /* END MC_SCANNER_HPP */
