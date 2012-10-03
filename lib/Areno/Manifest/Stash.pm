package Areno::Manifest::Stash;

use strict;

use base 'Areno::Node';

use XML::LibXML;

sub new {
    my ($class, $areno) = @_;
    
    my $this = {
        areno => $areno,
        node  => new XML::LibXML::Element('stash'),
    };
    bless $this, $class;

    $this->init();

    return $this;
}

sub init {
    my ($this, $env) = @_;
    
    my $stash = $this->{areno}->stash();
    
    for my $name (keys %{$stash}) {
        my $node_name = $name =~ s{_}{-}gr;
        my $node = new XML::LibXML::Element($node_name);
        my $value = $stash->{$name};
        $node->appendText($value);

        $this->{node}->appendChild($node);
    }
}


1;
