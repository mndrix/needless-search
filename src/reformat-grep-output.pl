:- use_module(library(ansi_term), [ansi_format/3]).
:- use_module(library(readutil), [read_line_to_codes/3]).
:- ['src/dcg.pl'].

% predicate has IO and logic intertwined, not as clean as I'd like
reformat_grep_output(Pattern) :-
    prompt(_,''),
    working_directory(CwdAtom,CwdAtom),
    atom_codes(CwdAtom,Cwd),
    reformat_grep_output_(Cwd,no(previous),Pattern).

reformat_grep_output_(Cwd,PrevPath,Pattern) :-
    read_line_to_codes(current_input,Line),
    Line \= end_of_file,
    !,
    phrase(grep_line(Path,N,Content),Line),
    print_match(Cwd,PrevPath,Path,N,Content),
    reformat_grep_output_(Cwd,Path,Pattern).
reformat_grep_output_(_,_,_).


grep_line(Path,N,Content) -->
    string_without(0':, Path), %'
    ":",
    integer(N),
    ":",
    rest_of_line(Content).


print_match(Cwd,PrevPath,Path,N,Content) :-
    ( PrevPath = Path ->
        true  % no header line needed
    ; otherwise ->
        ( PrevPath = no(previous) -> true; nl ),
        ( phrase(string(Cwd),Path,RelativePath) ->
            true
        ; otherwise ->
            RelativePath = Path
        ),
        ansi_format([bold,fg(green)],"~s",[RelativePath]),
        nl
    ),
    ansi_format([bold,fg(yellow)],"~d", [N]),
    format(":~s~n",[Content]).
