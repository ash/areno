package Areno::Transform;

use strict;

use XML::LibXSLT;

sub new {
    my ($class) = @_;
    
    my $this = {
    };
    bless $this, $class;
    
    return $this;
}

sub transform {
    my ($this, $doc, $page) = @_;

    my $style_source = XML::LibXML->load_xml(
                        location => $page->site()->path() . '/../layout/' .
                                    $page->site()->domain() . '/' .
                                    $page->transform() .
                                    '.xslt'
                    );

    my $xslt = new XML::LibXSLT();
    my $stylesheet = $xslt->parse_stylesheet($style_source);
    my $result = $stylesheet->transform($doc->{dom});

    return $stylesheet->output_as_bytes($result);
}

1;
