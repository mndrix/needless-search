:- ['src/dcg.pl'].
:- ['src/environment.pl'].
:- ['src/regex.pl'].

mdfind -->
    { fail },  % permanently disable
    { permissible_search_strategy(mdfind) },
    { \+ mdfind_overlooks_our_files },
    { pattern(Pattern) },
    { literal_prefix(Pattern,Prefix) },
    { atom_length(Prefix,PrefixLen), PrefixLen > 3 },

    "mdfind",
    " -onlyin .",
    " -0 ",
    query('TextContent'==Prefix).


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
mdfind_wont_index_extension(css).
mdfind_wont_index_extension(json).
mdfind_wont_index_extension(ts).
mdfind_wont_index_extension(md).
