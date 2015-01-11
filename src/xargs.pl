xargs -->
    { current_prolog_flag(cpu_count,N) },
    "xargs",
    " -0",
    " -n ", integer(100),
    " -P ", integer(N).
