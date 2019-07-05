lexer(Tokens) -->
(
    (
    "+", !, {Token = tokValueAddOne} ;
    "-", !, {Token = tokValueSubOne} ;
    ">", !, {Token = tokAddrAddOne} ;
    "<", !, {Token = tokAddrSubOne} ;
    ",", !, {Token = tokRead} ;
    ".", !, {Token = tokPrint} ;
    "[", !, {Token = tokLoopBegin} ;
    "]", !, {Token = tokLoopEnd} ;
    [_],    {Token = tokUnknown} 
    ), 
    !,  { Tokens = [Token | TokList] }, lexer(TokList) ; 
    [], { Tokens = [] }
).

readFile(Characters) :-
    open('example.bf', read, In),
    get_char(In, Char),
    process_stream(Char, In, [], Characters),
    close(In).
%:- readFile(Output), phrase(lexer(X), Output), print(X).

:- readFile(O), print(O).
