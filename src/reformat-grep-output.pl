:- use_module(library(readutil), [read_line_to_codes/3]).
:- ['src/dcg.pl'].

% predicate has IO and logic intertwined, not as clean as I'd like
reformat_grep_output(Pattern) :-
    prompt(_,''),
    reformat_grep_output_(Pattern).

reformat_grep_output_(Pattern) :-
    read_line_to_codes(current_input,Line),
    Line \= end_of_file,
    !,
    phrase(grep_line(Path,N,Content),Line),
    format("~s~n~d~n~s~n",[Path,N,Content]),
    reformat_grep_output_(Pattern).
reformat_grep_output_(_).


grep_line(Path,N,Content) -->
    string_without(0':, Path), %'
    ":",
    integer(N),
    ":",
    rest_of_line(Content).
