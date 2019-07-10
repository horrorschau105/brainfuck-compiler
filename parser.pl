lexer(Tokens) -->
(
    (
    "+", !, {Token = tok_value_add_one} ;
    "-", !, {Token = tok_value_sub_one} ;
    ">", !, {Token = tok_addr_add_one} ;
    "<", !, {Token = tok_addr_sub_one} ;
    ",", !, {Token = tok_read} ;
    ".", !, {Token = tok_print} ;
    "[", !, {Token = tok_loop_begin} ;
    "]", !, {Token = tok_loop_end} ;
    [_],    {Token = tok_unknown} 
    ), 
    !,  { Tokens = [Token | TokList] }, lexer(TokList) ; 
    [], { Tokens = [] }
).

program(AST) --> instructions(Instructions), {AST = program(Instructions)}.

instructions(Instructions) --> 
    instruction(H), instructions(T), !, { flatten([H, T], Instructions) } ;
    instruction(Instruction), {Instructions = [Instruction]}.

instruction(Ins) -->
    [tok_addr_add_one], !, {Ins = increment_address} ;
    [tok_addr_sub_one], !, {Ins = decrement_address} ;
    [tok_value_add_one], !, {Ins = increment_value} ;
    [tok_value_sub_one], !, {Ins = decrement_value} ;
    [tok_print], !, {Ins = print_value} ;
    [tok_read], !, {Ins = read_value} ;
    [tok_loop_begin], instructions(Instructions), [tok_loop_end], {Ins = loop(Instructions)}.

remove_unknown_tokens(DirtyTokenList, ClearTokenList) :-
    remove_unknown_tokens(DirtyTokenList, [], ClearTokenList).

remove_unknown_tokens([], Result, Result).
remove_unknown_tokens([tok_unknown | T], Acc, Result) :-
    !,
    remove_unknown_tokens(T, Acc, Result).

remove_unknown_tokens([KnownToken | T], Acc, Result) :-
    append(Acc, [KnownToken], NewAcc),
    remove_unknown_tokens(T, NewAcc, Result).

parse(FileContent, AST) :-
    phrase(lexer(Tokens), FileContent), 
    remove_unknown_tokens(Tokens, KnownTokens),
    phrase(program(AST), KnownTokens).
