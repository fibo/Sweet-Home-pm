use strict;
use warnings;

use Test::More tests => 2;

use Sweet::Dir;
use Sweet::File::CSV;

my $test_dir = Sweet::Dir->new( path => 't' );                                                                                                                                                 

my $file1 = Sweet::File::CSV->new(name=>'file1.csv', dir => $test_dir);

my @file1_rows = ( '1,2', '3,4' );

is $file1->header,'FIELDA,FIELDB','header';

my @got_rows = $file1->rows;
is_deeply \@got_rows,\@file1_rows,'rows';

