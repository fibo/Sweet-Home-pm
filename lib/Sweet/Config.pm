package Sweet::Config;
use v5.12;
use Moose::Role;
use namespace::autoclean;

use UNIVERSAL::require;

requires qw(file_config);

has config => (
    default => sub {
        my $self = shift;

        my @namespace = @{ $self->_config_namespace };

        my $file_config = $self->file_config;

        my $config = $file_config->content;

        for (my $i = 0 ; $i < scalar(@namespace) ; $i++) {
            my $node = $namespace[$i];

            $config = $config->{$node};

            defined $config
                or croak "Could not found configuration entry in $file_config: " . join(' > ', @namespace[ 0 .. $i ]) . "\n";
        }


        return $config;
    },
    is   => 'ro',
    isa  => 'HashRef',
    lazy => 1,
);

=head1 ATTRIBUTI PRIVATI

=cut

=head2 _config_namespace

=cut

has _config_namespace => (
    builder => '_build_config_namespace',
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
);

sub _build_config_namespace {
    my $self = shift;

    my $package_name = $self->meta->name;

    my @namespace = split '::', $package_name;

    return \@namespace;
}

1;
__END__

=head2 config

=cut

