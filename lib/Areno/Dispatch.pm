package Areno::Dispatch;

use strict;

sub new {
    my ($class) = @_;
    
    my $this = {
        route => {},
    };
    bless $this, $class;
    
    return $this;
}

sub dispatch {
    my ($this, $env) = @_;
    
    my $server_name = $env->{SERVER_NAME} || 'default';
    $server_name =~ s/^localhost$/default/;
    my $path_info = $env->{PATH_INFO} || '/';

    my $current = $this->{route}{$server_name};    
    my @route = grep {$path_info ~~ $current->{$_}} keys %$current;

    warn("More than one possible route for $server_name$path_info: " . join(',', @route) . "\n") if @route > 1;

    my $page_class = $route[0];
    my $page = $page_class->new(
                    site => $server_name,
                    path => $path_info,
               );
    
    return $page;
}

sub set_route {
    my ($this, $package, $site, $route) = @_;
    
    $this->{route}{$site}{$package} = $route;
}

1;
