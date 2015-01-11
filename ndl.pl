:- ['src/search.pl'].

:- dynamic pattern/1.

main([Pattern]) :-
    asserta(pattern(Pattern)),

    phrase(search,Pipeline),
    format(user_error, "~s~n", [Pipeline]),

    shell(Pipeline, Status),
    halt(Status).
