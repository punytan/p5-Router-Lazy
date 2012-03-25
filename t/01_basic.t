use strict;
use warnings;
use Test::More;
use Router::Lazy;

subtest "public methods" => sub {
    can_ok "Router::Lazy", qw( namespace get post put del match );
};

subtest "private methods" => sub {
    can_ok "Router::Lazy", qw( _register _make_regex _matcher );
};

done_testing;


