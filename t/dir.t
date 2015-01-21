use strict;
use warnings;
use Test::More;

use Sweet::Dir;

my $test_dir = Sweet::Dir->new( path => 't' );

ok $test_dir->is_a_directory, 't/ is a directory';

my $sub_dir1 = $test_dir->sub_dir('foo','bar');
my $sub_dir2 = $test_dir->sub_dir(['foo','bar']);

is $sub_dir1->path, $sub_dir2->path,"both sub_dir('foo','bar') and sub_dir(['foo','bar']) works";

my $file = $test_dir->file('file');
isa_ok $file , 'Sweet::File';
ok $file->does_not_exists, 'file() returns a reference to a file without creating it';

done_testing;

