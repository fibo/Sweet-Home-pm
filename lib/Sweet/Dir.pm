package Sweet::Dir;
use Moose;
use namespace::autoclean;
use MooseX::StrictConstructor;

use Try::Tiny;

use MooseX::Types::Path::Class;

=head1 SYNOPSIS

    my $dir = Sweet::Dir->new(path => '/path/to/dir');

=cut

has 'path' => (
builder=>'_build_path',
coerce=>1,
is=>'ro',
isa=>'Path::Class::Dir',
required=>1,
);


__PACKAGE__->meta->make_immutable;

1;

