:- ['src/mdfind.pl'].
:- ['src/xargs.pl'].
:- ['src/grep.pl'].
:- ['src/git-grep.pl'].
:- ['src/find.pl'].
:- ['src/filter-langs.pl'].

% prioritized (by speed) list of strategies to fulfill a user's search
search -->
    mdfind,
    filter_langs,
    " | ",
    xargs,
    " ",
    grep.
search -->
    git_grep.
search -->
    find,
    filter_langs,
    " | ",
    xargs,
    " ",
    grep.
