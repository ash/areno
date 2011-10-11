package Areno::Dispatch;

use strict;

sub new {
    my ($class) = @_;
    
    my $this = {    
    };
    bless $this, $class;
    
    return $this;
}

sub dispatch {
    my ($this, $env) = @_;
    
    my $server_name = $env->{SERVER_NAME} || 'default';
    my $request_uri = $env->{REQUEST_URI} || '/';
    
    
}

1;
