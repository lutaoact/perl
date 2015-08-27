use strict;
use warnings;
use Data::Dumper;

my $result = [
    {
        id => 1,
        start => 10,
        end => 15,
    },
    {
        id => 2,
        start => 20,
        end => 25,
    }
];

for my $row (@$result) {
    for my $key (keys %$row) {
        $row->{$key} += 1;
    }
}
print Dumper $result;
