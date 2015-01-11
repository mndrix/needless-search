:- ['src/dcg.pl'].

mdfind -->
    { pattern(Pattern) },
    "mdfind",
    " -onlyin .",
    " -0",
    " ",
    atom(Pattern).
