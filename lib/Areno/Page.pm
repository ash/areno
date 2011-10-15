package Areno::Page;

use strict;

use base 'Exporter';
our @EXPORT = qw(route new);

sub import {
    my ($this) = @_;

    SUPER->import(@_);
}

sub route {
    return qr{};
}

sub run {
    
}

1;
