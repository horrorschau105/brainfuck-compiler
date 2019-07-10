:- consult('read_file.pl').
:- consult('parser.pl').
:- consult('compiler.pl').

main :- 
    current_prolog_flag(argv, [Filename | _]), 
    readFile(Filename, FileContent), 
    parse(FileContent, AST),
    compile(AST, Program),
    writeFile(Filename, Program).

:- main, halt.
