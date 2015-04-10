use strict;
use warnings;

use Test::More tests => 5;

use Sweet::Dir;
use Sweet::File::DSV;

my $test_dir = Sweet::Dir->new( path => 't' );                                                                                                                                                 

my $file1 = Sweet::File::DSV->new(
    name => 'file1.dat',
    dir  => $test_dir,
    sep  => '|',
);

my @file1_rows = ( 'foo|bar', '2|3' );
my @file1_fields = ( 'FIELD_A', 'FIELD_B' );

is $file1->header,'FIELD_A|FIELD_B','header';

my @got_rows = $file1->rows;
is_deeply \@got_rows,\@file1_rows,'rows';

my @got_fields = $file1->fields;
is_deeply \@got_fields,\@file1_fields,'fields';

is $file1->field(0), $file1_fields[0], 'field(0)';
is $file1->field(1), $file1_fields[1], 'field(1)';

