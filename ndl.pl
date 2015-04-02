:- ['src/environment.pl'].
:- ['src/pipeline.pl'].
:- ['src/reformat-grep-output.pl'].

main(['--reformat-grep-output',Pattern]) :-
    !,
    reformat_grep_output(Pattern).
main(Args) :-
    get_time(Start),
    assert_environment(Args),

    phrase(pipeline,Pipeline),
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
