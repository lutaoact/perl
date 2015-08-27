#!/usr/bin/perl
use warnings; use strict;
sub addem
{
    my %hash =
    (
        operand1 => 2,
        operand2 => 3,
        @_,
    );
    return $hash{operand1} + $hash{operand2};
}
print "The result is: ". addem(operand1 => 3);
