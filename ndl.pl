:- ['src/search.pl'].

:- dynamic pattern/1.

main(Args) :-
    get_time(Start),
    ( assert_environment(Args) -> true; halt(1) ),

    phrase(search,Pipeline),
    warn("~s~n", [Pipeline]),

    shell(Pipeline, Status),
    get_time(Stop),
    runtime(Start, Stop),
    halt(Status).


runtime(Start,Stop) :-
    Duration is 1000*(Stop - Start),
    format("Runtime: ~1f ms~n", [Duration]).


assert_environment(Args) :-
    maplist(assert_arg,Args).

assert_arg(Arg) :-
    assert_arg_pattern(Arg).

assert_arg_pattern(Second) :-
    pattern(First),
    warn("Two patterns given: '~s' then '~s'~n", [First,Second]),
    !,
    fail.
assert_arg_pattern(Pattern) :-
    assertz(pattern(Pattern)).


warn(Format,Args) :-
    format(user_error,Format,Args).
