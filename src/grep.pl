:- ['src/dcg.pl'].

grep -->
    { pattern(Pattern) },
    "grep",
    " -H",
    " -n",
    " --binary-files=without-match",
    " ",
    atom(Pattern).
