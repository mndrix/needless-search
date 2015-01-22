:- ['src/dcg.pl'].

grep -->
    { pattern(Pattern) },
    "grep",
    " -H",
    " -n",
    " --binary-files=without-match",
    " ",
    quoted_atom(Pattern).
