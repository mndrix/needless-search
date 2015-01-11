:- ['src/mdfind.pl'].
:- ['src/xargs.pl'].
:- ['src/grep.pl'].

search -->
    mdfind,
    " | ",
    xargs,
    " ",
    grep.
