%% literal_prefix(+Pattern:atom,-Prefix:atom)
%
%  True if Prefix is a literal string which must begin
%  any string that matches Pattern.
literal_prefix(PatternAtom,PrefixAtom) :-
    atom_codes(PatternAtom,Pattern),
    once(phrase(literal_prefix(Prefix), Pattern, _)),
    atom_codes(PrefixAtom,Prefix).


literal_prefix([C|Cs]) -->
    [C],
    { \+ regex_meta(C) },
    literal_prefix(Cs).
literal_prefix([]) -->
    [].


regex_meta(0'*). % ' syntax
regex_meta(0'.). % '
regex_meta(0'?). % '
regex_meta(0'[). % '
regex_meta(0']). % '
regex_meta(0'(). % '
regex_meta(0')). % '
regex_meta(0'^). % '
regex_meta(0'$). % '
