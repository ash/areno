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
        site => $site,
    };
    bless $this, $class;

    return $this;
}

sub route {
    qr{};
}

sub transform {
    'localhost'
}

sub init {
    my ($this, $doc) = @_;

    $this->{doc} = $doc;
}

sub run {

}

sub site {
    my ($this) = @_;
    
    return $this->{site};
}

sub contnet {
    my ($this) = @_;

    return $this->{doc}{content};
}

sub contentChild {
    my ($this, $name, $attributes, $text) = @_;

    my $newNode = new XML::LibXML::Element($name);
    $this->{doc}{content}->appendChild($newNode);

    _setNodeValues($newNode, $attributes, $text);

    return $newNode;
}

sub contentTextChild {
    my ($this, $name, $text) = @_;

    my $newNode = $this->contentChild($name);
    $newNode->appendText($text);

    return $newNode;
}

sub manfest {
    my ($this) = @_;

    return $this->{doc}{manifest};
}

sub manifestChild {
    my ($this, $name, $attributes, $text) = @_;

    my $newNode = new XML::LibXML::Element($name);
    $this->{doc}{manifest}->appendChild($newNode);

    _setNodeValues($newNode, $attributes, $text);

    return $newNode;
}

sub manifestTextChild {
    my ($this, $name, $text) = @_;

    my $newNode = $this->manifestChild($name);
    $newNode->appendText($text);

    return $newNode;
}

sub newChild {
    my ($this, $node, $name, $attributes, $text) = @_;
    
    my $newNode = new XML::LibXML::Element($name);
    $node->appendChild($newNode);
    
    _setNodeValues($newNode, $attributes, $text);

    return $newNode;
}

sub newTextChild {
    my ($this, $node, $name, $text) = @_;
    
    my $newNode = new XML::LibXML::Element($name);
    $node->appendChild($newNode);
    $newNode->appendText($text);
    
    return $newNode;
}

sub newItem {
    my ($this, $node, $attributes, $text) = @_;
    
    $this->newChild($node, 'item', $attributes, $text);
}

sub param {
    my ($this, $name) = @_;
    
    my $list = $this->{doc}{request}{arguments}{$name} || [];

    return @$list ? $$list[0] : undef;   
}

sub cookie {
    my ($this, $name) = @_;
    
    return $this->{doc}{request}{cookies}{$name};
}

sub _setNodeValues {
    my ($node, $attributes, $text) = @_;
    
    if (defined $attributes) {
        for my $attribute (keys %$attributes) {
            $node->setAttribute($attribute, $attributes->{$attribute});
        }
    }

    if (defined $text) {
        $node->appendText($text);
    }
}

1;
