% describes the context (environment) in which ndl executes.
% this includes command line arguments, OS environment variables
% and user configuration details.

:- dynamic pattern/1.
:- dynamic include_lang/1.


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
        die("Unknown language: ~s~n",[Lang])
    ).

assert_arg_pattern(Second) :-
    pattern(First),
    die("Two patterns given: '~s' then '~s'~n", [First,Second]).
assert_arg_pattern(Pattern) :-
    assertz(pattern(Pattern)).


die(Format,Args) :-
    format(user_error,Format,Args),
    halt(1).
