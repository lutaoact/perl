#!/usr/bin/perl
use warnings; use strict;
our $n = 10;
my $square = square(15);
print "n is $n, square is $square\n";
sub square
{
    local $n = shift;
    printn();
    $n ** 2;
}

sub printn
{
    print "$n\n";
}
