package Sweet::File;
use Moose;
use MooseX::StrictConstructor;

use Try::Tiny;

use File::Copy;
use File::Spec;
use File::Touch;
use File::Remove 'remove';

has dir => (
    builder   => '_build_dir',
    is        => 'rw',
    isa       => 'BI::Dir',
    lazy      => 1,
    predicate => 'has_dir',
);

has name => (
    builder   => '_build_name',
    is        => 'rw',
    isa       => 'Str',
    lazy      => 1,
    predicate => 'has_name',
);

sub create {
    touch( shift->path );
}

sub does_not_exists {
    return !-e shift->path;
}

sub erase {
    remove( shift->path );
}

sub has_zero_size {
    return -z shift->path;
}

sub is_a_plain_file {
    return -f shift->path;
}

sub is_executable {
    return -x shift->path;
}

sub is_writable {
    return -w shift->path;
}

__PACKAGE__->meta->make_immutable;

1;

