use strict;
use warnings;

use Test::More tests => 15;

use utf8;
use File::Spec::Functions;
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

