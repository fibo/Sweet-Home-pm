package Sweet::HomeDir;
use v5.12;
use Moose;
use namespace::autoclean;

use File::HomeDir;

extends 'Sweet::Dir';

sub _build_path { File::HomeDir->my_home }

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Sweet::HomeDir

=head1 INHERITANCE

Inherits from L<Sweet::Dir>.

=head1 ATTRIBUTES

=head2 path

Defaults to value given by L<File::HomeDir>'s C<my_home> function.

=cut

