# NAME

up - optex module for multi-column paged output

# SYNOPSIS

    optex -Mup command ...

# DESCRIPTION

**up** is a module for the **optex** command that pipes the output
through [App::ansicolumn](https://metacpan.org/pod/App%3A%3Aansicolumn) for multi-column formatting and a pager.
The name comes from the printing term "n-up" (2-up, 3-up, etc.) which
refers to printing multiple pages on a single sheet.

The module automatically calculates the number of columns based on the
terminal width (`$COLUMNS`) divided by the column width (default 85
characters).

The pager command is taken from the `$PAGER` environment variable if
set, otherwise defaults to `less +Gg`.

# EXAMPLES

List files in multiple columns with pager:

    optex -Mup ls -l

# INSTALL

## CPANMINUS

    cpanm App::optex::up

# SEE ALSO

[App::optex](https://metacpan.org/pod/App%3A%3Aoptex), [https://github.com/kaz-utashiro/optex](https://github.com/kaz-utashiro/optex)

[App::optex::up](https://metacpan.org/pod/App%3A%3Aoptex%3A%3Aup), [https://github.com/kaz-utashiro/optex-up](https://github.com/kaz-utashiro/optex-up)

[App::ansicolumn](https://metacpan.org/pod/App%3A%3Aansicolumn)

# AUTHOR

Kazumasa Utashiro

# LICENSE

Copyright 2025 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
