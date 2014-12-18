package Sweet::File;
use Moose;

use Try::Tiny;

use File::Basename;
use File::Copy;
use File::Remove 'remove';
use File::Spec;

use MooseX::Types::Path::Class;

has 'dir' => (
    builder   => '_build_dir',
    is        => 'ro',
    isa       => 'Sweet::Dir',
    lazy      => 1,
    predicate => 'has_dir',
);

has 'name' => (
    builder   => '_build_name',
    is        => 'ro',
    isa       => 'Str',
    lazy      => 1,
    predicate => 'has_name',
);

has 'ext' => (
    default => sub {
        my $self = shift;

        my $path = $self->path;

        my ( $filename, $dirname, $suffix ) = fileparse( $path, qr/[^.]*$/ );

        return $suffix;
    },
    is        => 'ro',
    isa       => 'Str',
    lazy      => 1,
    predicate => 'has_ext',
);

has 'path' => (
    builder => '_build_path',
    coerce  => 1,
    is      => 'rw',
    isa     => 'Path::Class::File',
    lazy    => 1,
);

sub _build_path {
    my $self = shift;

    my $name = $self->name;
    my $dir  = $self->dir;

    my $dir_path = $dir->path;

    my $path = File::Spec->catfile( $dir_path, $name );

    return $path;
}

sub copy_to_dir {
    my $self = shift;

    my $dir  = shift;
    my $name = $self->name;

    my $file_copied = try {
        Sweet::File->new( dir => $dir, name => $name );
    }
    catch {
        die $_;
    };

    my $source_path = $self->path;
    my $target_path = $file_copied->path;

    try {
        $dir->is_a_directory or $dir->create;
    }
    catch {
        die $_;
    };

    try {
        copy( $source_path, $target_path );
    }
    catch {
        die $_;
    };

    return $file_copied;
}

sub does_not_exists { !-e shift->path }

sub erase { remove( shift->path ) }

sub has_zero_size { -z shift->path }

sub is_a_plain_file { -f shift->path }

sub is_executable { -x shift->path }

sub is_writable { -w shift->path }

use overload q("") => sub { shift->path };

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Sweet::File

=head1 SYNOPSIS

    use Sweet::File;

    my $file = Sweet::File->new(
        dir => '/path/to/dir',
        name => 'foo',
    );

=head1 ATTRIBUTES

=head2 dir

=head2 ext

=head2 name

=head2 path

=head1 METHODS

=head2 copy_to_dir

=head2 does_not_exists

=head2 erase

=head2 has_zero_size

=head2 is_a_plain_file

=head2 is_executable

=head2 is_writable

=cut

