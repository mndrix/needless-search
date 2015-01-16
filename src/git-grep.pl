:- ['src/dcg.pl'].

git_grep -->
    { inside_git_repository },
    { pattern(Pattern) },
    "git grep",
    " --untracked",
    " -I", % don't match pattern in binary files
    " -H", % include filename for each match
    " -n", % include line number for each match
    " --no-color",
    " -e '", atom(Pattern), "'".


inside_git_repository :-
    exists_directory('.git').
