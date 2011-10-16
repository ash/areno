use strict;

use base 'lib';
use Areno;

my $areno = new Areno();

sub {
    my ($env) = @_;

    $areno->init();
    $areno->run($env);

    return [$areno->status(), $areno->headers(), $areno->body()];
}
