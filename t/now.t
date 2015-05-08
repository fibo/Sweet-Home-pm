use strict;
use warnings;

use Test::More tests => 1;

use Sweet::Now;

my $now = Sweet::Now->new;

ok $now->dd =~ m/\d\d/;

