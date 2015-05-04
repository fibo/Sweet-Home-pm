package Sweet::Types;
use MooseX::Types;
use MooseX::Types::Moose qw(Str ArrayRef);

class_type('Sweet::Dir');

coerce 'Sweet::Dir',
  from Str,      via { Sweet::Dir->new( path => $_ ) },
  from ArrayRef, via { Sweet::Dir->new( path => $_ ) };

__PACKAGE__->meta->make_immutable;

1;

