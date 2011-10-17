package Areno::Manifest::Request;

use strict;

use base 'Areno::Node';

use XML::LibXML;

sub new {
    my ($class, $areno) = @_;
    
    my $this = {
        areno => $areno,
        node  => new XML::LibXML::Element('request'),
    };
    bless $this, $class;

    $this->init($areno);

    return $this;
}

sub init {
    my ($this, $env) = @_;
    
    my $request = $this->{areno}->request();
    $this->{node}->appendChild($this->argumentsNode($request));
    $this->{node}->appendChild($this->cookiesNode($request));
    $this->{node}->appendChild($this->useragentNode($request));
}

sub argumentsNode {
    my ($this, $request) = @_;

    my $argumentsNode = new XML::LibXML::Element('arguments');

    my @arguments = $request->arguments();
    for my $name (@arguments) {
        my $values = $request->margument($name);
        for my $value (@$values) {
            my $itemNode = new XML::LibXML::Element('item');
            $itemNode->setAttribute('name', $name);
            $itemNode->appendText($value);
            $argumentsNode->appendChild($itemNode);
        }
    }

    return $argumentsNode;
}

sub cookiesNode {
    my ($this, $request) = @_;
    
    my $cookiesNode = new XML::LibXML::Element('cookies');
    
    my @cookies = $request->cookies();    
    for my $name (@cookies) {
        my $itemNode = new XML::LibXML::Element('item');
        $itemNode->setAttribute('name', $name);
        $itemNode->appendText($request->cookie($name));
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
