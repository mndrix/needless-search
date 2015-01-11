:- ['src/mdfind.pl'].
:- ['src/xargs.pl'].
:- ['src/grep.pl'].
:- ['src/git-grep.pl'].
:- ['src/find.pl'].

% prioritized (by speed) list of strategies to fulfill a user's search
search -->
    mdfind,
    " | ",
    xargs,
    " ",
    grep.
search -->
    git_grep.
search -->
    find,
    " | ",
    xargs,
    " ",
    grep.
