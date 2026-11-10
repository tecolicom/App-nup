package App::optex::up;

our $VERSION = "1.10";

=encoding utf-8

=head1 NAME

up - optex module for multi-column paged output

=head1 SYNOPSIS

    optex -Mup command ...

    optex -Mup -C2 -- command ...

    optex -Mup -C2.2 -- command ...

=head1 DESCRIPTION

B<up> is a module for the B<optex> command that pipes the output
through L<App::ansicolumn> for multi-column formatting and a pager.
The name comes from the printing term "n-up" (2-up, 3-up, etc.) which
refers to printing multiple pages on a single sheet.

The module automatically calculates the number of columns based on the
terminal width divided by the pane width (default 85 characters).
The terminal size is taken from the controlling terminal (C</dev/tty>);
when it is not available, the C<COLUMNS> environment variable gives the
width (default 80), and C<LINES> gives the height (default 24) used
when the number of rows is set, as in C<-C2.2>.

Both stdout and stderr are merged and passed through the filter, so
error messages are also displayed in the multi-column paged output.

The pager command is taken from the C<NUP_PAGER> environment variable
if set, otherwise defaults to C<less -F +Gg>.  When page mode is
active, the C<NUP_PAGE_PAGER> environment variable is consulted
first.
The environment variables are named after the L<nup> command, a
wrapper for this module.  The C<PAGER> variable is not used to avoid
an infinite loop when C<PAGER> is set to C<nup>.  Use the C<--pager>
option to specify a different pager on the command line.

The C<-F> option causes C<less> to exit immediately if the output
fits on one screen.  C<+Gg> causes C<less> to read all input before
displaying, which may take time for large output, but prevents empty
trailing pages from being shown.
The C<--file-size> option of C<less> 590 (June 2021) and later does
the same as C<+Gg>; it is not the default because older versions,
such as the C<less> 581 that comes with macOS, do not have it and
print an error message for it.  Set C<NUP_PAGER> to use it:

    export NUP_PAGER="less --file-size"

=head1 OPTIONS

Module options must be specified before C<--> separator.

=over 4

=item B<-C> I<C>[.I<R>], B<--pane>=I<C>[.I<R>]

Set the number of columns (panes) directly, and the number of rows
when it is given after a period.  For example, C<-C2> creates 2
columns, and C<-C2.3> creates a 2-column, 3-row layout (6-up).  The
page height is calculated by dividing the terminal height by the
number of rows.

=item B<-R> I<N>, B<--row>=I<N>

Set the number of rows.
This option is kept for compatibility and may be removed in the
future.

=item B<-G> I<CxR>, B<--grid>=I<CxR>

Set the grid layout.  C<--grid=2x3> or C<--grid=2,3> is equivalent to
C<-C2.3>.
This option is kept for compatibility and may be removed in the
future.

=item B<-S> I<N>, B<--pane-width>=I<N>

Set the pane width in characters.  Default is 85.  When B<--pane> is
not specified, the number of panes is calculated by dividing the
terminal width by this value.

=item B<--bs>=I<STYLE>, B<--border-style>=I<STYLE>

Set the border style for ansicolumn.  Default is C<heavy-box>.
See L<App::ansicolumn> for available styles.

=item B<--no-paginate>

Disable page mode.  Without pagination, the entire content is
split evenly across columns.  Page mode is the default.

Note that L<App::ansicolumn> uses parallel layout when multiple
files are given, which has no page structure.  Specify this option
in such cases so that C<NUP_PAGE_PAGER> is not used (the L<nup>
command does this automatically).

=item B<-A>, B<--auto-paginate>

Automatically disable page mode when only one column fits the
terminal.

=item B<--pager>=I<COMMAND>

Set the pager command, overriding the environment variables.
Default is C<NUP_PAGE_PAGER> (page mode only), C<NUP_PAGER>, or
C<less -F +Gg>.

=item B<--no-pager>

Disable pager.  Output goes directly to stdout.

=item B<--pdf>[=I<FILE>]

Print the output to a PDF file by C<ansi2pdf>.  Without I<FILE>, the
PDF is written to the standard output.  The size of a sheet of paper
in columns and lines, which C<ansi2pdf --geometry> tells, is used in
place of the terminal size, and C<ansi2pdf> is used in place of the
pager.  Each screen is printed on a landscape sheet as it is.

=item B<--pdf-opts>=I<OPTIONS>

Give options to C<ansi2pdf>, such as C<-p a3> for the paper size,
C<-P> for portrait and C<-l 80> for the number of lines on a sheet.

=item Other options

Any unrecognized options are passed through to L<App::ansicolumn>.
For example, C<--cm> option can be used to set colormap:

    optex -Mup --cm=BORDER=R -- command

See L<App::ansicolumn> for available options.

=back

=head1 EXAMPLES

Display perldoc output in multiple columns:

    optex -Mup perldoc App::optex::up

=begin html

<p><img width="750" src="https://raw.githubusercontent.com/tecolicom/App-nup/main/images/nup.png">

=end html

List files in multiple columns with pager:

    optex -Mup ls -l

Use 2 columns:

    optex -Mup -C2 -- ls -l

Set pane width to 100:

    optex -Mup -S100 -- ls -l

Use 2x2 grid (4-up):

    optex -Mup -C2.2 -- ls -l

No pagination:

    optex -Mup --no-paginate -- man perl

Use a different border style:

    optex -Mup --bs=round-box -- ls -l

Output without pager (useful for piping):

    optex -Mup --no-pager -C2 -- ls -l | head

