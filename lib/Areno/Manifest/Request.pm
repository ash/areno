package Areno::Manifest::Request;

use strict;

sub new {
    my ($class, $env) = @_;
    
    my $this = {
        node => new XML::LibXML::Element('request'),
    };
    bless $this, $class;

    $this->init($env);

    return $this;
}

sub init {
    my ($this, $env) = @_;
    
    my $request = new Plack::Request($env);

    $this->{node}->appendChild($this->argumentsNode($request));
    $this->{node}->appendChild($this->cookiesNode($request));
    $this->{node}->appendChild($this->useragentNode($request));
}

sub node {
    my ($this) = @_;
    
    return $this->{node};
}

sub argumentsNode {
    my ($this, $request) = @_;
    
    my $argumentsNode = new XML::LibXML::Element('arguments');

    my $pairs = $request->parameters();
    for my $key (keys %$pairs) {
        for my $value ($pairs->get_all($key)) {
            my $itemNode = new XML::LibXML::Element('item');
            $itemNode->setAttribute('name', $key);
            $itemNode->appendText($value);
            $argumentsNode->appendChild($itemNode);
        }
    }
    
    return $argumentsNode;
}

sub cookiesNode {
    my ($this, $request) = @_;
    
    my $cookiesNode = new XML::LibXML::Element('cookies');
    
    my $pairs = $request->cookies();
    for my $key (keys %$pairs) {
        my $itemNode = new XML::LibXML::Element('item');
        $itemNode->setAttribute('name', $key);
        $itemNode->appendText($pairs->{$key});
        $cookiesNode->appendChild($itemNode);
    }
    
    return $cookiesNode;
}

sub useragentNode {
    my ($this, $request) = @_;
    
    my $useragentNode = new XML::LibXML::Element('user-agent');    
    $useragentNode->appendText($request->user_agent());
    
    return $useragentNode;
}

1;
