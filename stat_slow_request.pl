#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;

my $map = {};

while (my $line = <>) {
  if ($line !~ m/latency=[0-9.]+s/) {
    next;
  }

  #print $line;
  $line =~ m/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}/;
  $map->{$&}++;
}

#print Dumper $map;

foreach my $key (sort {$a cmp $b} keys %$map) {
  print $key, " ", $map->{$key}, "\n"
}
