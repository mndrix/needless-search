:- use_module(library(ansi_term), [ansi_format/3]).
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
    ansi_format([bold,fg(green)],"~s",[Path]),
    nl,
    ansi_format([bold,fg(yellow)],"~d", [N]),
    format(":~s~n",[Content]),
    reformat_grep_output_(Pattern).
reformat_grep_output_(_).


grep_line(Path,N,Content) -->
    string_without(0':, Path), %'
    ":",
    integer(N),
    ":",
    rest_of_line(Content).
