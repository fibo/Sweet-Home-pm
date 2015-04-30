package Sweet::File;
use Moose;
use namespace::autoclean;

use Carp;
use Try::Tiny;

use File::Basename;
use File::Copy;
use File::Remove 'remove';
use File::Slurp::Tiny qw(read_lines);
use File::Spec;

use MooseX::Types::Path::Class;

has _lines => (
    builder => '_read_lines',
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

sub _read_lines {
    read_lines(
        shift->path,
        binmode   => ':utf8',
        array_ref => 1,
        chomp     => 1,
    );
}

has dir => (
    builder   => '_build_dir',
    is        => 'ro',
    isa       => 'Sweet::Dir',
    lazy      => 1,
    predicate => 'has_dir',
);

sub _build_dir {
    my $self = shift;

    my $path = $self->path;

    my $dirname = dirname($path);

    my $dir = Sweet::Dir->new( path => $dirname );

    return $dir;
}

has name => (
    builder   => '_build_name',
    is        => 'ro',
    isa       => 'Str',
    lazy      => 1,
    predicate => 'has_name',
);

sub _build_name {
    my $self = shift;

    my $path = $self->path;

    my $name = basename($path);

    return $name;
}

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
    builder => '_build_path',
    coerce  => 1,
    is      => 'ro',
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

    my $class = $self->meta->name;

    my $file_copied = try {
        $class->new( dir => $dir, name => $name );
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

    my $file1 = Sweet::File->new(
        dir => '/path/to/dir',
        name => 'foo',
    );

    my $file2 = Sweet::File->new(path => '/path/to/file');

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

=head2 _read_lines

Reads the file contents using L<File::Slurp::Tiny> C<read_lines> function.

Defaults to

    sub _read_lines {
        read_lines(
            shift->path,
            binmode   => ':utf8',
            array_ref => 1,
            chomp     => 1,
        );
    }

and must return an array_ref of strings containing file lines.

=cut

