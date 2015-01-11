find -->
    "find .",
    " -type d",
    " -name .git",
    " -prune -false", % exclude VCS directories
    " -o",
    " -type f",
    " -print0".
