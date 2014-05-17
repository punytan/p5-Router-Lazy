package Router::Lazy::DSL;
use strict;
use warnings;
use Carp ();
use parent qw( Exporter Router::Lazy );
our @EXPORT = qw( routes GET POST PUT DELETE );

our $_get = our $_post = our $_put = our $_delete = sub {
    Carp::croak "Defining route methods should be called inside `routes` block";
};

sub import {
    my $class = shift;
    $class->export_to_level(1, @_);
}

sub GET ($$)    { $_get->(@_)    } ## no critic
sub POST ($$)   { $_post->(@_)   } ## no critic
sub PUT ($$)    { $_put->(@_)    } ## no critic
sub DELETE ($$) { $_delete->(@_) } ## no critic

sub routes($;&) { ## no critic
    my ($namespace, $block) = @_;

    unless ($block) {
        return __PACKAGE__->instance($namespace);
    }

    my $self = __PACKAGE__->instance($namespace);

    local $_get    = sub { $self->_register(GET    => @_) };
    local $_post   = sub { $self->_register(POST   => @_) };
    local $_put    = sub { $self->_register(PUT    => @_) };
    local $_delete = sub { $self->_register(DELETE => @_) };

    $block->();

    return $self;
}

1;
__END__
