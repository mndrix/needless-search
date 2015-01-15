atom(A) -->
    { atom_codes(A,C) },
    string(C).


integer(N) -->
    { ground(N) },
    !,
    { number_codes(N,C) },
    string(C).
integer(N) -->
    { var(N) },
    string_with(digit,C),
    { number_codes(N,C) }.



string([C|Codes]) -->
    [C],
    string(Codes).
string([]) -->
    [].


string_without(No,[C|Codes]) -->
    [C],
    { C \= No },
    !,
    string_without(No,Codes).
string_without(_,[]) -->
    [].


string_with(Goal,[C|Codes]) -->
    [C],
    { call(Goal,C) },
    !,
    string_with(Goal,Codes).
string_with(_,[]) -->
    [].


rest_of_line(Codes) -->
    string_without(0'\n,Codes).


digit(C) :-
    between(0'0, 0'9, C).
