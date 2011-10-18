package Areno::Default;

use strict;
use base 'Areno::Page';

sub route {
    '/'
}

sub run {
    my ($this, $doc) = @_;
    
    $this->test($doc);
}

sub test {
    my ($this, $doc) = @_;

    my $testNode = new XML::LibXML::Element('test');
    $testNode->appendText(int rand(100));
    $doc->{content}->appendChild($testNode);
}

__PACKAGE__;
