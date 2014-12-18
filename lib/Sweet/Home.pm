package Sweet::Home;
use strict;
use warnings;

our $VERSION = '0.1';

1;

=encoding utf8

=head1 NAME

Sweet::Home - Dir, File, HomeDir, and other sweet classes

=begin HTML

<p><a href="https://metacpan.org/pod/Sweet::Home" target="_blank"><img alt="CPAN version" src="https://badge.fury.io/pl/Sweet-Home.svg"></a> <a href="https://travis-ci.org/fibo/Sweet-Home-pm" target="_blank"><img alt="Build Status" src="https://travis-ci.org/fibo/Sweet-Home-pm.svg?branch=master"></a></p>

=end HTML

=head1 SYNOPSIS

    use Sweet::Dir;

    my $dir = Sweet::Dir->new(path => '/path/to/mydir');

    $dir->is_a_directory || $dir->create;

    my $dir2 = $dir->sub_dir('foo');

    $dir2->create;

    my $file = $dir2->file('bar');

=head1 DESCRIPTION

Nothing is better than feel at home. Where is the home? The home is where I can feel comfortable (cit. Jovanotti).

This package provides a set of features to make you feel comfortable when working with files and folders.

It is just syntactic sugar on top of packages like L<'File::Basename'>, L<'File::Copy'>, L<'File::HomeDir'>, L<'File::Path'>, L<'File::Remove'>, L<'File::Spec'>, etc.

=head1 CLASSES

=over 4

=item L<Sweet::Dir>

=item L<Sweet::File>

=item L<Sweet::HomeDir>

=back

=head1 COPYRIGHT AND LICENSE

    This software is copyright (c) 2014 by G. Casati.

    This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself.

=cut

