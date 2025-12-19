requires 'perl', '5.014';
requires 'App::optex';
requires 'App::optex::up';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
