:- use_module(library(ansi_term), [ansi_format/3]).
:- use_module(library(readutil), [read_line_to_codes/3]).
:- ['src/dcg.pl'].

% predicate has IO and logic intertwined, not as clean as I'd like
reformat_grep_output(Pattern) :-
    prompt(_,''),  % don't show "|: " prompt
    working_directory(CwdAtom,CwdAtom),
    atom_codes(CwdAtom,Cwd),
    reformat_grep_output_(Cwd,Pattern,no_previous_path).

reformat_grep_output_(Cwd,Pattern,PrevPath) :-
    read_line_to_codes(current_input,Line),
    Line \= end_of_file,
    !,
    phrase(grep_line(Path,N,Content),Line),
    ignore(print_path(Cwd,PrevPath,Path)),
    print_content(N,Content),
    reformat_grep_output_(Cwd,Pattern,Path).
reformat_grep_output_(_,_,_).


grep_line(Path,N,Content) -->
    string_without(0':, Path), %'
    ":",
    integer(N),
    ":",
    rest_of_line(Content).


print_path(Cwd,PrevPath,Path) :-
    PrevPath \= Path,
    ( PrevPath = no_previous_path -> true; nl ),
    ( append(Cwd,RelativePath,Path) -> true; RelativePath=Path ),
    ansi_format([bold,fg(green)],"~s",[RelativePath]),
    nl.


print_content(N,Content) :-
    ansi_format([bold,fg(yellow)],"~d", [N]),
    format(":~s~n",[Content]).
