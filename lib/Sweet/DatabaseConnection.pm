package Sweet::DatabaseConnection;
use v5.12;
use Moose;
use namespace::autoclean;

has connection_attributes => (
    builder => '_build_connection_attributes',
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
);

sub _build_connection_attributes {
    return {
        PrintError  => 1,
        ora_charset => 'AL32UTF8',
    }
}

has datasource => (
    builder => '_build_datasource',
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
);

sub _build_datasource { shift->config->{datasource} }

has username => (
    builder => '_build_username',
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
);

sub _build_username { shift->config->{username} }

has password => (
    builder => '_build_password',
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
);

sub _build_password { shift->config->{password} }

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Sweet::DatabaseConnection

=head1 ATTRIBUTES

=head2 connection_attributes

You may want to override it in a child class, for example to connect to Oracle, with

    sub _build_connection_attributes {
        return {
            PrintError  => 1,
            ora_charset => 'AL32UTF8',
        }
    }

=head2 datasource

=head2 password

=head2 username

=cut

