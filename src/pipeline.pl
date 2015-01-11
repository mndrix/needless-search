:- ['src/search.pl'].

pipeline -->
    search,
    " | ",
    reformat_grep_output.


reformat_grep_output -->
    "cat".
