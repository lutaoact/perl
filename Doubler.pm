package Doubler;
use strict; use warnings;
my $data;
sub TIESCALAR
{
    my ($class, $data) = @_;
    bless \$data, $class;
}

sub FETCH
{
    my ($self) = @_;
    return 2 * $data;
}

sub STORE
{
    my $self = $_[0];
    $data = $_[1];
    return 2 * $data;
}

sub DESTROY{}
1;
