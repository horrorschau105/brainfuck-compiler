process_stream(Stream, Output) :-
    get_char(Stream, Char),
    process_stream(Char, Stream, [], Output).

process_stream(end_of_file, _, Result, Result) :- !.
process_stream(Char, Stream, Acc, Result) :-
    char_code(Char, Code),
    append(Acc, [Code], NewAcc),
    get_char(Stream, NewChar),
    process_stream(NewChar, Stream, NewAcc, Result).

readFile(Filename, Characters) :-
    open(Filename, read, Stream),
    process_stream(Stream, Characters),
    close(Stream).

changeExtension(Old, New) :-
    split_string(Old, '.', '', Parts),
    selectchk("bf", Parts, Purename),
    append(Purename, ['c'], NewName),
    atomics_to_string(NewName, '.', New).

writeFile(FilenameBf, Content) :-
    changeExtension(FilenameBf, FilenameC),
    open(FilenameC, write, Stream),
    writeContent(Content, Stream),
    close(Stream).

writeContent([], _) :- !.

writeContent([Line | Rest], Stream) :-
    writeln(Stream, Line),
    writeContent(Rest, Stream).