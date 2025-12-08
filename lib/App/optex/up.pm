package App::optex::up;

our $VERSION = "0.01";

=encoding utf-8

=head1 NAME

up - optex module for multi-column paged output

=head1 SYNOPSIS

    optex -Mup command ...

=head1 DESCRIPTION

B<up> is a module for the B<optex> command that pipes the output
through L<App::ansicolumn> for multi-column formatting and a pager.
The name comes from the printing term "n-up" (2-up, 3-up, etc.) which
refers to printing multiple pages on a single sheet.

The module automatically calculates the number of columns based on the
terminal width (C<$COLUMNS>) divided by the column width (default 85
characters).

The pager command is taken from the C<$PAGER> environment variable if
set, otherwise defaults to C<less +Gg>.

=head1 EXAMPLES

List files in multiple columns with pager:

    optex -Mup ls -l

=head1 INSTALL

=head2 CPANMINUS

    cpanm App::optex::up

=head1 SEE ALSO

L<App::optex>, L<https://github.com/kaz-utashiro/optex>

L<App::optex::up>, L<https://github.com/kaz-utashiro/optex-up>

L<App::ansicolumn>

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright 2025 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use v5.14;
use warnings;

my @PAGER_OPT = (
    [ qr/\bless\b/ => '+Gg' ],
);

$ENV{UP_PAGER} //= do {
    my $pager = $ENV{PAGER} // 'less';
    for (@PAGER_OPT) {
        my ($re, $opt) = @$_;
        if ($pager =~ $re) {
            $pager .= " $opt";
            last;
        }
    }
    $pager;
};

1;

__DATA__

define WIDTH  85
define COLS   WIDTH/:DUP:1:GE:EXCH:1:IF
define COLUMN ansicolumn --bs heavy-box --cm BORDER=L13 -DP -C COLS
define FILTER COLUMN|$ENV{UP_PAGER}

option default -Mutil::filter --of='FILTER'
