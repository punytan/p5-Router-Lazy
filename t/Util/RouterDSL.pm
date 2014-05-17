package t::Util::RouterDSL;
use strict;
use warnings;
use Router::Lazy::DSL;

routes "FooDSL::Web" => sub {
    GET "/"       => "Root#index";
    GET "/search" => "Search#search";
    GET "/statuses/show/:id"         => "Statuses#show";
    GET "/statuses/:id/retweeted_by" => "Statuses#retweeted_by";

    POST "/statuses/destroy/:id" => "Statuses#destroy";
    POST "/statuses/retweet/:id" => "Statuses#retweet";
    POST "/statuses/update"      => "Statuses#update";

    PUT "/account/update_location" => "Account#update_location";

    DELETE "/:user/:list_id/members" => "User::List#delete_members";
};

1;
__END__
