[![Actions Status](https://github.com/tecolicom/App-nup/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/tecolicom/App-nup/actions?workflow=test) [![MetaCPAN Release](https://badge.fury.io/pl/App-nup.svg)](https://metacpan.org/release/App-nup)
# NAME

nup - N-up output wrapper for optex -Mup

# SYNOPSIS

nup \[ options \] command ...

    -h, --help         show help
        --version      show version
    -d, --debug        debug mode
    -n, --dryrun       dry-run mode

# VERSION

Version 0.01

# DESCRIPTION

**nup** is a simple wrapper script for `optex -Mup`.  It provides a
convenient way to run commands with N-up output formatting using the
[App::optex::up](https://metacpan.org/pod/App%3A%3Aoptex%3A%3Aup) module.

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
