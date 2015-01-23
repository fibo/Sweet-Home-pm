package Sweet::File::DSV;
use Moose;
use namespace::autoclean;

extends 'Sweet::File';

has _fields => (
    builder => '_build_fields',
    handles => {
        field   => 'get',
        fields   => 'elements',
        num_fields => 'count',
    },
    is     => 'ro',
    isa    => 'ArrayRef[Str]',
    lazy   => 1,
    traits => ['Array'],
);

sub _build_fields {
    my $self = shift;

    my $header    = $self->header;
    my $sep = $self->sep;

    # If separator is a pipe, skip it.
    $sep = '\|' if ($sep eq '|');

    my @fields = split $sep, $header;

    return \@fields;
}

has header => (
    builder => '_build_header',
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
);

sub _build_header {
    my $self = shift;

    my $header = $self->line(0);

    chomp $header;

    return $header;
}

has sep => (
    builder  => '_build_sep',
    is       => 'ro',
    isa      => 'Str',
    lazy => 1,
);

has _rows => (
    builder => '_build_rows',
    traits  => ['Array'],
    handles => {
        num_rows => 'count',
        row => 'get',
        rows => 'elements',
    },
    is   => 'ro',
    isa  => 'ArrayRef[Str]',
    lazy => 1,
);

sub _build_rows {
    my $self = shift;

    my @rows = $self->lines;

    # Remove header.
    shift @rows;

    chomp @rows;

    return \@rows;
}

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

Sweet::File::DSV

=head1 SYNOPSIS

Given a C<file.dat> in your home dir.

    FIELD_A|FIELD_B
    foo|bar
    2|3

Create a pipe separated value file instance.

    my $dir  = Sweet::HomeDir->new;
    my $file = Sweet::File::DSV->new(
        dir  => $dir,
        name => 'file.dat',
        sep  => '|',
    );

=head1 INHERITANCE

Inherits from C<Sweet::File>.

=head1 ATTRIBUTES

=head2 header

=head2 sep

Field separator. Must be provided at creation time or in a sub class with C<_build_sep> method.

=head1 METHODS

=head2 num_rows

    say $file->num_rows; # 2

=head2 field

    say $file->field(0); # FIELD_A
    say $file->field(1); # FIELD_B

=head2 fields

    my @fields = $file->fields; # ('FIELD_A', 'FIELD_B')

=head2 rows

    say $_ for $file->rows;
    # foo|bar
    # 2|3

=head1 SEE ALSO

L<Delimiter-separated values|https://en.wikipedia.org/wiki/Delimiter-separated_values> Wikipedia page.

=cut

