#!/usr/bin/perl
use warnings; use strict;
$_ = "Hello there, neighbor!";
my ($first, $second, $third) = /(\S+) (\S+), (\S+)/g;
my @a = /\S+ \S+, \S+/g;
print "$second is my $third\n";
print @a . "\n";
