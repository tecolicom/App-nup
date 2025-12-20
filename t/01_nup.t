use strict;
use warnings;
use Test::More;
use File::Spec;

# Set PERL5LIB so child processes can find File::Share's dist_dir
BEGIN {
    my $blib = File::Spec->rel2abs('blib/lib');
    if (-d $blib) {
        $ENV{PERL5LIB} = join(':', $blib, $ENV{PERL5LIB} // '');
    }
}

# Skip tests on platforms without bash or with old bash
BEGIN {
    my $bash_check = `bash --version 2>&1`;
    if ($? != 0) {
        plan skip_all => 'bash is not available on this system';
    }
    if ($bash_check =~ /version (\d+)\.(\d+)/) {
        my ($major, $minor) = ($1, $2);
        if ($major < 4 || ($major == 4 && $minor < 3)) {
            plan skip_all => "bash 4.3+ required (found $major.$minor)";
        }
    }
}

my $script = File::Spec->rel2abs('script/nup');

sub nup {
    my @args = @_;
    my $cmd = "$script -n @args 2>&1";
    chomp(my $out = `$cmd`);
    $out;
}

subtest 'basic command' => sub {
    my $out = nup('date');
    like $out, qr/^optex -Mup -- date$/, 'basic command with --';
};

subtest 'grid option' => sub {
    my $out = nup('-G 2x3 date');
    like $out, qr/--grid=2x3/, 'grid option';
    like $out, qr/-- date$/, 'command after --';
};

subtest 'pane option' => sub {
    my $out = nup('-C 2 date');
    like $out, qr/--pane=2/, 'pane option';
};

subtest 'row option' => sub {
    my $out = nup('-R 3 date');
    like $out, qr/--row=3/, 'row option';
};

subtest 'pane-width option' => sub {
    my $out = nup('-S 100 date');
    like $out, qr/--pane-width=100/, 'pane-width option';
};

subtest 'border-style option' => sub {
    my $out = nup('--bs=round-box date');
    like $out, qr/--border-style=round-box/, 'border-style option';
};

subtest 'line-style option' => sub {
    my $out = nup('--ls=truncate date');
    like $out, qr/--line-style=truncate/, 'line-style option';
};

subtest 'pager option' => sub {
    my $out = nup('--pager=less date');
    like $out, qr/--pager=less/, 'pager with value';

    $out = nup('--pager= date');
    like $out, qr/--pager= --/, 'pager empty (disable)';

    $out = nup('--no-pager date');
    like $out, qr/--pager= --/, '--no-pager';
};

subtest 'no pager option' => sub {
    my $out = nup('date');
    unlike $out, qr/--pager/, 'no pager option by default';
};

subtest 'combined options' => sub {
    my $out = nup('-G 2x2 -S 80 --bs=heavy-box date');
    like $out, qr/--grid=2x2/, 'grid';
    like $out, qr/--pane-width=80/, 'pane-width';
    like $out, qr/--border-style=heavy-box/, 'border-style';
    like $out, qr/-- date$/, 'command at end';
};

done_testing;
