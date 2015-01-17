:- use_module(library(dcg_util),[list//3]).
:- ['src/dcg.pl'].
:- ['src/environment.pl'].

git_grep -->
    { permissible_search_strategy('git-grep') },
    { inside_git_repository },
    { pattern(Pattern) },
    "git grep",
    " --untracked",
    " -I", % don't match pattern in binary files
    " -H", % include filename for each match
    " -n", % include line number for each match
    " --no-color",
    " -e '", atom(Pattern), "'",
    pathspec.


inside_git_repository :-
    exists_directory('.git').


pathspec -->
    { include_lang(Lang) },
    !,
    " -- ",
    { findall(E,lang_extension(Lang,E),Exts) },
    list_(pathspec_extension,space,Exts),
    " ",
    { findall(F,lang_filename(Lang,F),Files) },
    list_(atom,space,Files).
pathspec -->
    "".

space --> " ".

pathspec_extension(Ext) -->
    "'*.", atom(Ext), "'".

% work around the way that list//3 handles empty lists
list_(Elem,Sep,Elems) -->
    ( { Elems=[] } -> []; list(Elem,Sep,Elems) ).
