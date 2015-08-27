package User;
use DateTime;
use Moose;
extends 'Person';
has 'password' => (is => 'rw', is => 'Str');
has 'last_login' => (is => 'rw', isa => 'DateTime', handles => {'date_of_last_login' => 'date'});
sub login
{
    my ($self, $pw) = @_;
    return 0 if $pw ne $self->password;
    $self->last_login(DateTime->now());
    return 1;
}
no Moose;
__PACKAGE__->meta->make_immutable;
