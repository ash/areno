use strict;

use base 'lib';
use Areno;

sub {
    my ($env) = @_;

    my $areno = new Areno();
    $areno->run();

    return [$areno->status(), $areno->headers(), $areno->body()];
}
