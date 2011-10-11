package Areno;

use strict;

sub new {
    my ($class) = @_;
    
    my $this = {
        http => {
            status => 200,
            headers => [
                'Content-Type' => 'text/html',
            ],
            body => ['I am Areno.'],
        }
    };
    bless $this, $class;
    
    return $this;
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
    my ($this) = @_;

}

1;
