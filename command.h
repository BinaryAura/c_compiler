//
// Created by jadunker on 11/1/20.
//

#ifndef BAC_CPP_COMMAND_H
#define BAC_CPP_COMMAND_H

#include <iostream>
#include <string>

namespace bac {

    class Command {
        enum Operator {
            Assign,
            IndexAssign,
            Index,
            Addition,
            Subtraction,
            Multiplication,
            Division,
            Modulus
        };

        std::string label;
        std::string dest;
        std::string src1;
        std::string src2;
        Operator op;
    };

}

#endif //BAC_CPP_COMMAND_H
