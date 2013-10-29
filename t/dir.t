use strict;
use warnings;
use Test::More;
use Test::Moose;
use Test::use::ok;

use ok 'Sweet::Dir';

my $class = 'Sweet::Dir';

my @attributes = qw(
  path
);

#TODO  create move_to_dir
my @methods = qw(
  create
  does_not_exists
  erase
  file
  is_a_directory
  sub_dir
);

can_ok( $class, $_ ) for @methods;

has_attribute_ok( $class, $_ ) for @attributes;

meta_ok $class;

my $test_dir = Sweet::Dir->new( path => 't' );

ok $test_dir->is_a_directory, 't/ is a directory';

my $file = $test_dir->file('file');
isa_ok $file , 'Sweet::File';
ok $file->does_not_exists,
  'file() returns a reference to a file without creating it';

done_testing;

