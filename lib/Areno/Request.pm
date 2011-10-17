package Areno::Request;

use strict;

use Plack::Request;

sub new {
    my ($class, $env) = @_;
    
    my $this = {
        request => new Plack::Request($env),
    };
    bless $this, $class;
    
    $this->init($this->{request}, $env);

    return $this;
}

sub init {
    my ($this, $request, $env) = @_;
    
    $this->{arguments}    = $this->read_arguments($request);
    $this->{cookies}      = $request->cookies();
    $this->{user_agent}   = $request->user_agent();
    $this->{path}         = $env->{PATH_INFO};
    $this->{http_referer} = $env->{HTTP_REFERER};
    $this->{remote_addr}  = $env->{REMOTE_ADDR};
    $this->{server_port}  = $env->{SERVER_PORT};
    $this->{server_name}  = $env->{SERVER_NAME};
}

sub read_arguments {
    my ($this, $request) = @_;

    my %ret;
    my $pairs = $request->parameters();
    for my $key (keys %$pairs) {
        $ret{$key} = [$pairs->get_all($key)];
    }
    
    return \%ret;
}

sub arguments {
    my ($this) = @_;

    return keys %{$this->{arguments}};
}

sub argument {
    my ($this, $name) = @_;

    my $values = $this->{arguments}{$name};
    
    return $values ? $values->[-1] : undef;
}

sub margument {
    my ($this, $name) = @_;
    
    return $this->{arguments}{$name};
}

sub cookies {
    my ($this) = @_;
    
    return keys %{$this->{cookies}};
}

sub cookie {
    my ($this, $name) = @_;
    
    return $this->{cookies}{$name};
}

sub user_agent {
    my ($this) = @_;
    
    return $this->{user_agent};
}

1;
