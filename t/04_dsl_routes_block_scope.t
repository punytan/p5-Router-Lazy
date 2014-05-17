use strict;
use warnings;
use Test::More;
use Router::Lazy::DSL;

my $expected = qr/^Defining route methods should be called inside `routes` block/;
subtest "call outsside of routes block" => sub {
    subtest 'GET' => sub {
        local $@;
        eval { GET "/" => "Root#index" };
        like $@, $expected,
    };

    subtest 'POST' => sub {
        local $@;
        eval { POST "/" => "Root#index" };
        like $@, $expected,
    };

    subtest 'PUT' => sub {
        local $@;
        eval { PUT "/" => "Root#index" };
        like $@, $expected,
    };

    subtest 'DELETE' => sub {
        local $@;
        eval { DELETE "/" => "Root#index" };
        like $@, $expected,
    };
};

done_testing;

