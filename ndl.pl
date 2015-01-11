:- ['src/search.pl'].

:- dynamic pattern/1.

main([Pattern]) :-
    get_time(Start),
    asserta(pattern(Pattern)),

    phrase(search,Pipeline),
    warn("~s~n", [Pipeline]),

    shell(Pipeline, Status),
    get_time(Stop),
    runtime(Start, Stop),
    halt(Status).


runtime(Start,Stop) :-
    Duration is 1000*(Stop - Start),
    format("Runtime: ~1f ms~n", [Duration]).


warn(Format,Args) :-
    format(user_error,Format,Args).
