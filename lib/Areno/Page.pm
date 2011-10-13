package Areno::Page;

use strict;

use base 'Exporter';
our @EXPORT = qw(route new);

my $Route;

sub import {

    return ::SUPER->import;
}

sub route {
    my ($route) = @_;

    $Route = $route;
}

1;
