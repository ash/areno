package Areno::Content;

use strict;

use base 'Areno::Node';

use XML::LibXML;

sub new {
    my ($class, $areno, $env) = @_;
    
    my $this = {
        areno => $areno,
        node  => new XML::LibXML::Element('content'),
    };
    bless $this, $class;

    return $this;
}

1;
