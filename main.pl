:- consult('read_file.pl').
:- consult('parser.pl').
:- consult('compiler.pl').

main :- 
    current_prolog_flag(argv, [Filename | _]), 
    read_file(Filename, FileContent), 
    parse(FileContent, AST),
    compile(AST, Program),
    write_file(Filename, Program).

:- main, halt.
