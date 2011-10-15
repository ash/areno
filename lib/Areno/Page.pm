package Areno::Page;

use strict;

use base 'Exporter';
our @EXPORT = qw(route new);

sub import {
    my ($this, $args) = @_;

    SUPER->import(@_);
}

sub route {
    qr{};
}

sub transform {
    'default'
}

sub run {
    
}

1;
