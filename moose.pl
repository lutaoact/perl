package Example::Animal;
use Moose::Role;

has 'name' => (is => 'rw', isa => 'Str', required => 1);
requires 'roar';

1;

package Example::Dog;
use Moose;

with 'Example::Animal';
has 'age' => (is => 'rw', isa => 'Int', required => 1);

sub roar {
        print "wang wang wang\n";
}

no Moose;
__PACKAGE__->meta->make_immutable;
