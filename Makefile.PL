use strict;
use warnings;

use ExtUtils::MakeMaker 6.64;

WriteMakefile(
    ABSTRACT_FROM    => 'lib/Sweet/Home.pm',
    VERSION_FROM     => 'lib/Sweet/Home.pm',
    AUTHOR           => 'G. Casati <fibo@cpan.org>',
    NAME             => 'Sweet::Home',
    MIN_PERL_VERSION => '5.8.0',
    META_MERGE       => {
        resources => {
            homepage   => 'https://metacpan.org/pod/My::Package',
            license    => 'http://g14n.info/artistic-license',
            repository => 'http://github.com/fibo/Sweet-Home-pm',
            bugtracker => 'http://github.com/fibo/Sweet-Home-pm/issues',
        },
    },
    PREREQ_PM => {
        'File::Basename'             => '0',
        'File::Copy'                 => '0',
        'File::HomeDir'              => '0',
        'File::Path'                 => '0',
        'File::Remove'               => '0',
        'File::Spec'                 => '0',
        'Moose'                      => '2',
        'MooseX::Types::Path::Class' => '0.06',
    },
    test          => { TESTS => 't/*.t' },
    TEST_REQUIRES => {
        'Test::Compile' => '1',
        'Test::More'    => '1',
        'Test::Pod'     => '1'
    }
);

