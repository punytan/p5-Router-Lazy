use strict;
use warnings;
use Test::More;

use t::Util::Router;

is $Router::Lazy::NameSpace, "Foo::Web";

subtest "success" => sub {
    subtest "GET /" => sub {
        my $env = {
            REQUEST_METHOD => "GET",
            PATH_INFO => "/",
        };

        my $expected = {
            controller => "Foo::Web::Root",
            action => "index",
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "GET /search" => sub {
        my $env = {
            REQUEST_METHOD => "GET",
            PATH_INFO => "/search",
        };

        my $expected = {
            controller => "Foo::Web::Search",
            action => "search",
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "GET /statuses/show/:id" => sub {
        my $env = {
            REQUEST_METHOD => "GET",
            PATH_INFO => "/statuses/show/12345",
        };

        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "show",
            args   => [ "12345", (undef) x 4 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "GET /statuses/:id/retweeted_by" => sub {
        my $env = {
            REQUEST_METHOD => "GET",
            PATH_INFO => "/statuses/12345/retweeted_by",
        };

        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "retweeted_by",
            args   => [ "12345", (undef) x 4 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "POST /statuses/destroy/:id" => sub {
        my $env = {
            REQUEST_METHOD => "POST",
            PATH_INFO => "/statuses/destroy/12345",
        };

        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "destroy",
            args   => [ "12345", (undef) x 4 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "POST /statuses/retweet/:id" => sub {
        my $env = {
            REQUEST_METHOD => "POST",
            PATH_INFO => "/statuses/retweet/12345",
        };

        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "retweet",
            args   => [ "12345", (undef) x 4 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "POST /statuses/update" => sub {
        my $env = {
            REQUEST_METHOD => "POST",
            PATH_INFO => "/statuses/update",
        };

        my $expected = {
            controller => "Foo::Web::Statuses",
            action => "update",
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "PUT /account/update_location" => sub {
        my $env = {
            REQUEST_METHOD => "PUT",
            PATH_INFO => "/account/update_location",
        };

        my $expected = {
            controller => "Foo::Web::Account",
            action => "update_location",
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "DELETE /:user/:list_id/members" => sub {
        my $env = {
            REQUEST_METHOD => "DELETE",
            PATH_INFO => "/12345/67890/members",
        };

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
        my $env = {
            REQUEST_METHOD => "HEAD",
            PATH_INFO => "/search",
        };

        my $expected = {
            controller => "Foo::Web::Search",
            action => "search",,
            args   => [ (undef) x 5 ],
        };

        is_deeply(Router::Lazy->match($env), $expected);
    };

    subtest "HEAD /statuses/destroy/:id" => sub {
        my $env = {
            REQUEST_METHOD => "HEAD",
            PATH_INFO => "/statuses/destroy/12345",
        };
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "HEAD /account/update_location" => sub {
        my $env = {
            REQUEST_METHOD => "HEAD",
            PATH_INFO => "/account/update_location",
        };
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "HEAD /:user/:list_id/members" => sub {
        my $env = {
            REQUEST_METHOD => "HEAD",
            PATH_INFO => "/12345/67890/members",
        };
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

};

subtest "Method Not Allowed" => sub {
    subtest "POST /" => sub {
        my $env = {
            REQUEST_METHOD => "POST",
            PATH_INFO => "/",
        };
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "GET /statuses/show/:id" => sub {
        my $env = {
            REQUEST_METHOD => "GET",
            PATH_INFO => "/statuses/show:12345",
        };
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "GET /statuses/destroy/:id" => sub {
        my $env = {
            REQUEST_METHOD => "GET",
            PATH_INFO => "/statuses/destroy/12345",
        };
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

    subtest "GET /:user/:list_id/members" => sub {
        my $env = {
            REQUEST_METHOD => "GET",
            PATH_INFO => "/12345/67890/members",
        };
        my $ret = Router::Lazy->match($env);
        ok !$ret;
    };

};

done_testing;
