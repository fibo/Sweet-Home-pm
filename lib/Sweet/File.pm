package Sweet::File;
use Moose;
use namespace::autoclean;

use Carp;
use Try::Tiny;

use File::Basename;
use File::Copy;
use File::Remove 'remove';
use File::Slurp;
use File::Spec;

use MooseX::Types::Path::Class;

has _read => (
    builder => '_read_file',
    handles => {
        lines     => 'elements',
        line      => 'get',
        num_lines => 'count',
    },
    is     => 'ro',
    isa    => 'ArrayRef[Str]',
    lazy   => 1,
    traits => ['Array'],
);

sub _read_file { read_file( shift->path, array_ref => 1 ) }

has dir => (
    builder   => '_build_dir',
    is        => 'ro',
    isa       => 'Sweet::Dir',
    lazy      => 1,
    predicate => 'has_dir',
);

has name => (
    builder   => '_build_name',
    is        => 'ro',
    isa       => 'Str',
    lazy      => 1,
    predicate => 'has_name',
);

has extension => (
    default => sub {
        my $path = shift->path;

        my ( $filename, $dirname, $suffix ) = fileparse( $path, qr/[^.]*$/ );

        return $suffix;
    },
    is        => 'ro',
    isa       => 'Str',
    lazy      => 1,
);

has path => (
    coerce  => 1,
    default => sub {
        my $self = shift;

        my $name = $self->name;
        my $dir  = $self->dir;

        my $dir_path = $dir->path;

        my $path = File::Spec->catfile( $dir_path, $name );

        return $path;
    },
    init_arg => undef,
    is       => 'rw',
    isa      => 'Path::Class::File',
    lazy     => 1,
);

sub copy_to_dir {
    my $self = shift;

    my $dir  = shift;
    my $name = $self->name;

    my $file_copied = try {
        Sweet::File->new( dir => $dir, name => $name );
    }
    catch {
        confess $_;
    };

    my $source_path = $self->path;
    my $target_path = $file_copied->path;

    try {
        $dir->is_a_directory or $dir->create;
    }
    catch {
        confess $_;
    };

    try {
        copy( $source_path, $target_path );
    }
    catch {
        confess $_;
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

=head2 extension

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

=head2 line

    my $line1 = $file->line(0);
    my $line2 = $file->line(1);
    my $line3 = $file->line(2);

=head2 lines

    for my $line ( $file->lines ) {
        chomp $line;
        $line =~ s/foo/bar/;
        say $line;
    }

=head2 num_lines

    say $file->num_lines if $file->is_a_plain_file;

=head2 _read_file

Reads the file contents using L<File::Slurp> C<read_file> function.

Defaults to

    sub { read_file( shift->path, array_ref => 1 ) }

and must return an array_ref of strings containing file lines.

=cut

