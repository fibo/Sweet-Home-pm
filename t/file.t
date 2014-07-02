use strict;
use warnings;
use Sweet::Dir;
use Test::More;
use File::Spec::Functions;

use Sweet::File;

my $test_dir = Sweet::Dir->new( path => 't' );

my $file = Sweet::File->new( name => 'file.t', dir => $test_dir );
ok $file->is_a_plain_file;
ok $file->is_writable;

is "$file", catfile( 't', 'file.t' ), 'stringify to path';

is $file->path, catfile( 't', 'file.t' ), 'path';
is $file->ext, 't', 'path';

my $file_touched = Sweet::File->new( name => 'file_touched', dir => $test_dir );
ok $file_touched->does_not_exists, 'touched file does not exists yet';

# TODO ok $file_touched->create,          'touch file';
#ok $file_touched->is_a_plain_file, 'touched filed exists';
#$file_touched->erase;
#ok $file_touched->does_not_exists, 'touched file was removed';

my $file_that_do_not_exists = $test_dir->file('file_that_do_not_exists');
ok $file_that_do_not_exists->does_not_exists, 'file does not exists';

my $empty_file = $test_dir->file('empty_file');
ok $empty_file->has_zero_size, 'empty file has zero size';

done_testing;
__END__

my $tmp          = $home->sub_dir('tmp');
my $not_writable = $tmp->file('not_writable');
ok !$not_writable->is_writable, 'not_writable is not writable';
is $not_writable->num_rows, 1, 'read not_writable file';

