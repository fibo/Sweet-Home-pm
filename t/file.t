use utf8;
use strict;
use warnings;

use Test::More tests => 19;

use File::Spec::Functions;
use File::Temp qw(tempdir);
use Sweet::Dir;

use Sweet::File;

my $test_dir = Sweet::Dir->new( path => 't' );

my $file = Sweet::File->new( name => 'file.t', dir => $test_dir );
ok $file->is_a_plain_file;
ok $file->is_writable;

is "$file", catfile( 't', 'file.t' ), 'stringify to path';

is $file->path, catfile( 't', 'file.t' ), 'path';
is $file->extension, 't', 'path';

my $file_touched = Sweet::File->new( name => 'file_touched', dir => $test_dir );
ok $file_touched->does_not_exists, 'touched file does not exists yet';

my $file_that_do_not_exists = $test_dir->file('file_that_do_not_exists');
ok $file_that_do_not_exists->does_not_exists, 'file does not exists';

my $empty_file = $test_dir->file('empty_file');
ok $empty_file->has_zero_size, 'empty file has zero size';

my $file1 = Sweet::File->new( name => 'file1.txt', dir => $test_dir );
my @file1_lines = ( "Hi,", "I am a text file." );

is $file1->num_lines, 2, 'num_lines';
my @got_lines = $file1->lines;
is_deeply \@got_lines, \@file1_lines, 'lines';
is $file1->line(0), $file1_lines[0], 'line(0)';
is $file1->line(1), $file1_lines[1], 'line(1)';

my $file_from_path = Sweet::File->new(path=>'t/file.t');
is $file_from_path->name, 'file.t', 'name from path';
is $file_from_path->dir->path, 't', 'dir from path';

my $utf8 = Sweet::File->new(path=>'t/utf8.txt');
is $utf8->line(0), '£¥€$', 'read utf8';

my $temp_path = tempdir();
my $temp = Sweet::Dir->new( path => $temp_path )->create;

my $copied_file = $file->copy_to_dir($temp);
ok $copied_file->is_a_plain_file, 'copy_to_dir';

my $copied_file1 = $file1->copy_to_dir($temp_path);
ok $copied_file1->is_a_plain_file, 'copy_to_dir coerces Str to Sweet::Dir';

my $copied_file2 = $file1->copy_to_dir([$temp_path, 'foo']);
ok $copied_file2->is_a_plain_file, 'copy_to_dir coerces ArrayRef to Sweet::Dir';

my $copied_file3 = $file->copy_to_dir($temp->sub_dir('bar'));
ok $copied_file3->is_a_plain_file, 'copy_to_dir creates target dir';

