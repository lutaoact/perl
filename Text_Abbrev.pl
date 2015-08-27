#!/usr/bin/perl
use warnings; use strict;
use Text::Abbrev;
my %hash = abbrev qw(Now is the time);
my ($key, $value);
while (($key, $value) = each %hash)
{
    print "$key => $value\n";
}
