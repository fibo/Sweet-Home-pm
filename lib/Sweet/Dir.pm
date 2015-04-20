package Sweet::Dir;
use Moose;
use namespace::autoclean;

use Carp;
use Try::Tiny;

use MooseX::Types::Path::Class;
use File::Path qw(make_path remove_tree);
use Try::Tiny;

use Sweet::File;

has path => (
    builder => '_build_path',
    coerce  => 1,
    is      => 'ro',
    isa     => 'Path::Class::Dir',
    lazy    => 1,
);

sub create {
    my $self = shift;
    my $path = $self->path;
    my $make_path_error;

    return $self if $self->is_a_directory;

    try {
      make_path( $path, { error => \$make_path_error } );
    }
    catch {
      confess $make_path_error;
    };
}

sub does_not_exists { !-d shift->path }

sub erase {
    my $self = shift;

    my $path = $self->path;
    my $remove_path_error;

    try {
      remove_path( $path, { error => \$remove_path_error } );
    }
    catch {
      confess $remove_path_error;
    };
}

sub file {
    my ( $self, $name, $builder ) = @_;

    my $default_builder = sub {
        my ( $dir, $name ) = @_;

        my $file = Sweet::File->new(
            dir  => $dir,
            name => $name
        );

        return $file;
    };

    $builder = $default_builder if (not defined $builder);

    my $file = try {
        $builder->( $self, $name );
    }
    catch {
        confess $_;
    };

    return $file;
}

sub is_a_directory { -d shift->path }

sub sub_dir {
    my $self = shift;

    my @path;

    if ( scalar(@_) == 1 and ref $_[0] eq 'ARRAY' ) {
        @path = @{ $_[0] };
    }
    else {
        @path = @_;
    }

    my $sub_dir_path = File::Spec->catfile( $self->path, @path );

    my $sub_dir = Sweet::Dir->new( path => $sub_dir_path );

    return $sub_dir;
}

use overload q("") => sub { shift->path };

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Sweet::Dir

=head1 SYNOPSIS

    use Sweet::Dir;

    my $dir = Sweet::Dir->new(path => '/path/to/dir');
    $dir->create;


    say $dir; # /path/to/dir

=head1 ATTRIBUTES

=head2 path

=head1 METHODS

=head2 create

    $dir->create;

=head2 does_not_exists

    $dir->create if $dir->does_not_exists;

=head2 erase

    $dir->erase;

=head2 file

Instance of file inside dir. Returns a L<Sweet::File> by default.

    my $file = $dir->file('foo.txt');
    say $file; # /path/to/dir/foo.txt

Accepts an optional reference to a sub which will be C<$dir> and C<$name>
parameters and will be called to build the object reference. For example

    use Sweet::File::DSV;

    my $file = $dir->file('bar.tsv', sub {
        my ( $dir, $name ) = @_;

        my $file = Sweet::File::DSV->new(
            dir  => $dir,
            name => $name,
            separator => "\t",
        );

        return $file;
    });

=head2 is_a_directory

    # Create dir if it does not exists.
    $dir->is_a_directory or $dir->create;

=head2 sub_dir

    my $dir2 = $dir->sub_dir('foo', bar');
    # Or pass an arrayref if you prefer.
    # my $dir2 = $dir->sub_dir(['foo', bar']);

    # Create foo/bar sub directory.
    $dir2->create;

=cut

