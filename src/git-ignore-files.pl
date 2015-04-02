:- use_module(library(readutil), [read_line_to_codes/3]).
:- ['src/dcg.pl'].

:- dynamic git_ignores/1.

git_ignore_files :-
    prompt(_,''),  % don't show "|: " prompt
    working_directory(CwdAtom,CwdAtom),
    atom_codes(CwdAtom,Cwd),
    assert_ignored_files,
    git_ignore_files(Cwd).

git_ignore_files(Cwd) :-
    read_null_to_codes(current_input,RawPath),
    RawPath \= end_of_file,
    !,
    path_relative(Cwd,RawPath,RelativePath),
    atom_codes(Path,RelativePath),
    ( git_ignores(Path) -> true; format("~s\0",[Path]) ),
    git_ignore_files(Cwd).
git_ignore_files(_).


assert_ignored_files :-
    process_create(
        path(git),
        ['ls-files','-z','--ignored','--others','--exclude-standard'],
        [stdin(null),stdout(pipe(Out))]
    ),
    assert_ignored_files(Out).

assert_ignored_files(LsFiles) :-
    read_null_to_codes(LsFiles,PathCodes),
    PathCodes \= end_of_file,
    !,
    atom_codes(Path,PathCodes),
    assert(git_ignores(Path)),
    assert_ignored_files(LsFiles).
assert_ignored_files(LsFiles) :-
    close(LsFiles),
    compile_predicates([git_ignores/1]).


% read a single, null-separated entry from a stream
read_null_to_codes(Stream,Entry) :-
    get_code(Stream,Code),
    ( Code = -1 -> % end of file
        Entry=end_of_file
    ; Code = 0 -> % null terminator
        Entry=[]
    ; otherwise ->
        Entry=[Code|Rest],
        read_null_to_codes(Stream,Rest)
    ).


%% path_relative(+Cwd:codes,+Path:codes,-RelativePath:codes)
%
%  Converts Path (an absolute path inside Cwd or a path qualified
%  with "./") into a RelativePath where those leading components are stripped.
path_relative(_,[0'., 0'/|RelativePath], RelativePath) :-
    !.
path_relative(Cwd,Path,RelativePath) :-
    append(Cwd,RelativePath,Path),
    !.
path_relative(_,Path,Path).
