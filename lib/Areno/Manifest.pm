package Areno::Manifest;

use strict;

use XML::LibXML;
use Areno::Manifest::Request;

sub new {
    my ($class, $env) = @_;
    
    my $this = {
        node => new XML::LibXML::Element('manifest'),
    };
    bless $this, $class;

    $this->init($env);

    return $this;
}

sub init {
    my ($this, $env) = @_;
    
    $this->{node}->appendChild($this->dateNode());
    $this->{node}->appendChild((new Areno::Manifest::Request($env))->node());
}

sub node {
    my ($this) = @_;
    
    return $this->{node};
}

sub dateNode {
    my ($this) = @_;

    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);

    my $dateNode = new XML::LibXML::Element('date');

    $dateNode->setAttribute('rfc', POSIX::strftime("%a, %d %b %Y %H:%M:%S %z",
                                   $sec, $min, $hour, $mday,
                                   $mon, $year, $wday, $yday, $isdst));
    $dateNode->setAttribute($$_[0], $$_[1]) for (
            [year  => 1900 + $year],
            [day   => $mday],
            [month => $mon + 1],
            [hour  => $hour],
            [min   => $min],
            [sec   => $sec],
            [wday  => $wday]
    );
    
    return $dateNode;
}

1;
