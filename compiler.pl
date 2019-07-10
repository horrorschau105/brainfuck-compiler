compile(AST, Program) :-
    compile(AST, [], Program).

compile([], Program, Program) :- !.

compile(program(SubInstructions), Acc, Program) :-
    !,
    append(Acc, [
        '#include <stdio.h>', 
        'int main() {', 
        'char* ptr; ',
        'char t[30000];',
        'ptr = &t[0];'], Acc1),
    compile(SubInstructions, SubProgram),
    append(Acc1, SubProgram, Acc2),
    append(Acc2, ['}'], Program).

compile(readValue, Acc, Program) :-
    !,
    append(Acc, ['scanf("%c", ptr);'], Program).

compile(printValue, Acc, Program) :-
    !,
    append(Acc, ['printf("%c", *ptr);'], Program).

compile(incrementAddress, Acc, Program) :-
    !,
    append(Acc, ['ptr++;'], Program).

compile(decrementAddress, Acc, Program) :-
    !,
    append(Acc, ['ptr--;'], Program).

compile(incrementValue, Acc, Program) :-
    !,
    append(Acc, ['*ptr++;'], Program).

compile(decrementValue, Acc, Program) :-
    !,
    append(Acc, ['*ptr--;'], Program).

compile(loop(SubInstructions), Acc, Program) :-
    !,
    append(Acc, ['while(*ptr) {'], Acc1),
    compile(SubInstructions, SubProgram),
    append(Acc1, SubProgram, Acc2),
    append(Acc2, ['}'], Program).

compile([Instruction | Rest], Acc, Program) :-
    compile(Instruction, SubProgram),
    append(Acc, SubProgram, Acc1),
    compile(Rest, Acc1, Program).