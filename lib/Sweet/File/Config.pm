package Sweet::File::Config;
use Moose;
use namespace::autoclean;

use Carp;
use Sweet::HomeDir;
use YAML;

extends 'Sweet::File';

sub _build_dir { Sweet::HomeDir->new }

has content => (
    is         => 'ro',
    lazy_build => 1,
    isa        => 'HashRef',
);

sub _build_content {
    my $self = shift;

    my $path = $self->path;

    my $content = YAML::LoadFile( $path )
       or croak "Cannot load YAML file $path\n";

    return $content;
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Sweet::File::Config

=head1 INHERITANCE

L<Sweet::File>

=cut

=head1 ATTRIBUTES

=head2 content

=cut

