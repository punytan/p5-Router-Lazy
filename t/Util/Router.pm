package t::Util::Router;
use strict;
use warnings;
use Router::Lazy;

my $r = Router::Lazy->instance("Foo::Web");

$r->get("/" => "Root#index");
$r->get("/search" => "Search#search");
$r->get("/statuses/show/:id" => "Statuses#show");
$r->get("/statuses/:id/retweeted_by" => "Statuses#retweeted_by");

$r->post("/statuses/destroy/:id" => "Statuses#destroy");
$r->post("/statuses/retweet/:id" => "Statuses#retweet");
$r->post("/statuses/update" => "Statuses#update");

$r->put("/account/update_location" => "Account#update_location");

$r->del("/:user/:list_id/members" => "User::List#delete_members");

1;

