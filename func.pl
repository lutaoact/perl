#!/usr/bin/perl
use warnings; use strict;
use Math::BigInt;
use Math::Complex;
my $c1 = Math::Complex->new(-2, 3);
my $c2 = Math::Complex->new(4, 5);
my $c3 = $c1 * $c2;
print $c3, "\n";
