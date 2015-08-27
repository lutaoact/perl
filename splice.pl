#!/usr/bin/perl
use warnings; use strict;
my @d = (1 .. 9);
my @e = ('a' .. 'f');
splice(@d, 2, 2, @e), "\n";
#print splice(@d, 2, 6), "\n";
print splice(@d, 2), "\n";
print @d;
