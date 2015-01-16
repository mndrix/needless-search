:- ['src/dcg.pl'].

mdfind -->
    { pattern(Pattern) },
    "mdfind",
    " -onlyin .",
    " -0 ",
    query('TextContent'==Pattern).


query(Query) -->
    "\"",
    query_(Query),
    "\"".

query_(Key==Value) -->
    "kMDItem",
    atom(Key),
    "==",
    "'", atom(Value), "'".
