package Sweet::Dir;
use Moose;
use namespace::autoclean;
use MooseX::StrictConstructor;

use Try::Tiny;

use MooseX::Types::Path::Class;
use File::Path qw(make_path remove_tree);

=head1 SYNOPSIS

    my $dir = Sweet::Dir->new(path => '/path/to/dir');
    $dir->create;

=cut

has 'path' => (
builder=>'_build_path',
coerce=>1,
is=>'ro',
isa=>'Path::Class::Dir',
required=>1,
);

sub is_a_directory { 
return -d shift->path;
}

sub create {
my $self = shift;
my $path = $self->path;
my $make_path_error;

return $self if $self->is_a_directory;

make_path($path, {error => \$make_path_error});

#TODO lancia eccezione, scrivi classe eccezioni, test e aggiorna synopsis
}

sub erase {
my $self = shift;
my $path = $self->path;
my $remove_path_error;

remove_path($path, {error => \$remove_path_error});

#TODO lancia eccezione, scrivi classe eccezioni, test e aggiorna synopsis
}

__PACKAGE__->meta->make_immutable;

1;

