package Sweet::HomeDir;

use Moose;
use MooseX::StrictConstructor;

use File::HomeDir;

extends 'Sweet::Dir';

sub _build_path {
    return File::HomeDir->my_home;
}

__PACKAGE__->meta->make_immutable;

1;

