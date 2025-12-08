requires 'perl', '5.014';
requires 'App::optex', '1.00';
requires 'Getopt::EX', '2.1.6';
requires 'Getopt::EX::Config', '1.00';
requires 'App::ansicolumn';
requires 'Term::ReadKey';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
