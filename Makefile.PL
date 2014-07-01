use strict;
use warnings;

use ExtUtils::MakeMaker 6.64;

WriteMakefile(
  ABSTRACT_FROM => 'lib/Sweet/Home.pm',
  VERSION_FROM  => 'lib/Sweet/Home.pm',
  AUTHOR        => 'G. Casati <fibo@cpan.org>',
  NAME          => 'Sweet-Home',
  PREREQ_PM     => {
    'File::Copy'                 => '0',
    'File::HomeDir'              => '0',
    'File::Path'                 => '0',
    'File::Remove'               => '0',
    'File::Spec'                 => '0',
    'Moose'                      => '2',
    'MooseX::StrictConstructor'  => '0',
    'MooseX::Types::Path::Class' => '0.06',
  },
  test          => {TESTS           => 't/*.t'},
  TEST_REQUIRES => {'Test::Compile' => 'v1.0.1', 'Test::More' => '1.001003'},
);
