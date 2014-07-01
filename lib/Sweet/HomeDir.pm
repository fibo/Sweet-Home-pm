package Sweet::HomeDir;
use Moose;

use File::HomeDir;

extends 'Sweet::Dir';

sub _build_path { File::HomeDir->my_home }

__PACKAGE__->meta->make_immutable;

1;

