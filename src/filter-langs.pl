:- use_module(library(dcg_util), [list//3]).

:- ['src/langs.pl'].

filter_langs -->
    " | ",
	"grep",
	" -z", % input is null separated
	" -Z", % output is null separated
	" -E", % extended regular expression
	" -e '", lang_filter_as_regex, "'".
filter_langs -->
    [].


lang_filter_as_regex -->
    { findall(E,(include_lang(L),lang_extension(L,E)),Extensions) },
    { findall(F,(include_lang(L),lang_filename(L,F)),Filenames) },
    lang_filter_as_regex_(Filenames,Extensions).

lang_filter_as_regex_(Filenames,Extensions) -->
    by_filename(Filenames),
    "|",
    by_extension(Extensions).
lang_filter_as_regex_(Filenames,_) -->
    by_filename(Filenames).
lang_filter_as_regex_(_,Extensions) -->
    by_extension(Extensions).


by_filename(Filenames) -->
    { Filenames \= [] },
    "/(",
    list(atom,pipe,Filenames),
    ")$".
by_extension(Extensions) -->
    { Extensions \= [] },
    "[.](",
    list(atom,pipe,Extensions),
    ")$".


pipe -->
    "|".
