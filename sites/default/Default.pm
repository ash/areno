package Areno::Default;

use strict;
use base 'Areno::Page';

sub route {
    '/'
}

sub run {
    my ($this) = @_;
    
    $this->test();
}

sub test {
    my ($this) = @_;

    my $testNode = $this->contentTextChild('test', int rand 100);
}

__PACKAGE__;
