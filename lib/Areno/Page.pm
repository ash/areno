package Areno::Page;

use strict;

use base 'Exporter';
our @EXPORT = qw(route new);

sub import {
    my ($this, $args) = @_;

    SUPER->import(@_);
}

sub new {
    my ($class, $site) = @_;
    
    my $this = {
        site  => $site,
    };
    bless $this, $class;
    
    return $this;
}

sub route {
    qr{};
}

sub transform {
    'default'
}

sub run {
    
}

sub site {
    my ($this) = @_;
    
    return $this->{site};
}

1;
