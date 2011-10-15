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
    my $request_uri = $env->{REQUEST_URI} || '/';

    my $current = $this->{route}{$server_name};    
    my @route = grep {$request_uri ~~ $current->{$_}} keys %$current;

    warn("More than one possible route for $server_name$request_uri: " . join(',', @route) . "\n") if @route > 1;

    return $route[0];
}

sub set_route {
    my ($this, $package, $site, $route) = @_;
    
    $this->{route}{$site}{$package} = $route;
}

1;
