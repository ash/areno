package Areno;

use strict;

use Cwd;
use Plack::Request;

use Areno::Request;
use Areno::Manifest;
use Areno::Manifest::Stash;
use Areno::Content;
use Areno::Site;
use Areno::Transform;

sub new {
    my ($class) = @_;

    my $this = {
        http => {
            status  => 200,
            headers => [],
            body    => [],
        },
        sites     => {},
        transform => new Areno::Transform(),
        stash     => {},
    };
    bless $this, $class;
    
    $this->start();
    $this->init();
    
    return $this;
}

sub start {
    my ($this) = @_;

    $this->read_sites();
}

sub init {
    my ($this) = @_;
    
    $this->{http} = {
        status  => 200,
        headers => [],
        body    => [],
    };
}

sub read_sites {
    my ($this) = @_;
    
    my @search_path = (getcwd() || '.');
    if ($ENV{ARENO_SEARCH}) {
        push @search_path, split /:/, $ENV{ARENO_SEARCH};
    }
    
    for my $base_path (@search_path) {
        my $sites_path = "$base_path/sites";
    
        opendir my($sites), $sites_path;
        die "No 'sites' directory found at $base_path" unless $sites;
        my @domains = grep /\w/, grep {-d "$sites_path/$_"} readdir $sites;
        close $sites;
        die "No sites found in $sites_path" unless @domains;
        
        for my $domain (@domains) {
            $this->{sites}{$domain} = new Areno::Site($this, $domain, $sites_path);
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

    $this->{request} = new Areno::Request($env);
    $this->{doc}     = $this->new_doc($env);
    $this->{stash}   = {};

    my $site = $this->dispatch($env);
    my $page = $site->dispatch($env);
    unless ($page) {
        $this->{http}{status}  = 404;
        $this->{http}{headers} = ['Content-Type', 'text/html'];
        $this->{http}{body}    = [ "<h2>404: Not found $env->{PATH_INFO}</h2>" ];
        return;
    }

    $page->init($this->{doc});
    $page->run();
    $this->post_init($page);
    $this->transform($page);

    push @{$this->{http}{headers}}, @{$page->get_headers()};
}

sub dispatch {
    my ($this, $env) = @_;

    my $sites = $this->{sites};

    my $server_name = $env->{HTTP_HOST};
    if ($server_name) {
        $server_name =~ s/:\d+$//;
    }
    else {
        $server_name = 'localhost';
    }

    if (exists $sites->{$server_name}) {
        return $sites->{$server_name};
    }
    else {
        warn "Non-existing site '$server_name' requested\n";
        return $sites->{localhost};
    }
}

sub post_init {
    my $this = shift;
    my ($page) = @_;

    my $manifest = $page->manifest;
    my $stash_obj = Areno::Manifest::Stash->new($this);
    $manifest->appendChild($stash_obj->node);
}

sub new_doc {
    my ($this, $env) = @_;
    
    my $dom = (new XML::LibXML)->createDocument('1.0', 'UTF-8');
    my $root = $dom->createElement('page');
    $dom->setDocumentElement($root);

    my $manifest = new Areno::Manifest($this, $env);
    $root->appendChild($manifest->node());

    my $content = new Areno::Content($this, $env);
    $root->appendChild($content->node());

    return {
        dom      => $dom,
        root     => $root,
        manifest => $manifest->node(),
        content  => $content->node(),
        request  => $this->{request},
    };
}

sub transform {
    my ($this, $page) = @_;

    my $content_type;
    if (exists $page->{body}) {
        $content_type = 'text/plain';
        $this->{http}{body} = [$page->{body}];
    }
    elsif (!($this->{request}->argument('xml'))) {
        $content_type = 'text/html';
        $this->{http}{body} = [$this->{transform}->transform($this->{doc}, $page)];
    }
    else {
        $content_type = 'text/xml';
        $this->{http}{body} = [$this->{doc}{dom}->toString()];
    }

    my %headers = @{$this->{http}{headers}};
    unless ($headers{'Content-Type'}) {
        push @{$this->{http}{headers}}, ('Content-Type', $content_type);
    }
}

sub request {
    my ($this) = @_;
    
    return $this->{request};
}

sub stash {
    my ($this) = @_;
    
    return $this->{stash};
}


1;
