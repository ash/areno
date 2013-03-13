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
    my $stylesheet;
    for my $step (0 .. $#instructions) {
        my $style_source = XML::LibXML->load_xml(
                            location => $page->site()->path() . '/../layout/' .
                                        $page->site()->domain() . '/' .
                                        $instructions[$step] .
                                        '.xslt'
                        );
        $stylesheet = $xslt->parse_stylesheet($style_source);

        if ($page->can('export')) {
            my $export = $page->export();
    
            while (my ($name, $subref) = each %{$export->{functions}}) {
                $stylesheet->register_function($export->{uri}, $name, $subref);
            }
        }

        $dom = $stylesheet->transform($dom);
    }

    return $stylesheet->output_as_bytes($dom);
}

1;
