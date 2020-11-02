
CXX ?= g++

BISONFILE = $(PROJECT).y

BISON = bison
BISONFLAGS = -d -v

FLEXFILE = $(PROJECT).l

FLEX = flex
FLEXFLAGS =

PROJECT = bac-cpp
EXE = $(PROJECT)
CXXDEBUG = -g -Wall

CXXSTD = -std=c++20

CXXFLAGS = -Wno-deprecated-register -O0 $(CXXDEBUG) $(CXXSTD)

CPPOBJ = $(PROJECT)
SOBJ = parser lexer

FILES = $(addsuffix .cpp, $(CPPOBJ))

OBJS = $(addsuffix .o, $(CPPOBJ))

CLEANLIST = $(addsuffix -o, $(OBJ)) $(OBJS) \
    parser.cpp parser.h \
    location.hh mc_parser.output parser.o \
    lexer.o lexer.cpp $(EXE)

.PHONY: all

all: $(EXE)

$(EXE): $(FILES)
	$(MAKE) $(SOBJ)
	$(MAKE) $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(EXE) $(OBJS) parser.o lexer.o $(LIBS)

parser: $(BISONFILE)
	$(BISON) $(BISONFLAGS) -o parser.cpp $<
	$(CXX) $(CXXFLAGS) -c -o parser.o parser.cpp

lexer: $(FLEXFILE)
	flex $<
	$(CXX) $(CXXFLAGS) -c lexer.cpp -o lexer.o

.PHONY: test
test:
	cd test && ./test0.pl

.PHONY: clean
clean:
	rm -rf $(CLEANLIST)
