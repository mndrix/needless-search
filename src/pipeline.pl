:- ['src/search.pl'].
:- ['src/dcg.pl'].

pipeline -->
    search,
    " | ",
    reformat_grep_output.


reformat_grep_output -->
    { pattern(Pattern) },
    { executable(Exe) },
    atom(Exe),
    " --reformat-grep-output ",
    atom(Pattern).


executable(Exe) :-
    current_prolog_flag(os_argv, [_Swipl,_Dashx,Exe|_]),
    !.
executable(_) :-
    throw("Can't locate ndl executable").
