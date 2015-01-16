:- use_module(library(ansi_term), [ansi_format/3]).
:- use_module(library(readutil), [read_line_to_codes/3]).
:- ['src/dcg.pl'].

% predicate has IO and logic intertwined, not as clean as I'd like
reformat_grep_output(Pattern) :-
    prompt(_,''),
    reformat_grep_output_(no(previous),Pattern).

reformat_grep_output_(PrevPath,Pattern) :-
    read_line_to_codes(current_input,Line),
    Line \= end_of_file,
    !,
    phrase(grep_line(Path,N,Content),Line),
    print_line(PrevPath,Path,N,Content),
    reformat_grep_output_(Path,Pattern).
reformat_grep_output_(_,_).


grep_line(Path,N,Content) -->
    string_without(0':, Path), %'
    ":",
    integer(N),
    ":",
    rest_of_line(Content).


print_line(PrevPath,Path,N,Content) :-
    ( PrevPath = Path ->
        true  % no header line needed
    ; otherwise ->
        ( PrevPath = no(previous) -> true; nl ),
        ansi_format([bold,fg(green)],"~s",[Path]),
        nl
    ),
    ansi_format([bold,fg(yellow)],"~d", [N]),
    format(":~s~n",[Content]).
