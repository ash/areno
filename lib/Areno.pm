package Areno;

use strict;

use Cwd;
use Plack::Request;

use Areno::Manifest;
use Areno::Dispatch;

sub new {
    my ($class) = @_;
    
    my $this = {
        http => {
            status => 200,
            headers => [
                'Content-Type' => 'text/html',
            ],
            body => ['I am Areno.'],
        },
        dispatch => new Areno::Dispatch(),
    };
    bless $this, $class;
    
    $this->init();
    
    return $this;
}

sub init {
    my ($this) = @_;
    
    $this->read_sites();
}

sub read_sites {
    my ($this) = @_;

    my $base_path = getcwd() || '.';
    my $sites_path = "$base_path/sites";

    opendir my($sites), $sites_path;
    die "No 'sites' directory found at $base_path" unless $sites;
    my @sites = grep /\w/, grep {-d "$sites_path/$_"} readdir $sites;
    close $sites;
    die "No sites found in $sites_path" unless @sites;
    
    for my $site (@sites) {
        $this->import_dir($site, "$sites_path/$site");
    }
}

sub import_dir {
    my ($this, $site, $path) = @_;

    opendir my($dir), $path;
    my @dir = readdir $dir;
    closedir $dir;

    for my $item (@dir) {
        my $item_path = "$path/$item";
        if ($item_path =~ /\.pm$/ && -f $item_path) {
            my $package = require $item_path;
            $package->import();
            $this->{dispatch}->set_route($package, $site, $package->route());
        }
        elsif (-d $item_path && $item =~ /\w/) {
            $this->import_dir("$path/$item");
        }
    }
}

sub status {
    my ($this) = @_;
    
    return $this->{http}{status};
}

sub headers {
    my ($this) = @_;
    
    return $this->{http}{headers};
}

sub body {
    my ($this) = @_;
    
    return $this->{http}{body};
}

sub run {
    my ($this, $env) = @_;

    $this->{doc} = $this->new_doc($env);
    
    my $page = $this->{dispatch}->dispatch($env);
    $page->run($this->{doc});
}

sub new_doc {
    my ($this, $env) = @_;
    
    my $dom = (new XML::LibXML)->createDocument('1.0', 'UTF-8');
    my $root = $dom->createElement('page');
    $dom->setDocumentElement($root);

    my $manifest = new Areno::Manifest($env);
    $root->appendChild($manifest->node());

    my $content = $this->new_content($dom, $env);

    return {
        dom      => $dom,
        root     => $root,
        manifest => $manifest,
        content  => $content,
    };
}

sub new_content {
    my ($this, $dom, $env) = @_;
    
    my $content = $dom->createElement('content');
    $dom->documentElement()->appendChild($content);
    
    return $content;
}

1;
