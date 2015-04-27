use strict;
use warnings;

use Test::More tests => 5;

use Sweet::Dir;
use Sweet::File::CSV;

my $test_dir = Sweet::Dir->new( path => 't' );

my $file1 = Sweet::File::CSV->new(
    name => 'file1.csv',
    dir => $test_dir,
);

my @file1_rows = ( '1,2', '3,4' );
my @file1_fields = ('FIELDA', 'FIELDB');

is $file1->header, 'FIELDA,FIELDB', 'header';

my @got_rows = $file1->rows;
is_deeply \@got_rows, \@file1_rows, 'rows';

my @got_fields = $file1->fields;
is_deeply \@got_fields, \@file1_fields, 'fields';

is $file1->field(0), $file1_fields[0], 'field(0)';
is $file1->field(1), $file1_fields[1], 'field(1)';

