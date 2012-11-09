use 5.010;
use strict;

use lib 'lib';
use Areno;
use Plack::Builder;

my $app;
eval {
    my $areno = Areno->new();
    die "Init error" unless $areno;

    my $my_app = sub {
        my $env = shift;

        $areno->init();
        $areno->run($env);

        return [$areno->status(), $areno->headers(), $areno->body()];
    };

    $app = builder {
        enable "Plack::Middleware::AccessLog", format => "combined";
        enable 'Session', store => 'File';
        if ($ENV{STATIC_DIR}) {
            enable "Plack::Middleware::Static",
                    path => qr{\.(jpeg|jpg|gif|ico|png|css|js|pdf|txt|tar)$}, root => $ENV{STATIC_DIR};
        }
        if ($ENV{ARENO_OAUTH2_ENABLE}) {
            enable 'OAuth2',
                client_id     => $ENV{ARENO_OAUTH2_CLIENT_ID},
                client_secret => $ENV{ARENO_OAUTH2_CLIENT_SECRET},
                redirect_uri  => $ENV{ARENO_OAUTH2_REDIRECT_URI},
        }
        $my_app;
    };
};
if ($@) {
    say STDERR "[pid: $$] init error: $@";
    $app = sub {
        ["500", [], ["Areno init error"]]
    };
}

return $app;
