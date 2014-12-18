package Sweet::Dir;
use Moose;

use Try::Tiny;

use MooseX::Types::Path::Class;
use File::Path qw(make_path remove_tree);

use Sweet::File;

has 'path' => (
    builder  => '_build_path',
    coerce   => 1,
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    required => 1,
);

sub create {
    my $self = shift;
    my $path = $self->path;
    my $make_path_error;

    return $self if $self->is_a_directory;

    make_path( $path, { error => \$make_path_error } );

    #TODO lancia eccezione, scrivi classe eccezioni, test e aggiorna synopsis
}

sub does_not_exists {
    return !-d shift->path;
}

sub erase {
    my $self = shift;

    my $path = $self->path;
    my $remove_path_error;

    remove_path( $path, { error => \$remove_path_error } );

    #TODO lancia eccezione, scrivi classe eccezioni, test e aggiorna synopsis
}

sub file {
    my $self = shift;

    my $name = shift;

    #TODO try file
    my $file = Sweet::File->new( dir => $self, name => $name );

    return $file;
}

sub is_a_directory { -d shift->path }

#TODO sub file_list
#

sub sub_dir {
    my $self = shift;

    my @path = @_;

    # TODO try

    my $sub_dir_path = File::Spec->catfile( $self->path, @path );

    my $sub_dir = Sweet::Dir->new( path => $sub_dir_path );

    return $sub_dir;
}

use overload q("") => sub { shift->path };

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Sweet::Dir

=head1 SYNOPSIS

    use Sweet::Dir;

    my $dir = Sweet::Dir->new(path => '/path/to/dir');
    $dir->create;

=head1 ATTRIBUTES

=head2 path

=head1 METHODS

=head2 create

=head2 does_not_exists

=head2 erase

=head2 is_a_directory

=head2 sub_dir

=cut

