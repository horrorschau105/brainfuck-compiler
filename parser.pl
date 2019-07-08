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

program(AST) --> instructions(Instructions), {AST = program(Instructions)}.

instructions(Instructions) --> 
    instruction(H), instructions(T), !, { flatten([H, T], Instructions) } ;
    instruction(Instruction), {Instructions = [Instruction]}.

instruction(Ins) -->
    [tokAddrAddOne], !, {Ins = incrementAddress} ;
    [tokAddrSubOne], !, {Ins = decrementAddress} ;
    [tokValueAddOne], !, {Ins = incrementValue} ;
    [tokValueSubOne], !, {Ins = decrementValue} ;
    [tokPrint], !, {Ins = printValue} ;
    [tokRead], !, {Ins = readValue} ;
    [tokLoopBegin], instructions(Instructions), [tokLoopEnd], {Ins = loop(Instructions)}.

removeUnknownTokens(DirtyTokenList, ClearTokenList) :-
    removeUnknownTokens(DirtyTokenList, [], ClearTokenList).

removeUnknownTokens([], Result, Result).
removeUnknownTokens([tokUnknown | T], Acc, Result) :-
    !,
    removeUnknownTokens(T, Acc, Result).

removeUnknownTokens([KnownToken | T], Acc, Result) :-
    append(Acc, [KnownToken], NewAcc),
    removeUnknownTokens(T, NewAcc, Result).

parse(FileContent, AST) :-
    phrase(lexer(Tokens), FileContent), 
    removeUnknownTokens(Tokens, KnownTokens),
    phrase(instructions(AST), KnownTokens).
    


