#!/usr/bin/perl
use warnings; use strict;
use integer;
my $dec_value = 258;
print "$dec_value in hex = ";
my @hex_digits;
while($dec_value)
{
    unshift @hex_digits, (0 .. 9, 'a' .. 'f')[$dec_value & 15];
    $dec_value /= 16;
}
print @hex_digits;
