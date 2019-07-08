:- consult('read_file.pl').
:- consult('parser.pl').

main :- 
    current_prolog_flag(argv, [Filename | _]), 
    readFile(Filename, FileContent), 
    parse(FileContent, AST),
    print(AST), 
    nl.

:- main, halt.
