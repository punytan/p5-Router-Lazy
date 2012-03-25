package t::Util::Router;
use strict;
use warnings;
use Router::Lazy;

namespace "Foo::Web";

get  "/" => "Root#index";
get  "/search" => "Search#search";
get  "/statuses/show/:id" => "Statuses#show";
get  "/statuses/:id/retweeted_by" => "Statuses#retweeted_by";

post "/statuses/destroy/:id" => "Statuses#destroy";
post "/statuses/retweet/:id" => "Statuses#retweet";
post "/statuses/update" => "Statuses#update";

put  "/account/update_location" => "Account#update_location";

del  "/:user/:list_id/members" => "User::List#delete_members";

1;

