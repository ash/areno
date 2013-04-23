package Areno::Site;
use 5.010;
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
    my $this = shift; 
    my ($domain, $path) = @_;

    $this->import_dir("$path/$domain");
}

sub import_dir {
    my $this  = shift;
    my ($dir) = @_;

    opendir my($dir_fh), $dir or die "can't read dir $dir: $!";
    my @dir_content = readdir $dir_fh;
    closedir $dir_fh;

    my (@dir_paths, @file_paths);
    
    for my $name (@dir_content) {
        my $path = "$dir/$name";
        
        if (-d $path) {
            push @dir_paths, $path if $name =~ /\w/;
        }
        elsif (-f $path) {
            push @file_paths, $path if $name =~ /\.pm/;
        }
    }

    for my $path (@file_paths) {
        my $package;
                    
        my $require_result = eval{
            $package = require $path;
        };
        
        if($@) {
            say STDERR $@;
            say STDERR "fail in require $path => $package";
            next;
        }

        my $page = $package->new($this, $this->{areno});
        $this->{pages}{$page} = $page;
    }

    for my $path (@dir_paths) {
        $this->import_dir($path);
    }

}

sub dispatch {
    my ($this, $env) = @_;

    my $path_info = $env->{PATH_INFO} || '/';

    my $pages = $this->{pages};

    my $args  = $this->{areno}{doc}{request}{arguments};

    my @routes;
    for my $page (keys %$pages) {
        my ( $route, $query ) = $pages->{$page}->route();
        if ( $path_info ~~ $route ) {
            if ( $query ) {
                next if grep { not $query->{$_} ~~ $args->{$_}  } keys %$query;
            }
            push @routes, $page;
        }

    }

    warn("More than one possible route for $$this{domain}$path_info: " . join(',', @routes) . "\n") if @routes > 1;

    return $pages->{$routes[0]};
}

1;
