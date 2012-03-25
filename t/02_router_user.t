use strict;
use warnings;
use Test::More;

use t::Util::Router;

is $Router::Lazy::NameSpace, "Foo::Web";

sub get_env {
    my ($method, $path) = @_;
    return +{
        REQUEST_METHOD => $method,
        PATH_INFO => $path,
    };
}

subtest "success" => sub {
    subtest "GET /" => sub {
        my $env = get_env( GET => "/" );
        my $expected = {
            controller => "Foo::Web::Root",
            action => "index",
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "GET /search" => sub {
        my $env = get_env( GET => "/search" );
        my $expected = {
            controller => "Foo::Web::Search",
            action => "search",
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "GET /statuses/show/:id" => sub {
        my $env = get_env( GET => "/statuses/show/12345" );
        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "show",
            args   => [ "12345", (undef) x 4 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "GET /statuses/:id/retweeted_by" => sub {
        my $env = get_env( GET => "/statuses/12345/retweeted_by" );
        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "retweeted_by",
            args   => [ "12345", (undef) x 4 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "POST /statuses/destroy/:id" => sub {
        my $env = get_env( POST => "/statuses/destroy/12345" );

        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "destroy",
            args   => [ "12345", (undef) x 4 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "POST /statuses/retweet/:id" => sub {
        my $env = get_env( POST => "/statuses/retweet/12345" );
        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "retweet",
            args   => [ "12345", (undef) x 4 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "POST /statuses/update" => sub {
        my $env = get_env( POST => "/statuses/update" );
        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "update",
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "PUT /account/update_location" => sub {
        my $env = get_env( PUT => "/account/update_location" );
        my $expected = {
            controller => "Foo::Web::Account",
            action => "update_location",
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "DELETE /:user/:list_id/members" => sub {
        my $env = get_env( DELETE => "/12345/67890/members" );
        my $expected = {
            controller => "Foo::Web::User::List",
            action => "delete_members",
            args   => [ "12345", "67890", (undef) x 3 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };
};

subtest "HEAD" => sub {
    subtest "HEAD /search" => sub {
        my $env = get_env( HEAD => "/search" );
        my $expected = {
            controller => "Foo::Web::Search",
            action => "search",,
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "HEAD /statuses/destroy/:id" => sub {
        my $env = get_env( HEAD => "/statuses/destroy/12345" );
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "HEAD /account/update_location" => sub {
        my $env = get_env( HEAD => "/account/update_location" );
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "HEAD /:user/:list_id/members" => sub {
        my $env = get_env( HEAD => "/12345/67890/members" );
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

};

subtest "Method Not Allowed" => sub {
    subtest "POST /" => sub {
        my $env = get_env(POST => "/");
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "GET /statuses/show/:id" => sub {
        my $env = get_env( GET => "/statuses/show:12345" );
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "GET /statuses/destroy/:id" => sub {
        my $env = get_env( GET => "/statuses/destroy/12345" );
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "GET /:user/:list_id/members" => sub {
        my $env = get_env( GET => "/12345/67890/members" );
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

};

done_testing;
