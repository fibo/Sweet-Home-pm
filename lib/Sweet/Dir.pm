package Sweet::Dir;
use Moose;
use namespace::autoclean;

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
      die $make_path_error;
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
      die $remove_path_error;
    };
}

sub file {
    my $self = shift;

    my $name = shift;

    my $file = Sweet::File->new( dir => $self, name => $name );

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

=encoding utf8

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

=head2 does_not_exists

=head2 erase

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

