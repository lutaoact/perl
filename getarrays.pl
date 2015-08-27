#!/usr/bin/perl
use warnings; use strict;
our (@a, @b);
sub getarrays
{
    local @a = (1, 2, 3);
    local @b = (4, 5, 6);
    return \@a, \@b;
}
my ($aref, $bref) = getarrays;
print "@$aref\n";
print "@$bref\n";
