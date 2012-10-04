package Areno::Site;

use strict;

sub new {
    my ($class, $areno, $domain, $path) = @_;
    
    my $this = {
        areno  => $areno,
        domain => $domain,
        path   => $path,
        pages  => {},
    };
    bless $this, $class;

    $this->import_site_structure($domain, $path);
    
    return $this;
}

sub domain {
    my ($this) = @_;
    
    return $this->{domain};
}

sub path {
    my ($this) = @_;
    
    return $this->{path};
}

sub import_site_structure {
    my ($this, $domain, $path) = @_;

    $path = "$path/$domain";

    opendir my($dir), $path;
    my @dir = readdir $dir;
    closedir $dir;

    for my $item (@dir) {
        my $item_path = "$path/$item";
        if ($item_path =~ /\.pm$/ && -f $item_path) {
            my $package = require $item_path;
            my $page = $package->new($this, $this->{areno});
            $this->{pages}{$page} = $page;
        }
        elsif (-d $item_path && $item =~ /\w/) {
            $this->import_dir("$path/$item");
        }
    }
}

sub dispatch {
    my ($this, $env) = @_;

    my $path_info = $env->{PATH_INFO} || '/';

    my $pages = $this->{pages};

    my @route = grep {$path_info ~~ $pages->{$_}->route()} keys %$pages;

    warn("More than one possible route for $$this{domain}$path_info: " . join(',', @route) . "\n") if @route > 1;

    return $pages->{$route[0]};
}

1;
