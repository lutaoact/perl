package Person;
use Moose;
has 'first_name' => (is => 'rw', is => 'Str');
has 'last_name' => (is => 'rw', is => 'Str');
no Moose;
__PACKAGE__->meta->make_immutable;
