process_stream(Stream, Output) :-
    get_char(Stream, Char),
    process_stream(Char, Stream, [], Output).

process_stream(end_of_file, _, Result, Result) :- !.
process_stream(Char, Stream, Acc, Result) :-
    char_code(Char, Code),
    append(Acc, [Code], NewAcc),
    get_char(Stream, NewChar),
    process_stream(NewChar, Stream, NewAcc, Result).

read_file(Filename, Characters) :-
    open(Filename, read, Stream),
    process_stream(Stream, Characters),
    close(Stream).

change_extension(Old, New) :- % from *.bf to *.c
    split_string(Old, '.', '', Parts),
    selectchk("bf", Parts, Purename),
    append(Purename, ['c'], NewName),
    atomics_to_string(NewName, '.', New).

write_file(FilenameBf, Content) :-
    change_extension(FilenameBf, FilenameC),
    open(FilenameC, write, Stream),
    write_content(Content, Stream),
    close(Stream).

write_content([], _) :- !.

write_content([Line | Rest], Stream) :-
    writeln(Stream, Line),
    write_content(Rest, Stream).