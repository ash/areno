package Areno::Default;

use strict;
use base 'Areno::Page';

sub route {
    '/'
}

sub run {
    my ($this, $doc) = @_;

    warn $doc->{dom}->toString();
    warn "RUN\n";
}

__PACKAGE__;
