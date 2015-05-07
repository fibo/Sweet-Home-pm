package Sweet::Now;
use Moose;
use namespace::autoclean;

has _time => (
    default=> sub {
my @time = localtime(time);

return \@time;
    },
    isa=>'ArrayRef',
is =>'ro',
required=>1,
);

has dd => (
    default => sub {
        sprintf "%02d", shift->mday
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

has hh => (
    default => sub {
        sprintf "%02d", shift->_time->[2]
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

has mday => (
    default => sub {
        shift->_time->[3]
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

has mi => (
    default => sub {
        sprintf "%02d", shift->_time->[1]
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

has mm => (
    default => sub {
        sprintf "%02d", shift->mon
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

has mon => (
    default => sub {
        shift->_time->[4]
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

has sec => (
    default => sub {
        shift->_time->[0]
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

has ss => (
    default => sub {
        sprintf "%02d", shift->sec
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

has year => (
    default => sub {
        shift->_time->[5]
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

has yyyy => (
    default => sub {
        my $year = shift->year;

        $year += 1900;

        return sprintf "%04d", $year;
    },
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
);

sub mihhss {
my $self = shift;

my $mi = $self->mi;
my $hh = $self->hh;
my $ss = $self->ss;

return "$mi$hh$ss";
}

sub yyyymmddmihhss {
my $self = shift;

my $yyyy = $self->yyyy;
my $mm = $self->mm;
my $dd = $self->dd;
my $mi = $self->mi;
my $hh = $self->hh;
my $ss = $self->ss;

return "$yyyy$mm$dd$mi$hh$ss";
}

sub yyyymmdd {
my $self = shift;

my $yyyy = $self->yyyy;
my $mm = $self->mm;
my $dd = $self->dd;

return "$yyyy$mm$dd";
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Sweet::File

=head1 SYNOPSIS

    use Sweet::Now;

    my $now = Sweet::Now->new;

    my $file2 = Sweet::File->new(path => '/path/to/file');

=head1 ATTRIBUTES

=head2 sec

=head2 min

=cut

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

my $yyyy = $year+1900;
$mon++;
my $mm = sprintf "%02d",$mon;
my $dd = sprintf "%02d",$mday;
my $hh = sprintf "%02d",$hour;
my $mi = sprintf "%02d",$min;
my $ss = sprintf "%02d",$sec;

say "$yyyy$mm$dd$hh$mi$ss";