Truncate long lines:

    optex -Mup --ls=truncate -- ps aux

=head1 INSTALL

=head2 Homebrew

Use L<tecolicom/tap|https://github.com/tecolicom/homebrew-tap>:

    brew tap tecolicom/tap
    brew install app-nup

=head2 CPANMINUS

    cpanm App::nup

=head1 SEE ALSO

L<App::nup>, L<https://github.com/tecolicom/App-nup>

L<App::optex>, L<https://github.com/kaz-utashiro/optex>

L<App::ansicolumn>

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright 2025 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use v5.16;
use warnings;

use List::Util qw(max);
use Getopt::EX::Config;
use Term::ReadKey;

sub term_size {
    my @size;
    if (open my $tty, ">", "/dev/tty") {
        @size = GetTerminalSize $tty, $tty;
    }
    @size;
}

sub shell_escape {
    $_[0] =~ s/([<>&|;'"\$`\\ ])/\\$1/gr;
}

my $config = Getopt::EX::Config->new(
    'grid'         => undef,
    'pane-width'   => 85,
    'pane'         => undef,
    'row'          => undef,
    'border-style' => 'heavy-box',
    'paginate'     => 1,
    'auto-paginate' => undef,
    'pager'        => undef,
    'no-pager'     => undef,
    'pdf'          => undef,
    'pdf-opts'     => '',
);

# Size of a sheet of paper in columns and lines, asked to ansi2pdf.
sub pdf_size {
    my $command = shift;
    my $geometry = qx($command --geometry) // '';
    $geometry =~ /^(\d+) (\d+)$/
        or die "Failed to get the page geometry from ansi2pdf.\n";
    ($1, $2);
}

sub finalize {
    my($mod, $argv) = @_;
    $config->configure('pass_through')->deal_with($argv,
        'grid|G=s', 'pane-width|S=i', 'pane|C=s', 'row|R=i',
        'border-style|bs=s', 'paginate!',
        'auto-paginate|autopaginate|A',
        'pager:s', 'no-pager|nopager',
        'pdf:s', 'pdf-opts=s');
    my @passthru = $config->argv;

    # -C C.R gives the number of rows as well
    if (defined(my $pane = $config->{pane})) {
        my($c, $r) = $pane =~ /^(\d+)(?:\.(\d+))?$/
            or die "Invalid pane format: $pane (expected C or C.R)\n";
        $config->{pane} = $c;
        $config->{row} //= $r;
    }

    if (my $grid = $config->{grid}) {
        my($c, $r) = $grid =~ /^(\d+)[x,](\d+)$/
            or die "Invalid grid format: $grid (expected CxR or C,R)\n";
        $config->{pane} //= $c;
        $config->{row}  //= $r;
    }

    # --pdf: a sheet of paper takes the place of the terminal, and
    # ansi2pdf takes the place of the pager.  Each screen is printed on
    # a landscape sheet as it is.
    my $pdf = $config->{pdf};
    my $ansi2pdf = defined $pdf
        ? join(' ', 'ansi2pdf -C1 --no-border -L', $config->{'pdf-opts'}) : undef;

    my($term_width, $term_height) = $ansi2pdf ? pdf_size($ansi2pdf) : term_size();
    $term_width  ||= $ENV{COLUMNS} || 80;
    $term_height ||= $ENV{LINES}   || 24;

    my $pane_width   = $config->{'pane-width'};
    my $cols         = $config->{pane} // max(1, int($term_width / $pane_width));
    my $rows         = $config->{row};
    my $height       = defined $rows ? int(($term_height - 1) / $rows) : undef;
    if ($ansi2pdf) {
        # no line is needed for the pager, and the pages must fill the sheet
        $height = int($term_height / ($rows || 1));
        my $lines = $height * ($rows || 1);
        $config->{pager} = "$ansi2pdf -w $term_width -l $lines"
            . ($pdf ne '' ? ' -o ' . shell_escape($pdf) : '');
        $config->{'no-pager'} = undef;
    }
    my $border_style = $config->{'border-style'};
    my $no_page      = !$config->{paginate}
        || ($config->{'auto-paginate'} && $cols <= 1);
    # +Gg makes less read all input first, so that -F and the percentage
    # work.  less 590 and later have --file-size for this, but the less
    # 581 of macOS does not, so keep +Gg as the default.
    my $pager        = $config->{pager} //
        ((!$no_page && $ENV{NUP_PAGE_PAGER}) || $ENV{NUP_PAGER} || 'less -F +Gg');

    # Build default ansicolumn options
    my @ac_opts = ("-w$term_width", "--bs=$border_style", "--cm=BORDER=L13", "-DBP", "-C$cols");
    push @ac_opts, "--height=$height" if defined $height;
    push @ac_opts, "--no-page"        if $no_page;
    push @ac_opts, @passthru;

    # If command is ansicolumn, apply default options and pager
    if (@$argv && $argv->[0] eq 'ansicolumn') {
        # Insert defaults after 'ansicolumn', so user options take precedence
        splice @$argv, 1, 0, @ac_opts;
        if ($config->{'no-pager'} || $pager eq '') {
            return;  # No filter needed
        }
        $mod->setopt(default => "-Mutil::filter --of='$pager' --ef='>&1'");
        return;
    }

    my $column = join ' ', 'ansicolumn', map { shell_escape($_) } @ac_opts;
    my $filter = ($config->{'no-pager'} || $pager eq '') ? $column : "$column|$pager";
    $mod->setopt(default => "-Mutil::filter --of='$filter' --ef='>&1'");
}

1;
