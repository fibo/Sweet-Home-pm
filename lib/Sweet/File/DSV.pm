package Sweet::File::DSV;
use v5.12;
use Moose;
use namespace::autoclean;

use Carp;
use Try::Tiny;

extends 'Sweet::File';

use Data::Dumper;

sub BUILDARGS {
    my ($class, %attribute) = @_;

    my $fields_arrayref = $attribute{fields};
    my $header          = $attribute{header};
    my $no_header       = $attribute{no_header};

    if ($no_header and $header) {
        confess "Argument no_header conflicts with header: $header";
    }

    if (defined $fields_arrayref) {

        # Needed 'cause init_arg does not work with Array trait.
        $attribute{_fields} = $fields_arrayref;
        delete $attribute{fields};
    }

    return \%attribute;
}

sub BUILD {
    my $self = shift;

    my (@fields, $header);

    my $separator = $self->separator;

    if ($self->is_a_plain_file) {

        # If file exists and attribute fields is provided, fill header.
        try {
            $header = $self->header;
        }
        catch {
            @fields = $self->fields;
            $header = join($separator, @fields);
        };

        $self->_write_header($header);
    }
}

has _fields => (
    builder => '_build_fields',
    handles => {
        field      => 'get',
        fields     => 'elements',
        num_fields => 'count',
    },
    is     => 'rw',
    isa    => 'ArrayRef[Str]',
    lazy   => 1,
    traits => ['Array'],
);

sub _build_fields {
    my $self = shift;

    my ($header, $separator, @fields);

    try {
        $header    = $self->header;
        $separator = $self->separator;

        @fields = $self->split_row->(0);
    }
    catch {
        confess "Cannot compute file fields", $_;
    };

    return \@fields;
}

has no_header => (
    default => sub { 0 },
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
);

has header => (
    builder => '_build_header',
    is      => 'rw',
    isa     => 'Maybe[Str]',
    lazy    => 1,
    writer  => '_write_header',
);

sub _build_header {
    my $self = shift;

    return if $self->no_header;

    my $header = $self->line(0);

    return $header;
}

has separator => (
    builder => '_build_separator',
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
);

has _rows => (
    builder => '_build_rows',
    traits  => ['Array'],
    handles => {
        num_rows => 'count',
        row      => 'get',
        rows     => 'elements',
    },
    is   => 'ro',
    isa  => 'ArrayRef[Str]',
    lazy => 1,
);

sub _build_rows {
    my $self = shift;

    my @rows = $self->lines;

    # Remove header, if any.
    shift @rows unless $self->no_header;

    return \@rows;
}

sub split_row {
    my $self = shift;

    my $separator = $self->separator;

    return $self->split_line->($separator);
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

=head2 no_header

=head2 separator

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

