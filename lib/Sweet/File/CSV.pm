package Sweet::File::CSV;
use Moose;
use namespace::autoclean;

extends 'Sweet::File::DSV';

sub _build_sep { ',' }

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

Sweet::File::CSV

=head1 SYNOPSIS

    my $csv = Sweet::File::CSV->new(dir => $dir, name => 'file.csv');

=head1 ATTRIBUTES

=head2 sep

Separator defaults to C<,>.

=cut

