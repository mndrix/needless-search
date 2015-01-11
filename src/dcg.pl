atom(A) -->
    { atom_codes(A,C) },
    string(C).

integer(N) -->
    { number_codes(N,C) },
    string(C).

string([C|Codes]) -->
    [C],
    string(Codes).
string([]) -->
    [].
