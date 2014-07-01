package Sweet::Host;
use Moose;

has 'hostname' => (
    builder => '_build_hostname',
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
);

has 'domainname' => (
    builder => '_build_domainname',
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
);

__PACKAGE__->meta->make_immutable;

1;

