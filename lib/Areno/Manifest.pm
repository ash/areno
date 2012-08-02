package Areno::Manifest;

use strict;

use base 'Areno::Node';

use XML::LibXML;
use Areno::Manifest::Request;

sub new {
    my ($class, $areno, $env) = @_;
    
    my $this = {
        areno => $areno,
        node  => new XML::LibXML::Element('manifest'),
    };
    bless $this, $class;

    $this->init();

    return $this;
}

sub init {
    my ($this) = @_;
    
    $this->{node}->appendChild($this->dateNode());
    $this->{node}->appendChild((new Areno::Manifest::Request($this->{areno}))->node());
}

sub dateNode {
    my ($this) = @_;

    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);

    my $dateNode = new XML::LibXML::Element('date');

    $dateNode->setAttribute('rfc', POSIX::strftime("%a, %d %b %Y %H:%M:%S %z",
                                   $sec, $min, $hour, $mday,
                                   $mon, $year, $wday, $yday, $isdst));
    $dateNode->setAttribute('yyyymmdd', sprintf("%i-%02i-%02i", $year + 1900, $mon + 1, $mday));
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
