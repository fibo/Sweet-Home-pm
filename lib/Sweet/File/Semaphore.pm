package Sweet::File::Semaphore;
use Moose;

extends 'Sweet::File';

use Sweet::Types;

has linked_file => (
    is       => 'ro',
    isa      => 'Sweet::File',
    coerce   => 1,
    required => 1,
);

sub create {
    my $self = shift;
}

sub _build_extension { 'ok' }

sub _build_name {
    my $self = shift;

    my $extension = $self->extension;
    my $linked_file = $self->linked_file;

    my $name = $linked_file->name . '.' . $extension;

    return $name;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Sweet::File::Semaphore

=head1 SYNOPSIS

    use Sweet::File::Semaphore;

    my $file = Sweet::File->new(
        dir => '/path/to/dir',
        name => 'foo.dat',
    );

    my $semaphore = Sweet::File::Semaphore->new(linked_file=>$file);
    say $semaphore; # /path/to/dir/foo.dat.ok

    $semaphore->create;

=head1 ATTRIBUTES

=head2 linked_file

=head1 METHODS

=head2 create

=cut

