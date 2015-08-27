package IndirectCall;
use strict;
use warnings;

sub new {
    my ($class) = @_;
    my $self = {};
    bless $self, $class;
}

my $method = "new";
my $obj = __PACKAGE__->$method();#间接调用
print "success!\n";

1;
