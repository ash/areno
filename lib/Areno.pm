package Areno;

use strict;

use Cwd;
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
        $this->import_site($site, $sites_path);
    }
}

sub import_site {
    my ($this, $site, $sites_path) = $_;
    
    my $path = "$sites_path/$site";
    opendir my($dir), $path;
    my @dir = readdir $dir;
    closedir $dir;

    for my $item (@dir) {
        my $item_path = "$path/$item";
        if ($item_path =~ -f $item_path) {
            
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

    #my $page = $this->{dispatch}->dispatch($env);
    #$page->run();
}

1;
