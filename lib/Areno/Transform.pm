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

    my $instructions = $page->transform();
    my @instructions = 
        ! (ref $instructions eq "ARRAY")
        ? ($instructions)
        : @$instructions
        ;

    my $dom = $doc->{dom};

    my $xslt = new XML::LibXSLT();
    my $ret;
    for my $step (0 .. $#instructions) {
        my $style_source = XML::LibXML->load_xml(
                            location => $page->site()->path() . '/../layout/' .
                                        $page->site()->domain() . '/' .
                                        $instructions[$step] .
                                        '.xslt'
                        );

        my $stylesheet = $xslt->parse_stylesheet($style_source);
        $dom = $stylesheet->transform($dom);

        $ret = $stylesheet->output_as_bytes($dom) if $step == $#instructions;
    }

    return $ret;
}

1;
