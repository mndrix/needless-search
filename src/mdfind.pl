:- ['src/dcg.pl'].

mdfind -->
    { pattern(Pattern) },
    { \+ mdfind_overlooks_our_files },

    "mdfind",
    " -onlyin .",
    " -0 ",
    query('TextContent'==Pattern).


query(Query) -->
    "\"",
    query_(Query),
    "\"".

query_((A;B)) -->
    query_(A),
    " || ",
    query_(B).
query_(Key==Value) -->
    "kMDItem",
    atom(Key),
    "==",
    "'", atom(Value), "'".

% true if mdfind doesn't index the files we want to search
mdfind_overlooks_our_files :-
    % without a whitelisted language, mdfind will miss something
    \+ include_lang(_).
mdfind_overlooks_our_files :-
    include_lang(Lang),
    lang_extension(Lang,Ext),
    mdfind_wont_index_extension(Ext).


% mdfind doesn't index files with these extensions
mdfind_wont_index_extension(json).
mdfind_wont_index_extension(md).
