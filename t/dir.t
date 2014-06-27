use strict;
use warnings;
use Test::More;

use Sweet::Dir;

my $test_dir = Sweet::Dir->new( path => 't' );

ok $test_dir->is_a_directory, 't/ is a directory';

my $file = $test_dir->file('file');
isa_ok $file , 'Sweet::File';
ok $file->does_not_exists, 'file() returns a reference to a file without creating it';

done_testing;

