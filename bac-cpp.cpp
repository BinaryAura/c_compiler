//
// Created by jadunker on 11/1/20.
//

#include <iostream>

#include "lexer.h"
#include "parser.h"

int main(int argc, char** argv) {

    bac::Lexer lexer(&std::cin);
    bac::Parser parser(lexer);
    parser.parse();

}