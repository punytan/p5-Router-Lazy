use strict;
use warnings;
use Test::More;
use Router::Lazy;

subtest "public methods" => sub {
    can_ok "Router::Lazy", qw(
        namespaces
        instance
        get
        post
        put
        delete
        match
    );
};

subtest "private methods" => sub {
    can_ok "Router::Lazy", qw(
        _new
        _register
        _make_regex
        _matcher
    );
};

done_testing;


