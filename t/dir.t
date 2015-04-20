use strict;
use warnings;
use Test::More;

use Sweet::Dir;
use Sweet::File::DSV;

my $test_dir = Sweet::Dir->new( path => 't' );

ok $test_dir->is_a_directory, 't/ is a directory';

my $sub_dir1 = $test_dir->sub_dir( 'foo', 'bar' );
my $sub_dir2 = $test_dir->sub_dir( [ 'foo', 'bar' ] );

is $sub_dir1->path, $sub_dir2->path, "both sub_dir('foo','bar') and sub_dir(['foo','bar']) work";

my $file = $test_dir->file('file');
isa_ok $file , 'Sweet::File';
ok $file->does_not_exists, 'file() returns a reference to a file without creating it';

my $file2 = $test_dir->file('file', sub {
        my ( $dir, $name ) = @_;

        my $file = Sweet::File::DSV->new(
            dir       => $dir,
            name      => $name,
            separator => "\t",
        );

        return $file;
});
isa_ok $file2, 'Sweet::File::DSV', 'file() accepts an optional reference to a sub builder';

done_testing;

