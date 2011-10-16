package Areno::Transform;

use strict;

use XML::LibXSLT;

sub new {
    my ($class) = @_;
    
    my $this = {
        transform => {},
    };
    bless $this, $class;
    
    return $this;
}

sub set_transform {
    my ($this, $package, $site, $transform) = @_;

    $this->{transform}{$site}{$package} = "layout/$site/$transform.xslt";
}

sub transform {
    my ($this, $doc, $page) = @_;

    my $style_source = XML::LibXML->load_xml(location => $this->{transform}{$page->site()}{$page->classname()});

    my $xslt = new XML::LibXSLT();
    my $stylesheet = $xslt->parse_stylesheet($style_source);
    my $result = $stylesheet->transform($doc->{dom});

    return $stylesheet->output_as_bytes($result);
}

1;
