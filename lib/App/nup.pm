package App::nup;

our $VERSION = "0.01";

1;
=encoding utf-8

=head1 NAME

nup - N-up output wrapper for optex -Mup

=head1 SYNOPSIS

nup [ options ] command ...

    -h, --help         show help
        --version      show version

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

B<nup> is a simple wrapper script for C<optex -Mup>.  It provides a
convenient way to run commands with N-up output formatting using the
L<App::optex::up> module.

=head1 INSTALLATION

Using L<cpanminus|https://metacpan.org/pod/App::cpanminus>:

    cpanm -n App::nup

=head1 SEE ALSO

L<App::optex::up>, L<optex>

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright 2025 Kazumasa Utashiro.

This software is released under the MIT License.
L<https://opensource.org/licenses/MIT>

=cut
