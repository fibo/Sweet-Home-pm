package Sweet::SFTP;
use v5.12;
use Moose;
use namespace::autoclean;

use Carp;
use Try::Tiny;

use Net::SFTP::Foreign;

has hostname => (
    builder => '_build_hostname',
    is       => 'ro',
    isa      => 'Str',
    lazy => 1,
);

has username => (
    builder => '_build_username',
    is       => 'ro',
    isa      => 'Str',
    lazy => 1,
);

has password => (
    builder => '_build_username',
    is       => 'ro',
    isa      => 'Str',
    lazy => 1,
);

has session => (
    builder => '_build_session',
    is      => 'ro',
    isa     => 'Net::SFTP::Foreign',
    lazy    => 1,
);

sub _build_session {
    my $self = shift;

    my $hostname = $self->hostname;
    my $username = $self->username;
    my $password = $self->password;

  my $session = try {
    Net::SFTP::Foreign->new(
        $hostname,
        user=> $username,
        password => $password,
        autodie => 1,
    );
    }
    catch {
        confess "Unable to open SFTP session: $_";
    };

    return $session;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Sweet::SFTP

=head1 SYNOPSIS

    use Sweet::SFTP;

    my $sftp = Sweet::SFTP->new(
        hostname => 'sftp.example.org',
        username => 'foo',
        password => 'secr3t',
    );

    my $session = $sftp->session;

=head1 ATTRIBUTES

=head2 session

=head2 hostname

=head2 username

=head2 password

=cut

