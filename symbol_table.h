//
// Created by jadunker on 11/1/20.
//

#ifndef BAC_CPP_SYMBOL_TABLE_H
#define BAC_CPP_SYMBOL_TABLE_H

#include <inttypes.h>
#include <forward_list>
#include <unordered_map>
#include <string>

namespace bac {

    union Literal {
        u_int32_t i32;
    };

    class SymbolTable {
    public:
        struct Symbol {

            enum PrimitiveType {
                INT
            };

//            enum PointerOp {
//                Pointer
//            };
//
//            struct PointerSpec {
//                bool is_bool;
//                PointerOp op;
//            };

            struct SimpleType {

//                bool is_const;
//                std::forward_list<PointerSpec> ptr_spec;
                std::forward_list<PrimitiveType> type;
                Literal const_value;
            };

            union Type {
                SimpleType type;
            };

            std::string ident;
            Type type;
        };

    private:
        std::forward_list<std::unordered_map<std::string, Symbol>> scopes;
    };

}

#endif //BAC_CPP_SYMBOL_TABLE_H
