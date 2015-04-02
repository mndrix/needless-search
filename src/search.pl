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
    respect_gitignore,
    " | ",
    xargs,
    " ",
    grep.
search -->
    git_grep.
search -->
    find,
    filter_langs,
    respect_gitignore,
    " | ",
    xargs,
    " ",
    grep.


respect_gitignore -->
    { inside_git_repository },
    !,
    " | git check-ignore -z --stdin --non-matching --verbose",

    % See Note_1
    " | perl -0lne 'if($. % 4==3 && !$_) { $_=<>; print }'".
respect_gitignore -->
    [].


/* Note_1

'git check-ignore' has no way to read stdin and filter out files that
should be ignored.  It seems like 'git check-ignore --stdin -n' should do
the job, but that command refuses to run without the --verbose option.

This Perl one-liner is a nasty workaround to strip out the verbose output
and select only those files which should not be ignored.

The verbose output is like this:

 <source> <NULL> <linenum> <NULL> <pattern> <NULL> <pathname> <NULL>

So there are 4 columns per record.  If the 3rd column is empty, there is
no gitignore pattern matching the file in question.  In that case, read
the next column and print it.

Justification for each Perl option:

  -0 : use null terminator
  -l : auto chomp and set output separator to match input separator
  -n : process each "line" (a null-separated chunk)
  -e : next argument is the script
*/
