#!/usr/bin/perl
use warnings; use strict;
use Data::Dumper qw(Dumper);
my %hash = qw(Fred Flintstone barney Rubble);
my @array = qw(Fred Flintstone Barney Rubble);
print Data::Dumper->Dump([\%hash, \@array], [qw(*hash *array)]);
