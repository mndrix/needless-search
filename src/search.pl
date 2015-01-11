:- ['src/mdfind.pl'].
:- ['src/xargs.pl'].
:- ['src/grep.pl'].
:- ['src/git-grep.pl'].

search -->
    mdfind,
    " | ",
    xargs,
    " ",
    grep.
search -->
    git_grep.
