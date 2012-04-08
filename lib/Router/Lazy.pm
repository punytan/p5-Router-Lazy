package Router::Lazy;
use strict;
use warnings;
our $VERSION = '0.01';
use Carp ();

my %instances;

sub namespaces { values %instances }

sub instance {
    my ($class, $name) = @_;

    defined $name or Carp::croak "Invalid namespace";

    $instances{$name} ||= $class->_new(namespace => $name);
}

sub _new {
    my ($class, %args) = @_;

    $args{rules} ||= {
        GET    => [],
        POST   => [],
        PUT    => [],
        DELETE => [],
    };

    return bless \%args, $class;
}

sub get  { shift->_register('GET',    @_); }
sub post { shift->_register('POST',   @_); }
sub put  { shift->_register('PUT',    @_); }
sub del  { shift->_register('DELETE', @_); } # "delete" is reserved word :/

# We do not think __PACKAGE__->head() is required since
# HEAD method is just an alias of GET request without response body.

# We know PUT, DELETE, OPTIONS, TRACE and more methods but...
#   "Using PUT and DELETE as HTTP methods for the form element is no longer supported."
#       - http://www.w3.org/TR/html5-diff/#changes-2010-06-24
# We think this flammable issue should be ignored in the context of web application.

# NOTE : We have to consider the real world before we start writing REST API.
#   Twitter deprecated DELETE method endpoints
#       - https://dev.twitter.com/docs/api
#   Facebook supports DELETE *and* POST methods for convenience' sake
#       - https://developers.facebook.com/docs/reference/api/

sub _register {
    my ($self, $method, $path, $handler) = @_;
    my ($controller, $action) = split '#', $handler;

    my $path_re = $self->_make_regex($path);

    push @{$self->{rules}{$method}}, +{
        controller => sprintf("%s::%s", $self->{namespace}, $controller),
        action => $action,
        path   => $path_re,
    };
}

sub _make_regex {
    my ($class, $path) = @_;

    if ($path eq '/') {
        return qr{^$path$};

    } elsif (ref $path ne 'RegExp') {
        my @parts = split '/', $path;
        my $regex_path = join '/', map { /^\:/ ? '([^/]+)' : $_ } @parts;
        return qr{^$regex_path$};

    } else {
        Carp::croak "Unrecognizable path: $path";
    }

}

sub match {
    my ($self, $env, $method) = @_;
    $method ||= uc $env->{REQUEST_METHOD};

    if ($method eq 'HEAD') {
        $method = 'GET'; # HEAD method is just an alias of GET method (without body)
    }

    if (my $ret = $self->_matcher($env, $method)) {
        return $ret;
    }

    return;
}

sub _matcher {
    my ($self, $env, $method) = @_;
    my $path_info = $env->{PATH_INFO} || '/';

    for my $rule ( @{$self->{rules}{$method}} ) {
        if ($path_info =~ $rule->{path}) {
            return +{
                controller => $rule->{controller},
                action => $rule->{action},
                args   => [$1, $2, $3, $4, $5],
            };
        }
    }

    return;
}

1;
__END__

=head1 NAME

Router::Lazy -

=head1 SYNOPSIS

  use Router::Lazy;

=head1 DESCRIPTION

Router::Lazy is

=head1 AUTHOR

punytan E<lt>punytan@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
