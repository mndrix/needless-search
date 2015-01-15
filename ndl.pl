:- ['src/pipeline.pl'].
:- ['src/reformat-grep-output.pl'].

:- dynamic pattern/1.
:- dynamic include_lang/1.

main(['--reformat-grep-output',Pattern]) :-
    !,
    reformat_grep_output(Pattern).
main(Args) :-
    get_time(Start),
    ( assert_environment(Args) -> true; halt(1) ),

    phrase(pipeline,Pipeline),
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
    ( atom_concat('--',Lang,Arg) ->
        assert_arg_lang(Lang)
    ; otherwise ->
        assert_arg_pattern(Arg)
    ).

assert_arg_lang(Lang) :-
    ( include_lang(Lang) ->
        true
    ; lang(Lang) ->
        assertz(include_lang(Lang))
    ; otherwise ->
        warn("Unknown language: ~s~n",[Lang]),
        fail
    ).

assert_arg_pattern(Second) :-
    pattern(First),
    warn("Two patterns given: '~s' then '~s'~n", [First,Second]),
    !,
    fail.
assert_arg_pattern(Pattern) :-
    assertz(pattern(Pattern)).


warn(Format,Args) :-
    format(user_error,Format,Args).
