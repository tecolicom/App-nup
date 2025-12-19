[![Actions Status](https://github.com/tecolicom/App-nup/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/tecolicom/App-nup/actions?workflow=test) [![MetaCPAN Release](https://badge.fury.io/pl/App-nup.svg)](https://metacpan.org/release/App-nup)
# NAME

nup - N-up output wrapper for optex -Mup

# SYNOPSIS

nup \[ options \] command ...

    -h, --help             show help
        --version          show version
    -d, --debug            debug mode
    -n, --dryrun           dry-run mode

    -G, --grid=#           grid layout (e.g., 2x3)
    -C, --pane=#           number of columns
    -R, --row=#            number of rows
        --height=#         page height in lines
    -S, --pane-width=#     pane width (default: 85)
        --border-style=#   border style (default: heavy-box)
        --bs=#
        --line-style=#     line style (none/truncate/wrap/wordwrap)
        --ls=#
        --pager=#          pager command (empty to disable)

# VERSION

Version 0.01

# DESCRIPTION

**nup** is a simple wrapper script for `optex -Mup`.  It provides a
convenient way to run commands with N-up output formatting using the
[App::optex::up](https://metacpan.org/pod/App%3A%3Aoptex%3A%3Aup) module.

# OPTIONS

## General Options

- **-h**, **--help**

    Show help message.

- **--version**

    Show version.

- **-d**, **--debug**

    Enable debug mode.

- **-n**, **--dryrun**

    Dry-run mode. Show the command without executing.

## Layout Options

- **-G** _CxR_, **--grid**=_CxR_

    Set grid layout. For example, `-G2x3` creates 2 columns and 3 rows.

- **-C** _N_, **--pane**=_N_

    Set the number of columns (panes).

- **-R** _N_, **--row**=_N_

    Set the number of rows.

- **--height**=_N_

    Set the page height in lines.

- **-S** _N_, **--pane-width**=_N_

    Set the pane width in characters. Default is 85.

## Style Options

- **--border-style**=_STYLE_, **--bs**=_STYLE_

    Set the border style. Default is `heavy-box`.

- **--line-style**=_STYLE_, **--ls**=_STYLE_

    Set the line style. Available: `none`, `truncate`, `wrap`, `wordwrap`.

## Pager Options

- **--pager**=_COMMAND_

    Set the pager command. Default is `$PAGER` or `less`.
    Use `--pager=` (empty) to disable pager.

# EXAMPLES

    nup ls -l                  # basic usage
    nup -C2 ls -l              # 2 columns
    nup -G2x2 ls -l            # 2x2 grid (4-up)
    nup -S100 ls -l            # pane width 100
    nup --pager= ls -l         # without pager

# INSTALLATION

Using [cpanminus](https://metacpan.org/pod/App::cpanminus):

    cpanm -n App::nup

# SEE ALSO

[App::optex::up](https://metacpan.org/pod/App%3A%3Aoptex%3A%3Aup), [optex](https://metacpan.org/pod/optex)

# AUTHOR

Kazumasa Utashiro

# LICENSE

Copyright 2025 Kazumasa Utashiro.

This software is released under the MIT License.
[https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)
