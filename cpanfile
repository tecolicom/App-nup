requires 'perl', '5.014';
requires 'File::Share';
requires 'App::optex';
requires 'App::optex::up';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
